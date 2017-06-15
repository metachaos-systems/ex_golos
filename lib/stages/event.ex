defmodule Steemex.Event do
  @enforce_keys [:type, :data, :metadata]
  defstruct [:type, :data, :metadata]
end
