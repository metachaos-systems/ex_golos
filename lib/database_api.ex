defmodule Golos.DatabaseApi do

  def call(method, params) do
    Golos.call(["database_api", method, params])
  end

  def get_block(height) do
    call("get_block", [height])
  end

  @doc """
  Get content by author and permlink
  """
  @spec get_content(String.t, String.t) :: map
  def get_content(author, permlink) do
    call("get_content", [author, permlink])
  end

  @doc """
  Get account data. Accepts either a list with up to 1000 account names
  """
  @spec get_accounts([String.t]) :: [map]
  def get_accounts(accounts) when is_list(accounts) do
    call("get_accounts", accounts)
  end

  @doc """
  Get block header data. Accepts block height.
  """
  @spec get_block_header(pos_integer) :: map
  def get_block_header(height) do
    call("get_block_header", [height])
  end

  def get_dynamic_global_properties do
    call("get_dynamic_global_properties", [])
  end

  def get_chain_properties do
    call("get_chain_properties", [])
  end

  def get_feed_history do
    call("get_feed_history", [])
  end

  def get_current_median_history_price do
    call("get_current_median_history_price", [])
  end

  # ACCOUNTS
  def get_account_count() do
   call("get_account_count", [])
  end

  def lookup_accounts(lower_bound_name, limit) do
   call("lookup_accounts", [lower_bound_name,  limit])
  end

  def lookup_account_names(account_names) do
   call("lookup_account_names", [account_names])
  end

end
