defmodule Fluff.Exception do
  alias Fluff.Exception
  alias Fluff.Backtrace

  defstruct [:class,
             :message,
             :backtrace]

  def build(raw, env) do
    %Exception{
      class:     raw["class"],
      message:   raw["message"],
      backtrace: Backtrace.build(raw["backtrace"], env)
    }
  end
end
