defmodule Fluff.ShoutHandler do
  alias Fluff.Run
  alias Fluff.RunTracker
  alias Fluff.Failure
  alias Fluff.CodeSnippet

  def handle(payload) do
    shout = Fluff.Shout.parse(payload)

    case shout.type do
      "start_run" ->
        Fluff.Endpoint.broadcast!("project:1", "started", %{})
        push_stats(%{})

      "start" ->
        run = %Run{uuid: shout.run_uuid,
                   project_path: shout.project_path,
                   lib_paths: shout.lib_paths}
        RunTracker.save_run(run)

      "example_result" ->
        if run = RunTracker.load(shout.run_uuid) do
          handle_example_result(shout, run)
        end

      "end_run" ->
        if run = RunTracker.load(shout.run_uuid) do
          Fluff.Endpoint.broadcast!("project:1", "finished", %{})

          stats = Fluff.RunStats.set(shout.run_uuid, :finished, true)
          push_stats(stats, :finished)
        end

      _ -> :ok
    end
  end

  defp handle_example_result(shout, run) do
    case shout.status do
      "passed" ->
        increment_counter(:passed, shout)

      "failed" ->
        increment_counter(:failed, shout)

        failure = Failure.build(shout, run)

        code_snippet = CodeSnippet.build(failure, run)

        Fluff.Endpoint.broadcast!("project:1", "new_failure", %{
          snippet_html: render("failure_snippet.html", failure: failure),
          html:         render("failure_details.html", failure: failure, code_snippet: code_snippet),
        })

      "pending" ->
        increment_counter(:pending, shout)

      _ -> :ok
    end
  end

  def increment_counter(key, shout) do
    stats = Fluff.RunStats.add(shout.run_uuid, key)
    push_stats(stats)
  end

  def push_stats(stats, status \\ nil) do
    Fluff.Endpoint.broadcast!("project:1", "stats", %{
      finished: status == :finished,
      success: ((stats[:passed] || 0) > 1 && (stats[:failed] || 0) == 0),
      html: render("stats.html", stats: stats)
    })
  end

  def render(name, assigns) do
    Phoenix.View.render_to_string(Fluff.ShoutView, name, assigns)
  end
end
