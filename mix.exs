defmodule Kalda.MixProject do
  use Mix.Project

  def project do
    [
      app: :kalda,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [warnings_as_errors: !!System.get_env("CI")],
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      default_release: :kalda,
      releases: releases(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  def application do
    [
      mod: {Kalda.Application, []},
      extra_applications: [:logger, :runtime_tools, :rollbax, :ssl]
    ]
  end

  # Configuration for the OTP release.
  def releases do
    [kalda: [include_executables_for: [:unix]]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  defp deps do
    [
      # Email sending
      {:bamboo, "~> 1.7"},
      # Date time library
      {:timex, "~> 3.6"},
      # Web framework
      {:phoenix, "~> 1.5"},
      {:phoenix_live_view, "~> 0.15"},
      {:phoenix_html, "~> 2.11"},
      # CORS API support
      {:corsica, "~> 1.0"},
      # Postgresql database access
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, "~> 0.15"},
      # Metrics
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      # Internationalisation
      {:gettext, "~> 0.11"},
      # JSON (de)serialization
      {:jason, "~> 1.1"},
      # Web server
      {:plug_cowboy, "~> 2.3"},
      # Secure password hashing
      {:bcrypt_elixir, "~> 2.0"},
      # Markdown blog post engine
      {:nimble_publisher, "~> 0.1"},
      # Http client
      {:httpoison, "~> 1.8"},
      # Exception tracking with Rollbar
      {:rollbax, "~> 0.11"},
      # Stripe API client and webhook verifier
      {:stripity_stripe, github: "code-corps/stripity_stripe", ref: "588daa4"},
      # Automatic page reloading
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      # HTML parsing
      {:floki, "~> 0.27", only: :test},
      # Automatic test runner
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      # Mock services in tests
      {:hammox, "~> 0.5", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
