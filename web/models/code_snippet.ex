defmodule Fluff.CodeSnippet do
  alias Fluff.CodeSnippet
  alias Fluff.CodeSnippet.Line

  defstruct [:lines]

  defmodule Line do
    alias Fluff.CodeSnippet.Line

    defstruct [:number, :highlight, :content]
  end

  def build(failure, run) do
    backtrace_item = Enum.find(failure.exception.backtrace, nil, fn item ->
      item.is_project
    end)

    if backtrace_item do
      case file_result = File.read(backtrace_item.path) do
        {:ok, content} ->
          lines = String.split(content, ["\r\n", "\n", "\r"])
          number = backtrace_item.line
          %CodeSnippet{
            lines:
              (number - 15 .. number + 15) |> Enum.map(fn iter_number ->
                %Line{
                  number: iter_number,
                  highlight: (iter_number == number),
                  content: lines |> Enum.at(iter_number - 1)
                }
              end)
          }
        _ ->
          require Logger
          Logger.warn("Could not read #{backtrace_item.path}: #{inspect file_result}")
          nil
      end
    end
  end
end
