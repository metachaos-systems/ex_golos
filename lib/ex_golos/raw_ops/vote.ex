defmodule Golos.RawOps.Vote do
  @enforce_keys [:author, :permlink, :voter, :weight]
  defstruct [:author, :permlink, :voter, :weight]
end
