defmodule Fluff.CodeSnippet do
  alias Fluff.CodeSnippet
  alias Fluff.CodeSnippet.Line

  defstruct [:lines, :starting_line, :failing_line]

  defmodule Line do
    alias Fluff.CodeSnippet.Line

    defstruct [:number, :highlight, :content]
  end

  def build(failure, run) do
    backtrace_item = Enum.find(failure.exception.backtrace, nil, fn item ->
      item.is_project
    end)

    if backtrace_item do
      full_path =
        if String.starts_with?(backtrace_item.path, "/") do
          backtrace_item.path
        else
          "#{run.project_path}/#{backtrace_item.path}"
        end
      case file_result = File.read(full_path) do
        {:ok, content} ->
          lines = String.split(content, ["\r\n", "\n", "\r"])
          number = backtrace_item.line
          starting_line = max(number - 100, 1)
          finishing_line = min(number + 100, Enum.count(lines))
          %CodeSnippet{
            starting_line: starting_line,
            failing_line: number,
            lines: Enum.slice(lines, starting_line - 1 .. finishing_line - 1)
          }
        _ ->
          require Logger
          Logger.warn("Could not read #{backtrace_item.path}: #{inspect file_result}")
          nil
      end
    end
  end
end
