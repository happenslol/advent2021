defmodule Day03 do
  defp filter_criteria(list, i, crit) do
    Enum.filter(list, fn x -> String.at(x, i) == crit end)
  end

  def filter_col(rows, cmp, i \\ 0)

  def filter_col(rows, _cmp, _i) when length(rows) == 1, do: List.first(rows)

  def filter_col(rows, cmp, i) do
    row_crit = get_crit_str(rows, cmp)
    crit_char = String.at(row_crit, i)
    new_rows = filter_criteria(rows, i, crit_char)

    filter_col(new_rows, cmp, i + 1)
  end

  def get_crit_str(rows, cmp) do
    cols =
      Enum.reduce(rows, %{}, fn row, acc ->
        Enum.reduce(String.graphemes(row), {acc, 0}, fn c, {cols, i} ->
          {Map.put(cols, i, Map.get(cols, i, "") <> c), i + 1}
        end)
        |> elem(0)
      end)

    Enum.reduce(Map.values(cols), "", fn col, acc ->
      c0 = Enum.count(String.graphemes(col), fn x -> x == "0" end)
      c1 = Enum.count(String.graphemes(col), fn x -> x == "1" end)
      acc <> cmp.(c0, c1)
    end)
  end
end

lines = Util.lines("inputs/day03.txt", :trim)

gamma_str = Day03.get_crit_str(lines, fn c0, c1 -> if(c1 > c0, do: "1", else: "0") end)
epsilon_str = Day03.get_crit_str(lines, fn c0, c1 -> if(c0 > c1, do: "1", else: "0") end)

{gamma, _} = Integer.parse(gamma_str, 2)
{epsilon, _} = Integer.parse(epsilon_str, 2)
first = gamma * epsilon
IO.puts("first result: #{first}")

gen_str = Day03.filter_col(lines, fn c0, c1 -> if(c1 >= c0, do: "1", else: "0") end)
scrub_str = Day03.filter_col(lines, fn c0, c1 -> if(c0 <= c1, do: "0", else: "1") end)

{gen, _} = Integer.parse(gen_str, 2)
{scrub, _} = Integer.parse(scrub_str, 2)
second = gen * scrub

IO.puts("second result: #{second}")
