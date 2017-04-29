defmodule Fluff.ShoutHandler do
  def handle(payload) do
    shout = Fluff.Shout.parse(payload)

    IO.inspect shout

    if shout.status == "failed" do
      Fluff.Endpoint.broadcast!("project:1", "new_failure", %{
        snippet_html: Phoenix.View.render_to_string(Fluff.ShoutView, "failure_snippet.html", shout: shout),
        html: Phoenix.View.render_to_string(Fluff.ShoutView, "failure_details.html", shout: shout)
      })
    end
  end
end
