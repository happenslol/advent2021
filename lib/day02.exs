defmodule Day02 do
  # First puzzle
  def apply_instr({"forward", n}, {x, y}), do: {x + n, y}
  def apply_instr({"down", n}, {x, y}), do: {x, y + n}
  def apply_instr({"up", n}, {x, y}), do: {x, y - n}

  # Second puzzle
  def apply_instr({"forward", n}, {x, y, z}), do: {x + n, y + n * z, z}
  def apply_instr({"down", n}, {x, y, z}), do: {x, y, z + n}
  def apply_instr({"up", n}, {x, y, z}), do: {x, y, z - n}

  def result({x, y, _}), do: x * y
  def result({x, y}), do: x * y
end

commands =
  File.read!("inputs/day02.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn it ->
    [dir, dist] = String.split(it, " ")
    {dir, with({n, _} <- Integer.parse(dist), do: n)}
  end)

first =
  Enum.reduce(commands, {0, 0}, &Day02.apply_instr/2)
  |> Day02.result()

IO.puts("First result: #{first}")

second =
  Enum.reduce(commands, {0, 0, 0}, &Day02.apply_instr/2)
  |> Day02.result()

IO.puts("Second result: #{second}")
