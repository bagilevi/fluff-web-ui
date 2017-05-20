defmodule Fluff.Backtrace do
  alias Fluff.Backtrace
  alias Fluff.Backtrace.Item

  def build(raw, env) do
    Enum.map(raw, fn item -> Item.build(item, env) end)
  end

  defmodule Item do
    alias Fluff.Backtrace.Item

    defstruct [:path, :line, :note,
               :outer_path, :inner_path, :is_project, :container_name]

    def build(line, env) do
      [path, after_path] = String.split(line, ":", parts: 2)
      [line, note] = String.split(after_path, [":", ";", ",", " "], parts: 2)
      line = String.to_integer(line)

      if String.starts_with?(path, env.project_path) do
        %Item{
          path: path,
          line: line,
          note: note,
          outer_path: env.project_path,
          inner_path: String.slice(path, String.length(env.project_path)+1 .. -1),
          is_project: true,
          container_name: String.split(env.project_path, "/") |> List.last
        }
      else
        Enum.find_value(env.lib_paths, nil, fn [lib_name, lib_path] ->
          if String.starts_with?(path, lib_path) do
            %Item{
              path: path,
              line: line,
              note: note,
              outer_path: lib_path,
              inner_path: String.slice(path, String.length(lib_path)+1 .. -1),
              is_project: false,
              container_name: lib_name
            }
          end
        end) ||
          %Item{
            path: path,
            line: line,
            note: note,
            outer_path: nil,
            inner_path: path,
            is_project: false,
            container_name: nil
          }
      end
    end
  end
end
