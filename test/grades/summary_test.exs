defmodule Grades.SummaryTest do
  use ExUnit.Case
  doctest Grades.Summary

  alias Grades.Summary

  @delta 1.0e-15

  test "summarizes a single course" do
    input    = [{"course", 5, 1.0}]
    expected = %Summary{credits: 5, pcredits: 5, wmean: 1.0, pending: []}

    assert(Summary.summarize(input) == expected)
  end

  test "summarizes multiple courses" do
    input = [{"course1", 5, 1.0}, {"course2", 3, 3.0}]
    
    assert(
      %Summary{
        credits:  8,
        pcredits: 8,
        wmean:    a_wmean,
        pending:  []
      } = Summary.summarize(input)
    )

    assert_in_delta(a_wmean, 1.75, @delta)
  end
  
  test "summarizes single pending course" do
    input    = [{"course", 5, :pending}]
    expected = %Summary{credits: 0, pcredits: 5, wmean: 0, pending: ["course"]} 

    assert(Summary.summarize(input) == expected)
  end

  test "summarizes single ungraded course" do
    input    = [{"course", 5, :ungraded}]
    expected = %Summary{credits: 5, pcredits: 5, wmean: 0, pending: []}

    assert(Summary.summarize(input) == expected)
  end

  test "summarizes multiple course with pending and ungraded courses" do
    input = [{"course1", 5, 1.0},
             {"course2", 3, 3.0},
             {"course3", 5, :pending},
             {"course4", 5, :ungraded}]
    
    assert(
      %Summary{
        credits:  13,
        pcredits: 18,
        wmean:    a_wmean,
        pending:  ["course3"]
      } = Summary.summarize(input)
    )

    assert_in_delta(a_wmean, 1.75, @delta)
  end
end