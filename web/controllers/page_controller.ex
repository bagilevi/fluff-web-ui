defmodule Fluff.PageController do
  use Fluff.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
