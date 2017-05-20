defmodule Fluff.ShoutHandler do
  alias Fluff.Run
  alias Fluff.RunTracker
  alias Fluff.Failure

  def handle(payload) do
    shout = Fluff.Shout.parse(payload)


    # IO.inspect shout

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

        case shout.status do
          "passed" ->
            increment_counter(:passed, shout)

          "failed" ->
            increment_counter(:failed, shout)

            run = RunTracker.load(shout.run_uuid)
            failure = Failure.build(shout, run)

            Fluff.Endpoint.broadcast!("project:1", "new_failure", %{
              snippet_html: render("failure_snippet.html", failure: failure),
              html:         render("failure_details.html", failure: failure)
            })

          "pending" ->
            increment_counter(:pending, shout)

          _ -> :ok

        end

      "end_run" ->
        Fluff.Endpoint.broadcast!("project:1", "finished", %{})

        stats = Fluff.RunStats.set(shout.run_uuid, :finished, true)
        push_stats(stats)

      _ -> :ok
    end
  end

  def increment_counter(key, shout) do
    stats = Fluff.RunStats.add(shout.run_uuid, key)
    push_stats(stats)
  end

  def push_stats(stats) do
    Fluff.Endpoint.broadcast!("project:1", "stats", %{
      html: render("stats.html", stats: stats)
    })
  end

  def render(name, assigns) do
    Phoenix.View.render_to_string(Fluff.ShoutView, name, assigns)
  end
end
