defmodule Golos.Supervisor do
  require Logger
  alias Golos.Stage
  @default_ws_url "wss://ws.golos.io/"

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    import Supervisor.Spec
    Logger.info("#{__MODULE__} is being initialized...")
    url = Application.get_env(:ex_golos, :url) || @default_ws_url
    Logger.info("Golos WS url is set to #{url}")
    activate_stage_sup? = Application.get_env(:ex_golos, :activate_stage_sup)
    stages = if activate_stage_sup?, do: [supervisor(Stage.Supervisor, [])], else: []

    children = [
      worker(Golos.IdStore, []),
      worker(Golos.WSNext, [url]),
    ]

    children = children ++ stages

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 10, max_seconds: 5)
  end

end