defmodule Grades.Summary do
  @moduledoc """
  Provides methods to evaluate and summarize course information,
  as well as pretty print the information.
  """

  @enforce_keys [:credits, :pcredits, :wmean, :pending]
  defstruct [:credits, :pcredits, :wmean, :pending]

  alias Grades.Summary

  @doc """
  Evaluates the given course information and produces
  a summary containing the most interesting information.

  The summary is returned as a `{credits, pcredits, wmean, pending}` tuple:

  * `credits`  - Current credit points
  * `pcredits` - Credit points with pending courses added
  * `wmean`    - Weighted mean grade
  * `pending`  - A list containing the names of pending courses
  """
  def summarize(course_info) do
    %Summary{
      credits:  credit_sum(course_info),
      pcredits: pending_credits_sum(course_info),
      wmean:    weighted_mean_grade(course_info),
      pending:  pending_courses(course_info)
    }
  end

  defp credit_sum(course_info) do
    course_info
    |> Enum.reject(fn {_,_,g} -> g == :pending end)
    |> Enum.reduce(0, fn({_,c,_}, acc) -> acc + c end)
  end

  defp pending_credits_sum(course_info) do
    Enum.reduce(course_info, 0, fn({_,c,_}, acc) -> acc + c end)
  end

  defp weighted_mean_grade(course_info) do
    course_info
    |> Enum.reject(fn {_,_,g} -> g in [:ungraded, :pending] end)
    |> Enum.reduce({0,0}, fn({_,c,g}, {acc_c, acc_wgs}) -> {acc_c + c, acc_wgs + (c * g)} end)
    |> divide_grade
  end

  defp divide_grade({0, 0}),                        do: 0
  defp divide_grade({credits, weighted_grade_sum}), do: weighted_grade_sum / credits

  defp pending_courses(course_info) do
    course_info
    |> Enum.filter(fn {_,_,g} -> g == :pending end)
    |> Enum.map(fn {c,_,_} -> c end)
  end

  @doc """
  Returns a string containing the summary information in
  a format suitable for printing (e.g. to the command line
  or a text file).
  """
  def print_format(summary = %Summary{}) do
    """
    Grades Summary:

    Current Credit Points:   #{summary.credits}
    CP with pending courses: #{summary.pcredits}

    Weighted Mean Grade:     #{summary.wmean}

    Pending courses:         #{Enum.join(summary.pending, ", ")}
    """
  end
end