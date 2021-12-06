defmodule Day04 do
  def find_first_winner([n | rest], boards) do
    new_boards = apply_number(n, boards)
    maybe_winner = find_winning_board(new_boards)

    if maybe_winner != nil do
      {Enum.at(new_boards, maybe_winner), n}
    else
      find_first_winner(rest, new_boards)
    end
  end

  def find_last_winner(numbers, boards, last_winner \\ nil)

  def find_last_winner([], _boards, last_winner), do: last_winner

  def find_last_winner(_numbers, [], last_winner), do: last_winner

  def find_last_winner([n | rest], boards, last_winner) do
    new_boards = apply_number(n, boards)
    maybe_winner = find_winning_board(new_boards)

    if maybe_winner != nil do
      winner = {Enum.at(new_boards, maybe_winner), n}
      filtered = Enum.filter(new_boards, &(!wins?(&1)))
      find_last_winner(rest, filtered, winner)
    else
      find_last_winner(rest, new_boards, last_winner)
    end
  end

  def unmarked_sum(board) do
    board
    |> Enum.map(fn row ->
      row
      |> Enum.filter(&(!elem(&1, 1)))
      |> Enum.map(&elem(&1, 0))
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  defp find_winning_board(boards) do
    Enum.find_index(boards, &wins?(&1))
  end

  defp wins?(board) do
    row_length =
      board
      |> List.first()
      |> length

    has_winning_row = fn ->
      board
      |> Enum.any?(fn row ->
        row |> Enum.all?(&elem(&1, 1))
      end)
    end

    has_winning_col = fn ->
      Enum.to_list(0..(row_length - 1))
      |> Enum.any?(fn x ->
        board
        |> Enum.all?(fn row ->
          row
          |> Enum.at(x)
          |> elem(1)
        end)
      end)
    end

    has_winning_row.() || has_winning_col.()
  end

  defp apply_number(n, boards) do
    boards
    |> Enum.map(&Task.async(fn -> apply_to_board(n, &1) end))
    |> Enum.map(&Task.await/1)
  end

  defp apply_to_board(n, board), do: Enum.map(board, &apply_to_row(n, &1))

  defp apply_to_row(n, row) do
    row |> Enum.map(fn {k, v} -> {k, k == n || v} end)
  end
end

input = File.read!("inputs/day04.txt")

board_row_count = 5
lines = input |> String.split("\n", trim: true)

numbers =
  lines
  |> List.first()
  |> String.split(",")
  |> Enum.map(&Integer.parse/1)
  |> Enum.map(&elem(&1, 0))

boards =
  lines
  |> Enum.drop(1)
  |> Enum.chunk_every(board_row_count)
  |> Enum.map(fn board ->
    board
    |> Enum.map(fn row ->
      row
      |> String.split(" ", trim: true)
      |> Enum.map(fn str ->
        {x, _} = Integer.parse(str)
        {x, false}
      end)
    end)
  end)

first =
  Day04.find_first_winner(numbers, boards)
  |> then(fn {board, n} ->
    Day04.unmarked_sum(board) * n
  end)

IO.puts("first result: #{first}")

second =
  Day04.find_last_winner(numbers, boards)
  |> then(fn {board, n} ->
    Day04.unmarked_sum(board) * n
  end)

IO.puts("second result: #{second}")
