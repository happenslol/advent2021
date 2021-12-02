defmodule Util do
  def lines(filename, options \\ []) do
    lines =
      File.read!(filename)
      |> String.split("\n")

    if options == :trim,
      do:
        lines
        |> Enum.filter(fn s ->
          String.trim(s) != ""
        end),
      else: lines
  end

  def parse_ints(list) do
    Enum.map(list, fn x ->
      with {n, _} <- Integer.parse(x), do: n
    end)
  end
end
