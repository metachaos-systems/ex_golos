defmodule Golos.DatabaseApi do

  def call(method, params) do
    Golos.call(["database_api", method, params])
  end

  @doc """
  %{"extensions" => [], "previous" => "0004cb2eff2f45b042e85563f76f24123b6dfdd2",
  "timestamp" => "2016-10-29T09:23:33",
  "transaction_merkle_root" => "8477010d8f8ade6f69744c6c28203f1b4a1690a2",
  "transactions" => [%{"expiration" => "2016-10-29T09:23:42",
     "extensions" => [],
     "operations" => [["comment",
       %{"author" => "kriptograf",
         "body" => "@@ -187,16 +187,17 @@\n %D1%81%D1%82%D0%BE%D1%80%D0%B0%D0%BC%D0%B8 \n+%0A\n ( %D1%81%D1%83%D0%BC%D0%BC%D1%8B \n",
         "json_metadata" => "{\"tags\":[\"ru--kriptovalyuty\"]}",
         "parent_author" => "sept",
         "parent_permlink" => "kak-kupit-bitkoin-s-minimalnoi-komissiei",
         "permlink" => "re-sept-kak-kupit-bitkoin-s-minimalnoi-komissiei-20161029t091207449z",
         "title" => ""}]], "ref_block_num" => 51994,
     "ref_block_prefix" => 2572860361,
     "signatures" => ["207fe62d3e6582819a24f5c2258a9d74f69ebab6c9a42b4d321fe08e559b4cd13b6486a429cb60176d40a5d46ee8b8e30b5c6c24d8facc2a7a779ade3f9139a470"]}],
  "witness" => "misha",
  "witness_signature" => "2047ea30c48247a67ff553986f221092d32985eea3e341d684f2d4c0aa09a0ec402582b06619fc5dc40192e2c311eeea3c}
  """
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

  @doc """
  Unsurprisingly returns a map with dynamic global propeties.
  """
  @spec get_dynamic_global_properties() :: map
  def get_dynamic_global_properties do
    call("get_dynamic_global_properties", [])
  end

  @doc """
  Unsurprisingly returns a map with chain propeties.
  """
  @spec get_chain_properties() :: map
  def get_chain_properties do
    call("get_chain_properties", [])
  end

  @doc """
  Return feed history
  """
  @spec get_feed_history() :: map
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
