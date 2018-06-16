defmodule Golos.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_golos,
      version: "0.10.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:websockex], mod: {Golos, []}]
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
    [
      {:poison, "~> 3.1.0"},
      {:gen_stage, "~> 0.13.0"},
      {:atomic_map, ">= 0.0.0"},
      {:credo, ">= 0.0.0", only: [:test, :dev]},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:exconstructor, "~> 1.1.0"},
      {:websockex, "~> 0.4.0"},
      {:websocket_client, "~> 1.3.0"},
      {:jsonrpc2, "~> 1.0"},
      {:hackney, ">= 0.0.0"}
    ]
  end

  defp description do
    """
    Elixir websockets library and utilities for GOLOS JSONRPC websocket interface
    """
  end

  defp package do
    [
      name: :ex_golos,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["ontofractal"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/cyberpunk-ventures/ex_golos",
        "Cyberpunk Ventures" => "http://cyberpunk.ventures"
      }
    ]
  end
end
