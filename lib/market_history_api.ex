defmodule Golos.MarketHistoryApi do
  def call(method, params) do
    Golos.call(["market_history", method, params])
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
  @spec get_order_book(integer) :: [map]
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
  @spec get_open_orders(String.t()) :: [map]
  def get_open_orders(name) do
    call("get_open_orders", [name])
  end

end
