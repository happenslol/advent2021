count_incs = fn x, {prev, acc} ->
  {x, if(prev > 0 && x > prev, do: acc + 1, else: acc)}
end

numbers =
  File.read!("inputs/day01-1.txt")
  |> String.split("\n")
  |> Enum.filter(fn s -> String.trim(s) != "" end)
  |> Enum.map(fn x -> with {n, _} <- Integer.parse(x), do: n end)

{_, first} =
  numbers
  |> Enum.reduce({0, 0}, count_incs)

IO.puts("First result: #{first}")

{_, second} =
  numbers
  |> Enum.chunk_every(3, 1)
  |> Enum.map(&Enum.sum/1)
  |> Enum.reduce({0, 0}, count_incs)

IO.puts("Second result: #{second}")
