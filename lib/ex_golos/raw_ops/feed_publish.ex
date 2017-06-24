defmodule Golos.RawOps.FeedPublish do
  @enforce_keys [:exchange_rate, :publisher]
  defstruct [:exchange_rate, :publisher]
end
