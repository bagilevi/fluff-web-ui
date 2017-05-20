defmodule Fluff.Failure do
  alias Fluff.Failure
  alias Fluff.Exception

  defstruct [:description,
             :full_description,
             :file_path,
             :line_number,
             :run_time,
             :exception]

  def build(shout, run) do
    %Failure{
      description:      shout.description,
      full_description: shout.full_description,
      file_path:        shout.file_path,
      line_number:      shout.line_number,
      run_time:         shout.run_time,
      exception:        Exception.build(shout.exception, run)
    }
  end
end
