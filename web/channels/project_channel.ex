defmodule Fluff.ProjectChannel do
  use Phoenix.Channel

  def join("project:" <> project_id, _params, socket) do
    {:ok, socket}
  end
end
