numbers = Util.lines("inputs/day01.txt", :trim) |> Util.parse_ints()

first =
  Enum.chunk_every(numbers, 2, 1, :discard)
  |> Enum.count(fn [x, y] -> y > x end)

IO.puts("First result: #{first}")

second =
  Enum.chunk_every(numbers, 3, 1)
  |> Enum.map(&Enum.sum/1)
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.count(fn [x, y] -> y > x end)

IO.puts("Second result: #{second}")
