defmodule Fluff.Event do
  @derive [Poison.Encoder]
  defstruct [:run_uuid, :type, :id, :description, :full_description,
             :status, :file_path, :line_number, :run_time, :pending_message,
             :exception]

  def parse(payload) do
    Poison.Parser.parse!(payload, as: %Fluff.Event{})
  end
end
