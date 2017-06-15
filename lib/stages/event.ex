defmodule Golos.Event do
  @enforce_keys [:type, :data, :metadata]
  defstruct [:type, :data, :metadata]
end
