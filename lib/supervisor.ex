defmodule Golos.Supervisor do
  require Logger
  use Supervisor
  alias Golos.StageSupervisor
  @default_ws_url "wss://ws.golos.io/"

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Logger.info("#{__MODULE__} is being initialized...")
    url = Application.get_env(:ex_golos, :url) || @default_ws_url
    Logger.info("Golos WS url is set to #{url}")
    activate_stage_sup? = Application.get_env(:ex_golos, :activate_stage_sup)
    activate_ws_processes? = Application.get_env(:ex_golos, :activate_ws_processes)
    stages = if activate_stage_sup?, do: [supervisor(StageSupervisor, [])], else: []

    ws_processes =
      if activate_ws_processes? do
        [
          worker(Golos.IdStore, []),
          worker(Golos.WS, [url])
        ]
      else
        []
      end

    children = ws_processes ++ stages

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 10, max_seconds: 5)
  end
end
