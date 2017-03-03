defmodule Grades.Mixfile do
  use Mix.Project

  def project do
    [app: :grades,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript()]
  end

  def escript do
    [main_module: Grades.CLI]
  end

  def application do
    []
  end
end
