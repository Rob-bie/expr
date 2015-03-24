defmodule ExCalc.Mixfile do
  use Mix.Project

  def project do
    [app: :expr,
     version: "0.1.0",
     elixir: "~> 1.0",
     description: description,
     package: package]
  end

  defp description do
    """
    An Elixir library for parsing and evaluating mathematical 
    expressions
    """
  end

  defp package do
    [licenses: ["MIT"],
     contributors: ["Robbie D."],
     links: %{"GitHub" => "https://github.com/Rob-bie/Expr"}]
  end

  def application do
    [applications: [:logger]]
  end

end
