defmodule Golos.Ops.LimitOrderCancel do
  @enforce_keys [:orderid, :owner]
  defstruct [:orderid, :owner]
end
