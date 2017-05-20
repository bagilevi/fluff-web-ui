defmodule Fluff.Run do
  @moduledoc """
    A single run, possibly on multiple threads.
  """

  defstruct [:uuid, :project_path, :lib_paths]
end
