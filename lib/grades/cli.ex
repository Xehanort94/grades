defmodule Grades.CLI do
  @moduledoc """
  Grades CLI client.
  """

  alias Grades.Parser
  alias Grades.Summary

  @doc """
  This function is supposed to be called from the commandline,
  passing the target grade file as the single argument.

  The Grades utility will parse and evaluate the grade file
  and print a summary to the console.
  """
  def main(args) do
    with {:ok, path}        <- parse_args(args),
         {:ok, data}        <- open_grade_file(path),
         {:ok, course_info} <- Parser.parse(data)
    do
      course_info
      |> Summary.summarize
      |> Summary.print_format
      |> IO.puts
    else 
      {:error, message} -> print_error(message)
    end
  end

  defp parse_args([grade_file]) do
    if File.exists?(grade_file) do
      {:ok, grade_file}
    else
      {:error, "file doesn't exist"}
    end
  end

  defp parse_args(_) do
    {:error, "invalid argument count"}
  end

  defp open_grade_file(path) do
    case File.read(path) do
      {:ok, content}  -> {:ok, content}
      {:error, posix} -> {:error, "cannot read file, reason: #{Atom.to_string(posix)}"}
    end
  end

  defp print_error(message) do
    IO.puts("An error occured: #{message}")
  end
end