defmodule Day06 do
  def run(populations, 0) do
    populations
    |> Map.values()
    |> Enum.sum()
  end

  def run(populations, days) do
    step =
      populations
      |> Enum.map(fn {population, count} ->
        {population - 1, count}
      end)
      |> Map.new()

    spawning = Map.get(step, -1, 0)

    next =
      step
      |> Map.put(8, spawning)
      |> Map.put(6, spawning + Map.get(step, 6, 0))
      |> Map.delete(-1)

    run(next, days - 1)
  end
end

input = File.read!("inputs/day06.txt")

populations =
  input
  |> String.split(",", trim: true)
  |> Enum.map(fn x -> x |> Integer.parse() |> elem(0) end)
  |> Enum.reduce(%{}, fn x, acc ->
    Map.put(acc, x, Map.get(acc, x, 0) + 1)
  end)

first = Day06.run(populations, 80)
IO.puts("first result: #{first}")

second = Day06.run(populations, 256)
IO.puts("second result: #{second}")
