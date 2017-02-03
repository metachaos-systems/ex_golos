defmodule GolosTest do
  use ExUnit.Case, async: true
  doctest Golos
  @db_api "database_api"

  setup_all context do

    url = Application.get_env(:ex_golos, :url)

    Golos.IdStore.start_link
    Golos.WS.start_link(url)

    %{
      params:
      %{
        glob_dyn_prop: [@db_api, "get_dynamic_global_properties", []],
        get_block: [@db_api, "get_block", [3_141_592]]
      }
    }
  end

  test "get_dynamic_global_properties call succeeds", context do
    params = context.params.glob_dyn_prop
    {:ok, result} = Golos.call(params)

    assert %{"head_block_id" => _} = result
  end

  test "get_content" do
    {:ok, data} = Golos.get_content("litvintech", "obyavlenie-kraudseil-i-sherdrop-distribyuciya")

    assert %{"author" => "litvintech", "permlink" => _} = data
  end

  test "get_block" do
    {:ok, data} = Golos.get_block(314_159)
    assert %{"previous" => _, "transactions" => _} = data
  end

  test "get_accounts with multiple args" do
    {:ok, data} = Golos.get_accounts(["hipster", "creat0r"])
    assert %{"name" => _, "id" => _} = hd(data)
  end

  test "get_block_header" do
    {:ok, data} = Golos.get_block_header(1)
    IO.inspect  data
    assert %{"timestamp" => "2016-10-18T11:01:48"} = data
  end

  test "get_dynamic_global_properties" do
    {:ok, data} = Golos.get_dynamic_global_properties()
    assert %{"average_block_size" => _,"confidential_sbd_supply" => _} = data
  end

  test "get_chain_properties" do
    {:ok, data} = Golos.get_chain_properties()
    assert %{"account_creation_fee" => _, "maximum_block_size" => _} = data
  end

  test "get_feed_history" do
    {:ok, data} = Golos.get_feed_history()
    assert %{"current_median_history" => %{"base" => _}} = data
  end

  test "get_current_median_history_price" do
    {:ok, data} = Golos.get_feed_history()
    assert %{"current_median_history" => %{"base" => _}} = data
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
    assert %{"name" =>  "ontofractal"} = hd(data)
  end

end
