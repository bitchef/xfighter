defmodule Xfighter.Mixfile do
  use Mix.Project

  def project do
    [app: :xfighter,
     version: "0.0.1",
     name: "xfighter",
     source_url: "https://github.com/bitchef/xfighter",
     elixir: "~> 1.1",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [ {:poison, "~>1.5"},
      {:httpoison, "~>0.8.0"},
      {:earmark, "~>0.1", only: :dev},
      {:ex_doc, "~>0.11", only: :dev}]
  end

  defp description do
    """
    An API wrapper for the programming game Stockfighter.
    """
  end

  defp package do
    [
      maintainers: ["bitchef"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/bitchef/xfighter",
                "Docs" => "http://hexdocs.pm/xfighter"}
    ]
  end
end
