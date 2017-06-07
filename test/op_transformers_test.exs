defmodule Golos.Ops.TransformersTest do
  use ExUnit.Case, async: true
  alias Golos.Ops
  doctest Golos

  test "transfer op cleaned correctly " do
    op = %Ops.Transfer{to: "bob", from: "alice", amount: "100 GBG", memo: "nice cypher you've got there"}
    prepared = Ops.Transform.prepare_for_db(op)
    assert prepared == %{to: "bob", from: "alice", amount: 100.0, token: "GBG", memo: "nice cypher you've got there"}
  end

end
