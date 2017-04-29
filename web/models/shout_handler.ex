defmodule Fluff.ShoutHandler do
  def handle(payload) do
    shout = Fluff.Shout.parse(payload)

    # IO.inspect shout

    case shout.status do
      "passed" ->
        increment_counter(:passed, shout)

      "failed" ->
        increment_counter(:failed, shout)
        Fluff.Endpoint.broadcast!("project:1", "new_failure", %{
          snippet_html: render("failure_snippet.html", shout: shout),
          html:         render("failure_details.html", shout: shout)
        })

      "pending" ->
        increment_counter(:pending, shout)

      _ -> :ok
    end
  end

  def increment_counter(key, shout) do
    stats = Fluff.RunStats.add(shout.run_uuid, key)
    Fluff.Endpoint.broadcast!("project:1", "stats", %{
      html: render("stats.html", stats: stats)
    })
  end

  def render(name, assigns) do
    Phoenix.View.render_to_string(Fluff.ShoutView, name, assigns)
  end
end
