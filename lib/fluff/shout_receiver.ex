defmodule Fluff.ShoutReceiver do
  use GenServer

  def start_link do
    {:ok, conn} = Redix.PubSub.start_link()

    {:ok, pid} = GenServer.start_link(__MODULE__, [ conn: conn ])
    {:ok, pid}
  end

  def init(state = [conn: conn]) do
    Redix.PubSub.subscribe(conn, "fluff_shouts", self())
    {:ok, state}
  end

  def handle_info({:redix_pubsub, _, :subscribed, %{channel: "fluff_shouts"}}, state) do
    # IO.puts "Subscribed."
    {:noreply, state}
  end

  def handle_info({:redix_pubsub, _, :message, %{channel: "fluff_shouts", payload: payload}}, state) do
    # IO.puts "Shout received:"
    # IO.inspect payload
    Fluff.ShoutHandler.handle(payload)
    {:noreply, state}
  end
end
