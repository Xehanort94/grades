# Grades

*Grades* is a command-line application used to evaluate and summarize course information, supplied as a CSV grade file.

The application is completely written in Elixir and can be run using any of the [escript releases](https://github.com/Xehanort94/grades/releases) provided on the *Grades* release page on its [GitHub](https://github.com/Xehanort94/grades) page.

# Table of Contents

  * [Grade File](#grade-file)
  * [Evaluated Information](#evaluated-information)
  * [Installation](#installation)
  * [Usage](#usage)

# Grade File

A grade file is a CSV file where each line contains information about a single course you have attended. You can format the file using any amount of whitespace characters, but make sure to not use commas inside the course name, as this would break the formatting.

A single line has to include the information about a single course in the form of

```
course_name, credit_points, grade
```

where grade can be a floating point number or `u` / `ungraded` for ungraded courses, or `p` / `pending` for pending exam results.

### Example Grade File

```
Programming I,   5,   ungraded
Algorithms I,    4,   2.0
Analysis,        5,   pending
```

# Evaluated Information

*Grades* evaluates your grade files contents and produces a short summary containing:

  * Current credit points
  * Credit points with pending exams included
  * Weighted mean grade
  * List of pending courses

The weighting algorithms weights based on the credit points the course gives you. Ungraded and pending courses are ignored in this calculation.

### Example Weighting

The grade file

```
Algorithms I,    4,   2.0
Databases II,    5,   3.3
```

will be evaluated to the weighted mean grade

```
(4 * 2.0 + 5 * 3.3) / (4 + 5) = 2.72
```

# Installation

  * [Download a Release](https://github.com/Xehanort94/grades/releases) from the *Grades* release page

  * Make sure you have got Erlang installed on your system and are able to execute the `escript` script/executable

# Usage

To use *Grades*, simply start up the `escript` and pass it the path to your grade file as a single argument.

On Windows run:

`escript.exe grades "C:/path/to/grade/file"`

On Linux run:

`escript grades /path/to/grade/file`
