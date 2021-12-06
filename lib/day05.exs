defmodule Day05 do
  def mark_lines(m, x1, y1, x2, y2, opts \\ nil)

  # Diagonal line
  def mark_lines(m, x1, y1, x2, y2, diagonal: true)
      when abs(x1 - x2) == abs(y1 - y2) do
    Enum.zip([x1..x2, y1..y2])
    |> Enum.reduce(m, fn {x, y}, acc ->
      key = {x, y}
      Map.put(acc, key, Map.get(acc, key, 0) + 1)
    end)
  end

  # Horizontal line
  def mark_lines(m, x1, y1, x2, y2, _opts) when x1 == x2 do
    y1..y2
    |> Enum.reduce(m, fn y, acc ->
      key = {x1, y}
      Map.put(acc, key, Map.get(acc, key, 0) + 1)
    end)
  end

  # Vertical line
  def mark_lines(m, x1, y1, x2, y2, _opts) when y1 == y2 do
    x1..x2
    |> Enum.reduce(m, fn x, acc ->
      key = {x, y1}
      Map.put(acc, key, Map.get(acc, key, 0) + 1)
    end)
  end

  def mark_lines(m, _x1, _y1, _x2, _y2, _opts), do: m

  def print_grid(m) do
    {max_x, _} = Map.keys(m) |> Enum.max_by(fn {x, _} -> x end)
    {_, max_y} = Map.keys(m) |> Enum.max_by(fn {_, y} -> y end)

    Enum.map(0..max_y, fn y ->
      Enum.map(0..max_x, fn x ->
        IO.write("#{Map.get(m, {x, y}, 0)} ")
      end)

      IO.write("\n")
    end)

    m
  end
end

input = File.read!("inputs/day05.txt")

coords =
  input
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    line
    |> String.split(" -> ")
    |> Enum.map(fn parts ->
      parts
      |> String.split(",")
      |> Enum.map(fn coord ->
        coord
        |> Integer.parse()
        |> elem(0)
      end)
    end)
    |> Enum.map(fn [c1, c2] ->
      {c1, c2}
    end)
  end)

first =
  coords
  |> Enum.reduce(%{}, fn [{x1, y1}, {x2, y2}], acc ->
    Day05.mark_lines(acc, x1, y1, x2, y2)
  end)
  |> Map.values()
  |> Enum.count(&(&1 > 1))

IO.puts("first result: #{first}")

second =
  coords
  |> Enum.reduce(%{}, fn [{x1, y1}, {x2, y2}], acc ->
    Day05.mark_lines(acc, x1, y1, x2, y2, diagonal: true)
  end)
  |> Map.values()
  |> Enum.count(&(&1 > 1))

IO.puts("second result: #{second}")
