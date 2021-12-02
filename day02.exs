commands =
  File.read!("inputs/day02.txt")
  |> String.split("\n")
  |> Enum.filter(fn s -> String.trim(s) != "" end)
  |> Enum.map(fn it ->
    [dir, dist] = String.split(it, " ")
    {dir, with({n, _} <- Integer.parse(dist), do: n)}
  end)

first =
  commands
  |> Enum.reduce({0, 0}, fn it, {fwd, depth} ->
    case it do
      {"forward", dist} -> {fwd + dist, depth}
      {"up", dist} -> {fwd, depth - dist}
      {"down", dist} -> {fwd, depth + dist}
    end
  end)
  |> then(fn it ->
    with {fwd, depth} <- it, do: fwd * depth
  end)

IO.puts("First result: #{first}")

second =
  commands
  |> Enum.reduce({0, 0, 0}, fn it, {fwd, depth, aim} ->
    case it do
      {"forward", dist} -> {fwd + dist, depth + dist * aim, aim}
      {"up", amount} -> {fwd, depth, aim - amount}
      {"down", amount} -> {fwd, depth, aim + amount}
    end
  end)
  |> then(fn it ->
    with {fwd, depth, _} <- it, do: fwd * depth
  end)

IO.puts("Second result: #{second}")
