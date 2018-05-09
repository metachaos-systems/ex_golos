defmodule Golos.Supervisor do
  require Logger
  use Supervisor
  alias Golos.StageSupervisor
  @default_ws_url "wss://ws.golos.io/"
  @default_api :jsonrpc_ws_api

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Logger.info("#{__MODULE__} is being initialized...")
    api = Application.get_env(:ex_golos, :api) || @default_api
    url = Application.get_env(:ex_golos, :api_url) || @default_ws_url
    activate_stage_sup? = Application.get_env(:ex_golos, :activate_stage_sup)
    stages = if activate_stage_sup?, do: [supervisor(StageSupervisor, [])], else: []

    processes =
      case api do
        :jsonrpc_http_api ->
          []

        :jsonrpc_ws_api ->
          if is_nil(url), do: throw("ExGolos: websockets JSONRPC api URL is NOT configured!")
          Logger.info("ExGolos webscokets JSONRPC api URL is set to #{url}")

          [
            worker(Golos.IdStore, []),
            worker(Golos.WS, [url])
          ]
      end

    children = processes ++ stages

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 10, max_seconds: 5)
  end
end
