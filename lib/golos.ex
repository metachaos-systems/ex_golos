defmodule Golos do
  use Application
  alias Golos.IdStore

  defdelegate get_current_median_history_price(), to: Golos.DatabaseApi
  defdelegate get_feed_history(), to: Golos.DatabaseApi
  defdelegate get_chain_properties(), to: Golos.DatabaseApi
  defdelegate get_dynamic_global_properties(), to: Golos.DatabaseApi
  defdelegate get_block_header(height), to: Golos.DatabaseApi
  defdelegate get_accounts(accounts), to: Golos.DatabaseApi
  defdelegate get_content(author, permlink), to: Golos.DatabaseApi
  defdelegate get_witness_schedule(), to: Golos.DatabaseApi
  defdelegate get_config(), to: Golos.DatabaseApi
  defdelegate get_next_scheduled_hardfork(), to: Golos.DatabaseApi
  defdelegate get_hardfork_version(), to: Golos.DatabaseApi
  defdelegate get_account_count(), to: Golos.DatabaseApi
  defdelegate get_block(height), to: Golos.DatabaseApi
  defdelegate lookup_accounts(lower_bound_name, limit), to: Golos.DatabaseApi
  defdelegate lookup_account_names(account_names), to: Golos.DatabaseApi
  defdelegate get_account_history(name, from, limit), to: Golos.DatabaseApi
  defdelegate get_trending_tags(after_tag, limit), to: Golos.DatabaseApi
  defdelegate get_discussions_by(metric, query), to: Golos.DatabaseApi
  defdelegate get_categories(metric, after_category, query), to: Golos.DatabaseApi
  defdelegate get_state(path), to: Golos.DatabaseApi
  defdelegate get_content_replies(author,permlink), to: Golos.DatabaseApi
  defdelegate get_discussions_by_author_before_date(author, start_permlink, before_date, limit), to: Golos.DatabaseApi
  defdelegate get_replies_by_last_update(author, start_permlink, before_date, limit), to: Golos.DatabaseApi

  defdelegate get_owner_history(name), to: Golos.DatabaseApi
  defdelegate get_conversion_requests(), to: Golos.DatabaseApi
  defdelegate get_order_book(limit), to: Golos.DatabaseApi
  defdelegate get_open_orders(name), to: Golos.DatabaseApi
  defdelegate get_witnesses(names), to: Golos.DatabaseApi
  defdelegate get_witnesses_by_vote(from, limit), to: Golos.DatabaseApi
  defdelegate lookup_witness_accounts(lower_bound_name, limit), to: Golos.DatabaseApi
  defdelegate get_witness_count(), to: Golos.DatabaseApi
  defdelegate get_active_witnesses(), to: Golos.DatabaseApi
  defdelegate get_miner_queue(), to: Golos.DatabaseApi

  @db_api "database_api"

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    url = Application.get_env(:ex_golos, :url)

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
