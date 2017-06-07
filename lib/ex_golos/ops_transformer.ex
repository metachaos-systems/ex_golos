defmodule Golos.Ops.Transform do
  alias Golos.Ops.{Transfer}

  def prepare_for_db(%Transfer{} = op) do
    {int, remaining_token_string} = Float.parse(op.amount)
    token = cond do
      String.match?(remaining_token_string, ~r"GBG") -> "GBG"
      String.match?(remaining_token_string, ~r"GOLOS") -> "GOLOS"
    end
    op
      |> Map.put(:amount, int)
      |> Map.put(:token, token)
  end

  def prepare_for_db(op), do: op

end
