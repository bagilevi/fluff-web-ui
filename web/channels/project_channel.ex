defmodule Fluff.ProjectChannel do
  use Phoenix.Channel

  def join("project:" <> project_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("event", payload, socket) do
    broadcast!(socket, "event", payload)
    {:noreply, socket}
  end

  def handle_out("event", payload, socket) do
    push socket, "event", payload
    {:noreply, socket}
  end

end
