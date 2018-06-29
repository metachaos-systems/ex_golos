use Mix.Config

config :ex_golos,
  api: :jsonrpc_ws_api,
  api_url: "wss://ws.golos.io",
  activate_stage_sup: true
