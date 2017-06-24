defmodule Golos.MungedOps.Reblog do
  @enforce_keys [:account, :author, :permlink]
  defstruct [:account, :author, :permlink]
end
