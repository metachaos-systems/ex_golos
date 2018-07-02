defmodule Golos.DatabaseApi do
  @moduledoc """
  Contains all functions to call Golos database_api methods
  """

  def call(method, params) do
    Golos.call(["database_api", method, params])
  end

  @doc """
  Returns block data, accepts block height.

  Example response:
  ```
    %{"extensions" => [], "previous" => "0004cb2eff2f45b042e85563f76f24123b6dfdd2",
    "timestamp" => "2016-10-29T09:23:33",
    "transaction_merkle_root" => "8477010d8f8ade6f69744c6c28203f1b4a1690a2",
    "transactions" => [%{"expiration" => "2016-10-29T09:23:42",
       "extensions" => [],
       "operations" => [["comment",
         %{"author" => "kriptograf",
           "body" => "@@ -187,16 +187,17 @@ %D1%81%D1%82%D0%BE%D1%80%D0%B0%D0%BC%D0%B8 +%0A ( %D1%81%D1%83%D0%BC%D0%BC%D1%8B ",
           "json_metadata" => "{"tags":["ru--kriptovalyuty"]}",
           "parent_author" => "sept",
           "parent_permlink" => "kak-kupit-bitkoin-s-minimalnoi-komissiei",
           "permlink" => "re-sept-kak-kupit-bitkoin-s-minimalnoi-komissiei-20161029t091207449z",
           "title" => ""}]], "ref_block_num" => 51994,
       "ref_block_prefix" => 2572860361,
       "signatures" => ["207fe62d3e6582819a24f5c2258a9d74f69ebab6c9a42b4d321fe08e559b4cd13b6486a429cb60176d40a5d46ee8b8e30b5c6c24d8facc2a7a779ade3f9139a470"]}],
    "witness" => "misha",
    "witness_signature" => "2047ea30c48247a67ff553986f221092d32985eea3e341d684f2d4c0aa09a0ec402582b06619fc5dc40192e2c311eeea3c}
  ```
  """
  @spec get_block(integer) :: {:ok, map} | {:error, any}
  def get_block(height) do
    with {:ok, block} <- call("get_block", [height]) do
      block =
        Map.put(block, :height, height)
        |> Golos.Block.parse_raw_data()
        |> Golos.Block.new()

      {:ok, block}
    else
      err -> err
    end
  end

  # CONTENT

  @doc """
  Returns content data, accepts author and permlink.

  Example response:
  ```
    %{"max_accepted_payout" => "1000000.000 GBG",
    "title" => "[объявление] Краудсейл и Шэрдроп. Дистрибьюция",
    "category" => "ru--kraudseijl", "promoted" => "0.000 GBG",
    "last_update" => "2016-12-06T15:36:54", "created" => "2016-12-05T16:43:03",
    "parent_permlink" => "ru--kraudseijl", "total_vote_weight" => 0,
    "json_metadata" => "{"tags":["ru--kraudseijl","ru--shyerdrop","ru--golos"],"users":["golos","crowdsale","cyberdrop","misha","ether","bender","hipster","litvintech","vitaly-lvov"],"image":["https://dl.dropboxusercontent.com/u/52209381/golos/golos.png","https://dl.dropboxusercontent.com/u/52209381/golos/Screenshot%202016-12-05%2018.30.00.png","https://dl.dropboxusercontent.com/u/52209381/golos/ico_final-min.jpg","https://dl.dropboxusercontent.com/u/52209381/golos/Screenshot%202016-12-06%2002.25.05.png","https://dl.dropboxusercontent.com/u/52209381/golos/card.png"],"links":["https://docs.google.com/spreadsheets/d/1JwCAeRwsu4NzCG20UDM_CnEEsskl0wtvQ7VYjqi233A/edit?usp=sharing","https://golos.io/@litvintech"]}",
    "last_payout" => "2017-01-15T11:00:06",
    "total_payout_value" => "2412.784 GBG", "allow_replies" => true,
    "children_rshares2" => "0", "id" => "2.8.30160",
    "pending_payout_value" => "0.000 GBG", "children" => 15, "replies" => [],
    "body" => "...",
    "active" => "2016-12-06T22:23:06", "net_rshares" => 0,
    "author_rewards" => 10011558, "total_pending_payout_value" => "0.000 GBG",
    "root_comment" => "2.8.30160", "max_cashout_time" => "1969-12-31T23:59:59",
    "root_title" => "[объявление] Краудсейл и Шэрдроп. Дистрибьюция",
    "allow_votes" => true, "percent_steem_dollars" => 10000,
    "children_abs_rshares" => 0, "net_votes" => 90, "author" => "litvintech",
    "curator_payout_value" => "112.100 GBG",
    "permlink" => "obyavlenie-kraudseil-i-sherdrop-distribyuciya",
    "url" => "/ru--kraudseijl/@litvintech/obyavlenie-kraudseil-i-sherdrop-distribyuciya",
    "cashout_time" => "2017-02-14T11:00:06", "parent_author" => "",
    "allow_curation_rewards" => true, "vote_rshares" => 0,
    "reward_weight" => 10000,
    "active_votes" => [%{"percent" => 1000, "reputation" => "15928643268388",
       "rshares" => "1974529666496", "time" => "2016-12-05T17:02:39",
       "voter" => "val", "weight" => "99631990926249375"}, %{...}, ...], "depth" => 0,
    "mode" => "second_payout", "abs_rshares" => 0,
    "author_reputation" => "22784203010137"}
  ```
  """
  @spec get_content(String.t(), String.t()) :: {:ok, map} | {:error, any}
  def get_content(author, permlink) do
    with {:ok, comment} <- call("get_content", [author, permlink]) do
      cleaned =
        comment
        |> Golos.Cleaner.strip_token_names_and_convert_to_number()
        |> Golos.Cleaner.parse_json_strings(:json_metadata)
        |> Golos.Cleaner.extract_fields()
        |> Golos.Cleaner.prepare_tags()
        |> Golos.Cleaner.parse_timedate_strings()
        |> Golos.Cleaner.parse_empty_strings()

      {:ok, cleaned}
    else
      err -> err
    end
  end

  @doc """
  Returns a list of replies to the given content, accepts author and permlink.

  Example response:
  ```
  [%{"max_accepted_payout" => "1000000.000 GBG", "title" => "",
  "category" => "ru--kraudseijl", "promoted" => "0.000 GBG",
  "last_update" => "2016-12-05T16:50:09",
  "created" => "2016-12-05T16:50:09",
  "parent_permlink" => "obyavlenie-kraudseil-i-sherdrop-distribyuciya",
  "total_vote_weight" => 0,
  "json_metadata" => "{\"tags\":[\"ru--kraudseijl\"]}",
  "last_payout" => "2017-01-15T11:00:06",
  "total_payout_value" => "12.892 GBG", "allow_replies" => true,
  "children_rshares2" => "0", "id" => "2.8.30165",
  "pending_payout_value" => "0.000 GBG", "children" => 1,
  "replies" => [],
  "body" => "И он сказал поехали...",
  "active" => "2016-12-06T01:57:24", "net_rshares" => 0,
  "author_rewards" => 53499,
  "total_pending_payout_value" => "0.000 GBG",
  "root_comment" => "2.8.30160",
  "max_cashout_time" => "1969-12-31T23:59:59",
  "root_title" => "[объявление] Краудсейл и Шэрдроп. Дистрибьюция",
  "allow_votes" => true, "percent_steem_dollars" => 10000,
  "children_abs_rshares" => 0, "net_votes" => 6,
  "author" => "dmilash", "curator_payout_value" => "4.296 GBG",
  "permlink" => "re-litvintech-obyavlenie-kraudseil-i-sherdrop-distribyuciya-20161205t165002890z",
  "url" => "/ru--kraudseijl/@litvintech/obyavlenie-kraudseil-i-sherdrop-distribyuciya#@dmilash/re-litvintech-obyavlenie-kraudseil-i-sherdrop-distribyuciya-20161205t165002890z",
  "cashout_time" => "1969-12-31T23:59:59",
  "parent_author" => "litvintech",
  "allow_curation_rewards" => true, "vote_rshares" => 0,
  "reward_weight" => 10000, "active_votes" => [], "depth" => 1,
  "mode" => "second_payout", "abs_rshares" => 0,
  "author_reputation" => "37110534901202"},
  %{...},
  ...]
  ```
  """
  @spec get_content_replies(String.t(), String.t()) :: {:ok, map} | {:error, any}
  def get_content_replies(author, permlink) do
    call("get_content_replies", [author, permlink])
  end

  # UNKNOWN parse error
  # @doc"""
  # If start_permlink is empty then only before_date will be considered. If both are specified the earlier of the two metrics will be used.
  # before_date format is: `2017-02-07T14:34:11`
  # Example response:
  # ```
  # ContentResult has the same shape as a result returned by get_content.
  # Example result:
  # ```
  # [ContentResult, ContentResult, ...]
  # ```
  # """
  # @spec get_replies_by_last_update(String.t, String.t, String.t, integer) :: {:ok, map} | {:error, any}
  # def get_replies_by_last_update(author, start_permlink, before_date, limit) do
  #   call("get_replies_by_last_update", [author, start_permlink, before_date, limit])
  # end

  # ACCOUNTS

  @doc """
  Returns account data. Accepts a list of up to 1000 account names

  Example response:
  ```
  [%{"recovery_account" => "cyberfounder", "posting_rewards" => 6041772,
  "created" => "1970-01-01T00:00:00",
  "last_bandwidth_update" => "2017-02-03T07:44:33",
  "to_withdraw" => "5358033161499672",
  "last_active_proved" => "1970-01-01T00:00:00", "withdraw_routes" => 0,
  "last_account_update" => "2016-11-04T21:28:45",
  "sbd_last_interest_payment" => "2017-01-15T11:19:27",
  "json_metadata" => "{"created_at":"GENESIS","ico_address":"1FNnNWE3m4rsMWTaX76A4bN1uK4biERdVn","user_image":"https://habrastorage.org/files/6b3/db5/587/6b3db55871e04985821e4c453a30c60c.jpg"}",
  "active_challenged" => false, "vesting_balance" => "0.000 GOLOS",
  "last_vote_time" => "2017-02-03T07:44:33", "post_history" => [],
  "blog_category" => %{}, "market_history" => [], "id" => "2.2.1993",
  "vesting_shares" => "5405134010.995395 GESTS", "vote_history" => [],
  "reset_account" => "null", "sbd_balance" => "12877.442 GBG",
  "last_post" => "2017-02-03T07:42:09", "lifetime_vote_count" => 0,
  "savings_sbd_last_interest_payment" => "1970-01-01T00:00:00",
  "mined" => true, "owner_challenged" => false,
  "vesting_withdraw_rate" => "51519549.629804 GESTS",
  "active" => %{"account_auths" => [],
    "key_auths" => [["GLS5vdTX6auUFyUwWEyzXAXhqo6LkCeCKAG2Tr9QaohRurcBouzHR",
      1]], "weight_threshold" => 1}, "proxy" => "",
  "posting" => %{"account_auths" => [],
    "key_auths" => [["GLS574PtkDcrf5PE8QA8Uq1a4YLqer6vRT8WTgsxdYnx5LJDG7RCD",
      1]], "weight_threshold" => 1}, "last_root_post" => "2017-02-02T13:37:45",
  "savings_balance" => "0.000 GOLOS", "average_bandwidth" => 313586832,
  "last_account_recovery" => "1970-01-01T00:00:00",
  "next_vesting_withdrawal" => "2017-02-05T15:01:33", "can_vote" => true,
  "owner" => %{"account_auths" => [],
    "key_auths" => [["GLS6PturNHrX82R3b6ymKRksNWT9K3hPL377qGmgbwBn2W5zyZVtH",
      1]], "weight_threshold" => 1},
  "witness_votes" => ["aizensou", "aleksandraz", "arcange", "creator",
   "dark.sun", "dervish0", "dr2073", "good-karma", "jesta", "kuna", "lehard",
   ...], "reputation" => "24178458603348", "post_count" => 615,
  "last_owner_proved" => "1970-01-01T00:00:00",
  "sbd_seconds_last_update" => "2017-02-03T06:17:15",
  "memo_key" => "GLS8dEWEGYtZj8hvcm7NVZjQKy637F2UMUK9RMMJKW4TowPX7FWFS",
  "name" => "hipster", "withdrawn" => "103039099259608",
  "savings_withdraw_requests" => 0,
  "reset_request_time" => "1969-12-31T23:59:59", "savings_sbd_seconds" => "0",
  "last_owner_update" => "2016-10-18T11:19:12", ...},
  %{...}]
  ```
  """
  @spec get_accounts([String.t()]) :: {:ok, [map]} | {:error, any}
  def get_accounts(accounts) when is_list(accounts) do
    call("get_accounts", [accounts])
  end

  @doc """
  Returns block header data. Accepts block height.

  Example response:
  ```
   %{"extensions" => [], "previous" => "0000000000000000000000000000000000000000",
   "timestamp" => "2016-10-18T11:01:48",
   "transaction_merkle_root" => "0000000000000000000000000000000000000000",
   "witness" => "cyberfounder"}
  ```
  """
  @spec get_block_header(pos_integer) :: {:ok, map} | {:error, any}
  def get_block_header(height) do
    call("get_block_header", [height])
  end

  @doc """
  Unsurprisingly returns a map with dynamic global propeties.
  Example response:

  ```
    %{"average_block_size" => 416, "confidential_sbd_supply" => "0.000 GBG",
    "confidential_supply" => "0.000 GOLOS", "current_aslot" => 3112003,
    "current_reserve_ratio" => 20000, "current_sbd_supply" => "504154.519 GBG",
    "current_supply" => "96227889.854 GOLOS", "current_witness" => "on0tole",
    "head_block_id" => "002f68ff4d75004b06539669e77ce6f5967c2afa",
    "head_block_number" => 3107071, "id" => "2.0.0",
    "last_irreversible_block_num" => 3107056,
    "max_virtual_bandwidth" => "5986734968066277376",
    "maximum_block_size" => 65536, "num_pow_witnesses" => 97,
    "participation_count" => 128,
    "recent_slots_filled" => "340282366920938463463374607431768211455",
    "sbd_interest_rate" => 1000, "sbd_print_rate" => 10000,
    "time" => "2017-02-03T12:20:09", "total_pow" => 148587,
    "total_reward_fund_steem" => "69239.698 GOLOS",
    "total_reward_shares2" => "1030808747260116624181406420498",
    "total_vesting_fund_steem" => "95566422.906 GOLOS",
    "total_vesting_shares" => "448830750142.483827 GESTS",
    "virtual_supply" => "96509712.230 GOLOS", "vote_regeneration_per_day" => 40}
  ```
  """
  @spec get_dynamic_global_properties() :: {:ok, map} | {:error, any}
  def get_dynamic_global_properties do
    call("get_dynamic_global_properties", [])
  end

  @doc """
  Unsurprisingly returns a map with chain propeties.
  Example result:
  ```
  %{"account_creation_fee" => "1.000 GOLOS", "maximum_block_size" => 131072, "sbd_interest_rate" => 1000}
  ```
  """
  @spec get_chain_properties() :: {:ok, map} | {:error, any}
  def get_chain_properties do
    call("get_chain_properties", [])
  end

  @doc """
  Returns node client config

  Example response:
  ```
    %{"STEEMIT_MINER_ACCOUNT" => "miners",
    "STEEMIT_MIN_CONTENT_REWARD" => "1.500 GOLOS",
    "STEEMIT_BLOCKCHAIN_HARDFORK_VERSION" => "0.14.0",
    "STEEMIT_CURATE_APR_PERCENT" => 1937, "VESTS_SYMBOL" => "91621639407366",
    "STEEMIT_MIN_LIQUIDITY_REWARD" => "1200.000 GOLOS",
    "STEEMIT_1_PERCENT" => 100, "STEEMIT_PRODUCER_APR_PERCENT" => 750,
    "STEEMIT_FEED_INTERVAL_BLOCKS" => 1200, "STEEM_SYMBOL" => "91600047785731",
    "STEEMIT_MAX_MEMO_SIZE" => 2048, "STEEMIT_MAX_RATION_DECAY_RATE" => 1000000,
    "STEEMIT_INIT_SUPPLY" => "43306176000", "STEEMIT_MAX_RUNNER_WITNESSES" => 1,
    "STEEMIT_REVERSE_AUCTION_WINDOW_SECONDS" => 1800, "STEEMIT_MAX_MINERS" => 21,
    "STEEMIT_VOTE_REGENERATION_SECONDS" => 432000,
    "STEEMIT_MAX_SIG_CHECK_DEPTH" => 2, "STEEMIT_MAX_FEED_AGE" => "604800000000",
    "STEEMIT_BLOCKS_PER_HOUR" => 1200,
    "STEEMIT_VESTING_WITHDRAW_INTERVALS" => 104,
    "STEEMIT_CONVERSION_DELAY" => "604800000000",
    "STEEMIT_MAX_MINER_WITNESSES" => 1,
    "STEEMIT_BANDWIDTH_AVERAGE_WINDOW_SECONDS" => 604800,
    "STEEMIT_LIQUIDITY_REWARD_PERIOD_SEC" => 3600,
    "STEEMIT_BLOCKS_PER_DAY" => 28800,
    "STEEMIT_MAX_TIME_UNTIL_EXPIRATION" => 3600,
    "STEEMIT_LIQUIDITY_TIMEOUT_SEC" => "604800000000",
    "STEEMIT_MIN_BLOCK_SIZE_LIMIT" => 65536, "IS_TEST_NET" => false,
    "STEEMIT_DEFAULT_SBD_INTEREST_RATE" => 1000,
    "STEEMIT_MIN_ACCOUNT_CREATION_FEE" => 1, "STEEMIT_NULL_ACCOUNT" => "null",
    "STEEMIT_MAX_ACCOUNT_WITNESS_VOTES" => 30,
    "STEEMIT_MAX_VOTED_WITNESSES" => 19, "STEEMIT_MIN_UNDO_HISTORY" => 10,
    "STEEMIT_ADDRESS_PREFIX" => "GLS",
    "STEEMIT_HARDFORK_REQUIRED_WITNESSES" => 17,
    "STEEMIT_CONTENT_APR_PERCENT" => 5813,
    "STEEMIT_APR_PERCENT_SHIFT_PER_ROUND" => 83,
    "STEEMIT_START_MINER_VOTING_BLOCK" => 200,
    "STEEMIT_SECONDS_PER_YEAR" => 31536000,
    "STEEMIT_MIN_PRODUCER_REWARD" => "1.000 GOLOS",
    "STEEMIT_LIQUIDITY_REWARD_BLOCKS" => 1200,
    "STEEMIT_CASHOUT_WINDOW_SECONDS" => 86400,
    "GRAPHENE_CURRENT_DB_VERSION" => "GPH2.4", "STEEMIT_MINER_PAY_PERCENT" => 100,
    "STEEMIT_MIN_LIQUIDITY_REWARD_PERIOD_SEC" => 60000000,
    "STEEMIT_MINING_REWARD" => "1.000 GOLOS",
    "STEEMIT_FREE_TRANSACTIONS_WITH_NEW_ACCOUNT" => 100, ...}
  ```
  """
  @spec get_config() :: {:ok, map} | {:error, any}
  def get_config() do
    call("get_config", [])
  end

  # ACCOUNTS
  @doc """
  Get account count
  Example response: 25290
  """
  @spec get_account_count() :: {:ok, integer} | {:error, any}
  def get_account_count() do
    call("get_account_count", [])
  end

  @doc """
  Lookup accounts
  Example response:
  ```
    ["razumnica", "razumova-l", "razvanelulmarin", "razved1", "razzewille", "rbaron", "rbc", "rbi", "rbrown", "rbur93"]
  ```
  """
  def lookup_accounts(lower_bound_name, limit) do
    call("lookup_accounts", [lower_bound_name, limit])
  end

  @doc """
  Returns list of maps of account data.

  Example response:
  ```
    [%{"recovery_account" => "cyberfounder", "posting_rewards" => 83462628,
     "created" => "1970-01-01T00:00:00",
     "last_bandwidth_update" => "2017-02-03T11:57:06", "to_withdraw" => 0,
     "last_active_proved" => "1970-01-01T00:00:00", "withdraw_routes" => 0,
     "last_account_update" => "2017-01-21T11:34:30",
     "sbd_last_interest_payment" => "2017-01-15T23:43:00",
     "json_metadata" => "{"created_at":"GENESIS","ico_address":"1B9Khkti2bBPccSoNj6aiFCYhq5Rq5GAMb","user_image":"https://avatars2.githubusercontent.com/u/4211840?v=3&u=97aeb67208068d457fad522a500b62f12908270c&s=400"}",
     "active_challenged" => false, "last_vote_time" => "2017-02-03T11:57:06",
     "id" => "2.2.6836", "vesting_shares" => "386381769.644947 GESTS",
     "reset_account" => "null", "sbd_balance" => "917.535 GBG",
     "last_post" => "2017-02-02T19:11:57", "lifetime_vote_count" => 0,
     "savings_sbd_last_interest_payment" => "1970-01-01T00:00:00",
     "mined" => true, "owner_challenged" => false,
     "vesting_withdraw_rate" => "0.000001 GESTS",
     "active" => %{"account_auths" => [],
       "key_auths" => [["GLS8NV2JNwtcTSCDSJDgr69PFueGTvnvGC2F8HPSyUxFWrnp9ATY6",
         1]], "weight_threshold" => 1}, "proxy" => "",
     "posting" => %{"account_auths" => [],
       "key_auths" => [["GLS6qg3gEEkSz4i1T9WpjSxjFrVc6fNEps1QpvxsDCMATiaL5aRzx",
         1]], "weight_threshold" => 1}, "last_root_post" => "2017-02-01T18:17:09",
     "savings_balance" => "0.000 GOLOS", "average_bandwidth" => 308637164,
     "last_account_recovery" => "1970-01-01T00:00:00",
     "next_vesting_withdrawal" => "1969-12-31T23:59:59", "can_vote" => true,
     "owner" => %{"account_auths" => [],
       "key_auths" => [["GLS6Ms4HrGMCPsq3yoytJc8TEKuQb1Bk9HRxjUSa3wtyhnpA4fJZV",
         1]], "weight_threshold" => 1}, "post_count" => 421,
     "last_owner_proved" => "1970-01-01T00:00:00",
     "sbd_seconds_last_update" => "2017-02-03T08:48:15",
     "memo_key" => "GLS5frWAw3yukawhSEnQ7zK7N1LWM77JzjJvzAZx5JRMgPkoddXTv",
     "name" => "ontofractal", "withdrawn" => 0, "savings_withdraw_requests" => 0,
     "reset_request_time" => "1969-12-31T23:59:59", "savings_sbd_seconds" => "0",
     "last_owner_update" => "1970-01-01T00:00:00",
     "proxied_vsf_votes" => [0, 0, 0, 0], "sbd_seconds" => "4489659344784",
     "savings_sbd_balance" => "0.000 GBG", "post_bandwidth" => 10000,
     "curation_rewards" => 5484048,
     "pending_reset_authority" => %{"account_auths" => [], "key_auths" => [],
       ...}, "witnesses_voted_for" => 10, "comment_count" => 0, ...}]
  ```
  """
  @spec lookup_account_names([String.t()]) :: {:ok, [map]} | {:error, any}
  def lookup_account_names(account_names) do
    call("lookup_account_names", [account_names])
  end

  @doc """
  Gets hardfork version

  Example response: `"0.14.0"`
  """
  @spec get_hardfork_version() :: {:ok, String.t()} | {:error, any}
  def get_hardfork_version() do
    call("get_hardfork_version", [])
  end

  @doc """
  Get next scheduled hardfork time

  Example result: `%{"hf_version" => "0.0.0", "live_time" => "2016-10-18T11:00:00"}`
  """
  @spec get_next_scheduled_hardfork() :: {:ok, map} | {:error, any}
  def get_next_scheduled_hardfork() do
    call("get_next_scheduled_hardfork", [])
  end

  @doc """
  Get trending tags

  Example result:
  ```
  [
    %{"comments" => 386, "id" => "5.4.29", "net_votes" => 16361,
    "tag" => "golos", "top_posts" => 448,
    "total_children_rshares2" => "263770002351940021381162037540",
    "total_payout" => "1210679.260 GBG"},
    %{"comments" => 0, "id" => "5.4.6338", "net_votes" => 59,
    "tag" => "golos-io", "top_posts" => 1,
    "total_children_rshares2" => "7597368466598778563409",
    "total_payout" => "1533.724 GBG"},
    %{"comments" => 1, "id" => "5.4.741", "net_votes" => 39,
    "tag" => "golos-soft", "top_posts" => 2,
    "total_children_rshares2" => "87745768291122276983586401",
    "total_payout" => "12.812 GBG"},
  ...]
  ```
  """
  @spec get_trending_tags(String.t(), integer) :: {:ok, [map]} | {:error, any}
  def get_trending_tags(after_tag, limit) do
    call("get_trending_tags", [after_tag, limit])
  end

  @doc """
  Get discussions by the wanted metric. Accepts a metric atom and a map with a following query params: %{tag: `String.t`, limit: `integer`}
  ContentResult has the same shape as a result returned by get_content.
  Example result:
  ```
  [ContentResult, ContentResult, ...]
  ```
  """
  @spec get_discussions_by(atom, map) :: {:ok, [map]} | {:error, any}
  def get_discussions_by(metric, query) do
    method = "get_discussions_by_" <> Atom.to_string(metric)
    call(method, [query])
  end

  @doc """
  Gets current GBG to GOLOS conversion requests for given account.
  Example result:
  ```
  [%{"amount" => "100.000 GBG", "conversion_date" => "2017-02-17T18:59:42",
     "id" => "2.15.696", "owner" => "ontofractal", "requestid" => 1486753166}]
  ```
  """
  @spec get_conversion_requests() :: {:ok, [map]} | {:error, any}
  def get_conversion_requests() do
    call("get_conversion_requests", ["ontofractal"])
  end

  @doc """
  Returns past owner authorities that are valid for account recovery.
  Doesn't seem to work at this moment.
  ```
  ```
  """
  @spec get_owner_history(String.t()) :: {:ok, [map]} | {:error, any}
  def get_owner_history(name) do
    call("get_owner_history", [name])
  end

  @doc """
  Returns order book.

  ## Example response
  ```
  %{"asks" => [%{"created" => "2017-02-10T18:19:24",
                 "order_price" => %{"base" => "250.000 GOLOS",
                   "quote" => "555.975 GBG"},
                 "real_price" => "2.22389999999999999", "sbd" => 549152,
                 "steem" => 246932},...],
  "bids" => [%{...}, ...]
  ```
  """
  @spec get_order_book(integer) :: {:ok, [map]} | {:error, any}
  def get_order_book(limit) do
    call("get_order_book", [limit])
  end

  @doc """
  Returns open orders for the given account name.

  ## Example response
  ```
  [
  %{ "created" => "2017-02-10T19:49:36",
     "expiration" => "1969-12-31T23:59:59", "for_sale" => 6280,
     "id" => "2.13.1890", "orderid" => 1486756162,
     "real_price" => "2.00000000000000000", "rewarded" => false,
     "sell_price" => %{"base" => "6.280 GBG",
       "quote" => "3.140 GOLOS"}, "seller" => "ontofractal"},
       ...]
  ```
  """
  @spec get_open_orders(String.t()) :: {:ok, [map]} | {:error, any}
  def get_open_orders(name) do
    call("get_open_orders", [name])
  end

  @doc """
  Returns the vesting delegations by an account. Parameters: delegator_account:string; start_account:string; limit:int up to 1000

  ## Example response
  [{id: 0, delegator: "zzz", delegatee: "zxcat", vesting_shares: "90.000000 GESTS", min_delegation_time: "2018-04-25T21:48:15"}].

  """
  @spec get_vesting_delegations(String.t(), String.t(), integer, String.t()) ::
          {:ok, [map]} | {:error, any}
  def get_vesting_delegations(account, from, limit, type) do
    call("get_vesting_delegations", [account, from, limit, type])
  end
end
