defmodule Grades.ParserTest do
  use ExUnit.Case
  doctest Grades.Parser

  alias Grades.Parser
  
  @delta 1.0e-15

  test "parses single line with grade" do
    input = "course,5,1.0"

    assert({:ok, [{a_course, a_credits, a_grade}]} = Parser.parse(input))

    assert(a_course  == "course")
    assert(a_credits == 5)
    assert_in_delta(a_grade, 1.0, @delta)
  end

  test "parses single line with ungraded course" do
    input_u        = "course,5,u"
    input_ungraded = "course,5,ungraded"

    assert({:ok, [{"course", 5, :ungraded}]} = Parser.parse(input_u))
    assert({:ok, [{"course", 5, :ungraded}]} = Parser.parse(input_ungraded))
  end

  test "parses single line with pending grade" do
    input_p       = "course,5,p"
    input_pending = "course,5,pending"

    assert({:ok, [{"course", 5, :pending}]} = Parser.parse(input_p))
    assert({:ok, [{"course", 5, :pending}]} = Parser.parse(input_pending))
  end

  test "parses multiple lines" do
    input = "course1,5,u\ncourse2,5,u"

    assert({:ok, [{"course1", 5, :ungraded},
                  {"course2", 5, :ungraded}]} = Parser.parse(input))
  end

  test "fails if lines are invalid" do
    input = "course1,fail,u"

    assert({:error, error_message} = Parser.parse(input))
    assert(error_message =~ ~r/invalid lines/)
  end
end