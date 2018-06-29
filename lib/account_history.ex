defmodule Golos.AccountHistoryApi do
  
  def call(method, params) do
    Golos.call(["account_history", method, params])
  end

  @doc """
  Returns account operations history
  Example response:
  ```
    [[7817, %{"block" => 3107388, "id" => "2.17.1197661", "op" => ["vote", %{"author" => "vik", "permlink" => "dostupnyi-javascript-na-prikladnom-primere-sozdaniya-stranicy-saita-s-deistviyami-polzovatelei-golosa-v-realnom-vremeni", "voter" => "ontofractal", "weight" => 10000}], "op_in_trx" => 0, "timestamp" => "2017-02-03T12:36:06", "trx_id" => "dc866b17ba80fa0ca0fe283ca19ebea9193987bc", "trx_in_block" => 0, "virtual_op" => 0}], [7816, %{"block" => 3107390, "id" => "2.17.1197663", "op" => ["vote", %{"author" => "pro.bitcoin", "permlink" => "podkast-pro-bitkoin-samye-glavnye-novosti-iz-mira-kriptovalyut-vypusk-27", "voter" => "ontofractal", "weight" => 10000}], "op_in_trx" => 0, "timestamp" => "2017-02-03T12:36:12", "trx_id" => "a7ce75dcd43641edd498d77bb4a938c9cdeb7405", "trx_in_block" => 0, "virtual_op" => 0}]]
  ```
  """
  @spec get_account_history(String.t(), integer, integer) :: {:ok, [map]} | {:error, any}
  def get_account_history(name, from, limit) do
    call("get_account_history", [name, from, limit])
  end
end
