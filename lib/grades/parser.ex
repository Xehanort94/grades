defmodule Grades.Parser do
  @moduledoc """
  Provides methods to parse course information from a grade file.
  """

  @doc """
  Parses a grade file and turns it into a list of course info.

  Returns `{:ok, course_info}` on success, or `{:error, reason}`
  if the parsing fails.

  The returned `course_info` is a list consisting of course info entries,
  where each entry is a `{course, credits, grade}` tuple.

  The `grade` entry can be one of the following:

  * `grade` - the grade as a floating point number
  * `:ungraded` - for ungraded courses
  * `:pending` - for courses where no result has been received yet
  """
  def parse(content) do
    with lines <- String.split(content, "\n", trim: true),
         :ok   <- lines_valid?(lines)
    do
      course_info = parse_lines(lines)
      {:ok, course_info}
    end
  end
  
  defp lines_valid?(lines) do
    case Enum.reject(lines, &line_valid?/1) do
      []            -> :ok
      invalid_lines -> {:error, ~s/invalid lines in parsed content:\n#{Enum.join(invalid_lines, "\n")}/}
    end
  end

  defp line_valid?(line) do
    Regex.match?(~r/^[^,]+,\s*\p{N}+\s*,\s*(([0-9]+\.)?[0-9]+|u|ungraded|p|pending)\s*$/, line)
  end

  defp parse_lines(lines) do
    lines
    |> Enum.map(&parse_line/1)
    |> Enum.map(&to_course_info/1)
  end

  defp parse_line(line) do
    line
    |> String.split(",")
    |> Enum.map(&String.trim/1)
  end

  defp to_course_info([course, credits, grade]) do
    {course, String.to_integer(credits), grade(grade)}
  end

  defp grade("u"),        do: :ungraded
  defp grade("ungraded"), do: :ungraded
  defp grade("p"),        do: :pending
  defp grade("pending"),  do: :pending
  defp grade(grade),      do: String.to_float(grade)
end