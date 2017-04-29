defmodule Fluff.ShoutHandler do
  def handle(payload) do
    shout = Fluff.Shout.parse(payload)

    IO.inspect shout
    html = Phoenix.View.render_to_string(Fluff.PageView, "snippet.html", shout: shout)

    if shout.status == "failed" do
      Fluff.Endpoint.broadcast!("project:1", "new_failure", %{
        html: html
      })
    end
  end
end
