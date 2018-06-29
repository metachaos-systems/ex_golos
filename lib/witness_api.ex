defmodule Golos.WitnessApi do
  def call(method, params) do
    Golos.call(["witness_api", method, params])
  end

  @doc """
  Get witnesses by ids

  ## Example response
  ```
  [%{"created" => "2016-10-18T11:21:18",
     "hardfork_time_vote" => "2016-10-18T11:00:00",
     "hardfork_version_vote" => "0.0.0", "id" => "2.3.101",
     "last_aslot" => 3323895, "last_confirmed_block_num" => 3318746,
     "last_sbd_exchange_update" => "2017-02-09T06:10:33",
     "last_work" => "0000000000000000000000000000000000000000000000000000000000000000",
     "owner" => "hipster", "pow_worker" => 0,
     "props" => %{"account_creation_fee" => "1.000 GOLOS",
       "maximum_block_size" => 65536, "sbd_interest_rate" => 1000},
     "running_version" => "0.14.2",
     "sbd_exchange_rate" => %{"base" => "1.742 GBG",
       "quote" => "1.000 GOLOS"},
     "signing_key" => "GLS6oRsauXhqxhpXbK3dJzFBGEWVoX6BjVT5z8BwNzgV38DzFat9E",
     "total_missed" => 10,
     "url" => "https://golos.io/ru--delegaty/@hipster/delegat-hipster",
     "virtual_last_update" => "2363092957490310521961963807",
     "virtual_position" => "186709431624610119071729411416709427966",
     "virtual_scheduled_time" => "2363094451567901047152350987",
     "votes" => "102787791122912956"},
  %{...} ]
  ```
  """
  @spec get_witnesses([String.t()]) :: {:ok, [map]} | {:error, any}
  def get_witnesses(ids) do
    call("get_witnesses", [ids])
  end

  @doc """
  Get witnesses by votes. Example response is the same as get_witnesses.
  """
  @spec get_witnesses_by_vote(integer, integer) :: {:ok, [map]} | {:error, any}
  def get_witnesses_by_vote(from, limit) do
    call("get_witnesses_by_vote", [from, limit])
  end

  @doc """
  Lookup witness accounts

  Example response:
  ```
  ["creator", "creatorgalaxy", "crypto", "cryptocat", "cyberfounder", "cybertech-01", "d00m", "dacom", "dance", "danet"]
  ```
  """
  @spec lookup_witness_accounts(String.t(), integer) :: {:ok, [String.t()]} | {:error, any}
  def lookup_witness_accounts(lower_bound_name, limit) do
    call("lookup_witness_accounts", [lower_bound_name, limit])
  end

  @doc """
  Get witness count

  Example response: `997`
  """
  @spec get_witness_count() :: {:ok, [String.t()]} | {:error, any}
  def get_witness_count() do
    call("get_witness_count", [])
  end

  @doc """
  Get active witnesses

  Example response:
  ```
  ["primus", "litvintech", "yaski", "serejandmyself", "dark.sun", "phenom",
   "hipster", "gtx-1080-sc-0048", "lehard", "aleksandraz", "dr2073", "smailer",
   "on0tole", "roelandp", "arcange", "testz", "vitaly-lvov", "xtar", "anyx",
   "kuna", "creator"]
  ```
  """
  @spec get_active_witnesses() :: {:ok, [String.t()]} | {:error, any}
  def get_active_witnesses() do
    call("get_active_witnesses", [])
  end

  @doc """
  Returns witness schedule

  Example response:
  ```
    %{"current_shuffled_witnesses" => ["litrbooh", "gtx-1080-sc-0015",
    "vitaly-lvov", "aleksandraz", "on0tole", "dark.sun", "jesta", "someguy123",
    "pmartynov", "primus", "litvintech", "phenom", "hipster", "good-karma",
    "arcange", "serejandmyself", "kuna", "dr2073", "lehard", "testz", "xtar"],
    "current_virtual_time" => "2359603129137518468300462851", "id" => "2.7.0",
    "majority_version" => "0.14.2",
    "median_props" => %{"account_creation_fee" => "1.000 GOLOS",
    "maximum_block_size" => 131072, "sbd_interest_rate" => 1000},
    "next_shuffle_block_num" => 3108273}
  ```
  """
  @spec get_witness_schedule() :: {:ok, map} | {:error, any}
  def get_witness_schedule() do
    call("get_witness_schedule", [])
  end

  @doc """
  Returns feed history
  Example response:
  ```
    %{"current_median_history" => %{"base" => "1.000 GBG",
    "quote" => "0.559 GOLOS"}, "id" => "2.14.0",
    "price_history" => [%{"base" => "1.379 GBG", "quote" => "1.000 GOLOS"},
     %{"base" => "1.379 GBG", "quote" => "1.000 GOLOS"},
     %{"base" => "1.379 GBG", "quote" => "1.000 GOLOS"},
     %{"base" => "1.000 GBG", ...}, %{...}, ...]}
  ```
  """
  @spec get_feed_history() :: {:ok, map} | {:error, any}
  def get_feed_history do
    call("get_feed_history", [])
  end

  @doc """
  Returns current median history price.
  Example response:
  ```
    %{"base" => "1.000 GBG", "quote" => "0.559 GOLOS"}
  ```
  """
  @spec get_current_median_history_price() :: {:ok, map} | {:error, any}
  def get_current_median_history_price() do
    call("get_current_median_history_price", [])
  end

  @doc """
  Get miner queue

  Example response:
  ```
  ["gtx-1080-sc-0083", "gtx-1080-sc-0016", "gtx-1080-sc-0084", "gtx-1080-sc-0017",
   "gtx-1080-sc-0085", "gtx-1080-sc-0018", "penguin-11", "gtx-1080-sc-0028",
   "gtx-1080-sc-0023", "gtx-1080-sc-0080", ...]
  ```
  """
  @spec get_miner_queue() :: {:ok, [String.t()]} | {:error, any}
  def get_miner_queue() do
    call("get_miner_queue", [])
  end
end
