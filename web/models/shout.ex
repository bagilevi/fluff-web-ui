defmodule Fluff.Shout do
  @derive [Poison.Encoder]
  defstruct [:run_uuid, :type, :id, :description, :full_description,
             :status, :file_path, :line_number, :run_time, :pending_message,
             :exception]

  def parse(payload) do
    Poison.decode!(payload, as: %Fluff.Shout{})
  end

  def brief(shout) do
    "#{shout.status}"
  end
end
