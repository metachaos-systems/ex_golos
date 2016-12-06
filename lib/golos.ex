defmodule Golos do
  use Application
  alias Golos.IdStore
  defdelegate [
    get_content(author, permlink),
    get_block(height),
    get_accounts(accounts),
    get_block_header(height),
    get_dynamic_global_properties,
    get_chain_properties,
    get_feed_history,
    get_current_median_history_price
  ], to: Golos.DatabaseApi

  @db_api "database_api"

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    url = Application.get_env(:golos, :url)

    unless url, do: throw("Golos WS url is NOT configured. ")

    children = [
      worker(IdStore, []),
      worker(Golos.WS, [url])
    ]
    opts = [strategy: :one_for_one, name: Golos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def call(params, opts \\ [])

  def call(params, []) do
    id = gen_id()
    IdStore.put(id, {self(), params})

    send_jsonrpc_call(id, params)

    response = receive do
      {:ws_response, {_, _, response}} -> response
    end

    case response["error"] do
      nil -> {:ok, response["result"]}
      _ -> {:error, response["error"]}
    end
  end



  @doc """
  Sends an event to the WebSocket server
  """
  defp send_jsonrpc_call(id, params) do
    send Golos.WS, {:send, %{jsonrpc: "2.0", id: id, params: params, method: "call"}}
  end

  defp gen_id do
    round(:rand.uniform * 1.0e16)
  end

end
