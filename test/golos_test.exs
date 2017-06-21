defmodule GolosTest do
  use ExUnit.Case, async: true
  doctest Golos
  @db_api "database_api"

  setup_all do

    # url = Application.get_env(:ex_golos, :url)
    # IO.inspect "Test GOLOS url is #{url}"
    Golos.IdStore.start_link
    Golos.WS.start_link("wss://ws.golos.io")

    :ok
  end

  test "get_dynamic_global_properties call succeeds" do
    params = [@db_api, "get_dynamic_global_properties", []]
    {:ok, result} = Golos.call(params)

    assert %{head_block_id: _} = result
  end

  test "get_content" do
    {:ok, data} = Golos.get_content("litvintech", "obyavlenie-kraudseil-i-sherdrop-distribyuciya")
    assert %{author: "litvintech", permlink: _} = data
  end

  test "get_content_replies" do
    {:ok, data} = Golos.get_content_replies("litvintech", "obyavlenie-kraudseil-i-sherdrop-distribyuciya")
    assert [%{:"author" => _, :"permlink" => _} | _ ] = data
  end

  test "get_discussions_by_author_before_update" do
    {:ok, data} = Golos.get_discussions_by_author_before_date("ontofractal",
     "zapusk-razumgolosa-com-v0-1-beta-statistika-i-instrumenty-dlya-kollektivnogo-razuma-golosa", "2017-02-01T12:00:00", 10)
    assert [%{:"author" => _, :"permlink" => _} | _ ] = data
  end

  @tag :skip
  test "get_replies_by_last_update" do
    {:ok, data} = Golos.get_replies_by_last_update("ontofractal",
     "zapusk-razumgolosa-com-v0-1-beta-statistika-i-instrumenty-dlya-kollektivnogo-razuma-golosa", "2016-12-13T12:00:00", 10)
    assert [%{:"author" => _, :"permlink" => _} | _ ] = data
  end

  test "get_block" do
    {:ok, data} = Golos.get_block(314_159)
    assert %{previous: _, transactions: _} = data
  end

  test "get_accounts with multiple args" do
    {:ok, data} = Golos.get_accounts(["hipster", "creat0r"])
    assert %{:"name" => _, :"id" => _} = hd(data)
  end

  test "get_block_header" do
    {:ok, data} = Golos.get_block_header(1)
    assert %{:"timestamp" => "2016-10-18T11:01:48"} = data
  end

  test "get_dynamic_global_properties" do
    {:ok, data} = Golos.get_dynamic_global_properties()
    assert %{:"average_block_size" => _,:"confidential_sbd_supply" => _} = data
  end

  test "get_chain_properties" do
    {:ok, data} = Golos.get_chain_properties()
    assert %{:"account_creation_fee" => _, :"maximum_block_size" => _} = data
  end

  test "get_feed_history" do
    {:ok, data} = Golos.get_feed_history()
    assert %{:"current_median_history" => %{:"base" => _}} = data
  end

  test "get_current_median_history_price" do
    {:ok, data} = Golos.get_current_median_history_price()
    assert %{:"base" => _, :"quote" => _} = data
  end

  #ACCOUNTS
  test "get_account_count" do
    {:ok, data} = Golos.get_account_count()
    assert 3141 < data
  end

  test "lookup_accounts" do
    {:ok, data} =  Golos.lookup_accounts("razumgolosa", 10)
    assert is_list(data)
    assert is_bitstring(hd data)
  end

  test "lookup_account_names" do
    {:ok, data} =  Golos.lookup_account_names(["ontofractal"])
    assert %{:"name" =>  "ontofractal"} = hd(data)
  end

  test "get_account_history" do
    {:ok, data} = Golos.get_account_history("ontofractal", -1, 10)
    assert [_, %{:"block" => _}] = hd(data)
  end

  test "get_config" do
    {:ok, data} = Golos.get_config()
    assert %{:"VESTS_SYMBOL" => _} = data
  end

  test "get_witness_schedule" do
    {:ok, data} = Golos.get_witness_schedule()
    assert %{:"current_shuffled_witnesses" => _} = data
  end

  test "get_hardfork_version" do
    {:ok, data} = Golos.get_hardfork_version()
    assert "0" <> _  = data
  end

  test "get_next_scheduled_hardfork" do
    {:ok, data} = Golos.get_next_scheduled_hardfork()
    assert %{:"hf_version" => _, :"live_time" => _}  = data
  end

  test "get_trending_tags" do
    {:ok, data} = Golos.get_trending_tags("golos", 10)
    assert [%{:"comments" => _, :"name" => _} | _]  = data
  end

  test "get_discussions_by_created" do
    {:ok, data} = Golos.get_discussions_by(:created, %{tag: "golos", limit: 20})
    assert [%{:"title" => _, :"id" => _, :"created" => _} | _]  = data
  end

  test "get_discussions_by trending metric" do
    {:ok, data} = Golos.get_discussions_by(:trending, %{tag: "golos", limit: 20})
    assert [%{:"title" => _, :"id" => _, :"created" => _} | _]  = data
  end

  test "get_state" do
    {:ok, data} = Golos.get_state("/trending")
    assert %{:"props" => _, :"witness_schedule" => _}  = data
  end

  test "get_trending_categories" do
    {:ok, data} = Golos.get_categories(:trending, "golos", 10)
    assert [%{:"abs_rshares" => _, :"discussions" => _, :"id" => _, :"last_update" => _, :"name" => _, :"total_payouts" => _} | _ ]  = data
  end

  test "get_conversion_requests" do
    {:ok, data} = Golos.get_conversion_requests()
    passes = case data do
      [] -> true
      [%{:"amount" => _, :"conversion_date" => _}] -> true
      _ -> false
    end
    assert passes
  end

  @tag :skip
  test "get_owner_history" do
    {:ok, data} = Golos.get_owner_history("ontofractal")
    assert [] != data
  end

  test "get_order_book" do
    {:ok, data} = Golos.get_order_book(100)
    assert %{:"asks" => _, :"bids" => _} = data
  end

  test "get_open_orders" do
    {:ok, data} = Golos.get_open_orders("ontofractal")
    passes = case data do
      [] -> true
      [%{:"created" => _, :"expiration" => _, :"for_sale" => _, :"id" => _,
       :"orderid" => _, :"real_price" => _, :"rewarded" => _, :"sell_price" => _, :"seller" => _} | _ ] -> true
      _ -> false
    end
    assert passes
  end

  test "get_witnesses" do
    {:ok, data} = Golos.get_witnesses(["2.3.101","2.3.149"])
    assert [%{:"owner" => _, :"signing_key" => _, :"pow_worker" => _} | _] = data
  end

  test "get_witnesses_by_vote" do
    {:ok, data} = Golos.get_witnesses_by_vote("hipster", 2)
    assert [%{:"owner" => _, :"signing_key" => _, :"pow_worker" => _} | _] = data
  end

  test "lookup_witness_accounts" do
    {:ok, data} =  Golos.lookup_witness_accounts("creator", 10)
    assert is_list(data)
    assert is_bitstring(hd data)
  end

  test "get_witness_count" do
    {:ok, data} =  Golos.get_witness_count()
    assert is_integer(data)
  end

  test "get_active_witnesses" do
    {:ok, data} =  Golos.get_active_witnesses()
    assert is_list(data)
    assert is_bitstring(hd data)
  end

  test "get_miner_queue" do
    {:ok, data} =  Golos.get_miner_queue()
    assert is_list(data)
    assert is_bitstring(hd data)
  end

  test "get_account_votes" do
    {:ok, data} =  Golos.get_account_votes("academy")
    assert [%{:"authorperm" => _, :"rshares" => _}| _ ] = data
  end

  test "get_active_votes" do
    {:ok, data} =  Golos.get_active_votes("academy", "zapusk-akademii-golosa")
    assert [%{:"percent" => _, :"rshares" => _, :"weight" => _}| _ ] = data
  end

  test "get_followers" do
    {:ok, data} =  Golos.get_followers("academy", "", "blog", 10)
    assert [%{:"follower" => _, :"following" => _}| _ ] = data
  end

  test "get_following" do
    {:ok, data} =  Golos.get_following("ontofractal", "", "blog", 10)
    assert [%{:"follower" => _, :"following" => _}| _ ] = data
  end
end
