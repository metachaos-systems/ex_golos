defmodule Golos do
  use Application
  alias Golos.{IdStore, Stage}

  alias Golos.{
    DatabaseApi,
    TagApi,
    WitnessApi,
    SocialNetworkApi,
    AccountHistoryApi,
    MarketHistoryApi,
    FollowApi,
    OperationHistoryApi
  }

  require Logger
  @default_api :jsonrpc_ws_api
  @app :ex_golos

  defdelegate get_chain_properties(), to: Golos.DatabaseApi
  defdelegate get_dynamic_global_properties(), to: Golos.DatabaseApi
  defdelegate get_block_header(height), to: Golos.DatabaseApi
  defdelegate get_accounts(accounts), to: Golos.DatabaseApi
  defdelegate get_content(author, permlink), to: SocialNetworkApi
  defdelegate get_config(), to: Golos.DatabaseApi
  defdelegate get_next_scheduled_hardfork(), to: Golos.DatabaseApi
  defdelegate get_hardfork_version(), to: Golos.DatabaseApi
  defdelegate get_account_count(), to: Golos.DatabaseApi
  defdelegate get_block(height), to: Golos.DatabaseApi
  defdelegate get_vesting_delegations(account, from, limit, type), to: Golos.DatabaseApi

  defdelegate lookup_accounts(lower_bound_name, limit), to: Golos.DatabaseApi
  defdelegate lookup_account_names(account_names), to: Golos.DatabaseApi
  defdelegate get_account_history(name, from, limit), to: AccountHistoryApi
  defdelegate get_trending_tags(after_tag, limit), to: TagApi
  defdelegate get_discussions_by(metric, query), to: TagApi
  defdelegate get_categories(metric, after_category, query), to: SocialNetworkApi
  defdelegate get_content_replies(author, permlink), to: SocialNetworkApi

  defdelegate get_discussions_by_author_before_date(author, start_permlink, before_date, limit),
    to: TagApi

  defdelegate get_replies_by_last_update(author, start_permlink, before_date, limit),
    to: SocialNetworkApi

  defdelegate get_owner_history(name), to: Golos.DatabaseApi
  defdelegate get_conversion_requests(), to: DatabaseApi
  defdelegate get_order_book(limit), to: MarketHistoryApi
  defdelegate get_open_orders(name), to: MarketHistoryApi

  defdelegate get_witness_schedule(), to: WitnessApi
  defdelegate get_witnesses(names), to: WitnessApi
  defdelegate get_witnesses_by_vote(from, limit), to: WitnessApi
  defdelegate lookup_witness_accounts(lower_bound_name, limit), to: WitnessApi
  defdelegate get_witness_count(), to: WitnessApi
  defdelegate get_active_witnesses(), to: WitnessApi
  defdelegate get_current_median_history_price(), to: WitnessApi
  defdelegate get_feed_history(), to: WitnessApi
  defdelegate get_miner_queue(), to: WitnessApi

  defdelegate get_account_votes(name), to: SocialNetworkApi
  defdelegate get_active_votes(author, permlink), to: SocialNetworkApi
  defdelegate get_followers(account, start_follower, follow_type, limit), to: FollowApi
  defdelegate get_following(account, start_following, follow_type, limit), to: FollowApi

  defdelegate get_transaction(tx_id), to: OperationHistoryApi

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Golos.Supervisor, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, max_restarts: 10, max_seconds: 5)
  end

  @spec call(map, KeyWord.t()) :: {:ok, any} | {:error, any}
  def call(params, opts \\ [])

  def call(params, opts) do
    case Application.get_env(@app, :api) || @default_api do
      :jsonrpc_http_api ->
        call_http(params, opts)

      :jsonrpc_ws_api ->
        call_ws(params, opts)

      api ->
        throw("ExGolos doesn't recognize this API configuration setting: #{api}")
    end
  end

  def call_http(params, _opts \\ []) do
    {:ok, result} = Golos.HttpClient.call(params)
    AtomicMap.convert(result, safe: false, underscore: false)
  end

  def call_ws(params, _opts \\ []) do
    id = gen_id()
    IdStore.put(id, {self(), params})

    send_jsonrpc_call(id, params)

    response =
      receive do
        {:ws_response, {_, _, response}} -> response
      end

    err = response["error"]
    result = response["result"]

    case {err, result} do
      {_, nil} ->
        {:error, err}

      {nil, _} ->
        {:ok, AtomicMap.convert(result, safe: false, underscore: false)}

      _ ->
        {:error, err}
    end
  end

  defp send_jsonrpc_call(id, params) do
    send(Golos.WS.Alt, {:send, %{jsonrpc: "2.0", id: id, params: params, method: "call"}})
  end

  defp gen_id do
    round(:rand.uniform() * 1.0e16) |> Integer.to_string()
  end
end
