defmodule Golos.Ops.Transform do
  alias Golos.Ops.{Transfer,Comment, CustomJson}

  def prepare_for_db(%Transfer{} = op) do
    {int, remaining_token_string} = Float.parse(op.amount)
    token = cond do
      String.match?(remaining_token_string, ~r"GBG") -> "GBG"
      String.match?(remaining_token_string, ~r"GOLOS") -> "GOLOS"
    end
    op
      |> Map.delete(:__struct__)
      |> Map.put(:amount, int)
      |> Map.put(:token, token)
  end

  def prepare_for_db(%Comment{} = op) do
    op
      |> Map.delete(:__struct__)
      |> Map.update!(:json_metadata, &Poison.Parser.parse!(&1))
      |> Map.update!(:title, &(if &1 == "", do: nil, else: &1))
      |> Map.update!(:parent_author, &(if &1 == "", do: nil, else: &1))
      |> AtomicMap.convert(safe: false)
      |> (&Map.put(&1, :tags, &1.json_metadata.tags)).()
      |> (&Map.put(&1, :app, &1.json_metadata.app)).()
  end

  def prepare_for_db(%CustomJson{id: id} = op) when id == "follow" do
    op
      |> Map.get(:json)
      |> Poison.Parser.parse!
      |> Enum.at(1)
      |> AtomicMap.convert(safe: false)
  end

  def prepare_for_db(op), do: op

end
