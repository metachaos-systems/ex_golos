defmodule Golos.OperationHistoryApi do

  @moduledoc """
  Contains all functions to call Golos operation_history_api methods
  """

  def call(method, params) do
    Golos.call(["operation_history", method, params])
  end

  @doc """
  If start_permlink is empty then only before_date will be considered. If both are specified the earlier of the two metrics will be used.
  before_date format is: `2017-02-07T14:34:11`
  Example response:
  ```
  ContentResult has the same shape as a result returned by get_content.
  Example result:
  ```
  [ContentResult, ContentResult, ...]
  ```
  """
  @spec get_transaction(String.t()) :: {:ok, map} | {:error, any}
  def get_transaction(trx_id) do
    call("get_transaction", [trx_id])
  end

end
