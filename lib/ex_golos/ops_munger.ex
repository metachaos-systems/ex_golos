defmodule Golos.RawOps.Munger do
  alias Golos.RawOps.{Transfer, Comment, CustomJson, TransferToVesting, FeedPublish}
  alias Golos.MungedOps
  alias Golos.Cleaner

  def parse(%Transfer{} = op) do
    parsed =
      %{token: _, amount: _} =
      op.amount
      |> parse_steemlike_token_amount()

    op =
      op
      |> Map.delete(:__struct__)
      |> Map.merge(parsed)

    struct(MungedOps.Transfer, op)
  end

  def parse(%TransferToVesting{} = op) do
    parsed =
      %{token: _, amount: _} =
      op.amount
      |> parse_steemlike_token_amount()

    op =
      op
      |> Map.delete(:__struct__)
      |> Map.merge(parsed)

    struct(MungedOps.TransferToVesting, op)
  end

  def parse(%Comment{} = op) do
    op =
      op
      |> Map.delete(:__struct__)
      |> Map.update!(:title, &if(&1 == "", do: nil, else: &1))
      |> Map.update!(:parent_author, &if(&1 == "", do: nil, else: &1))
      |> Cleaner.parse_json_strings(:json_metadata)
      |> AtomicMap.convert(safe: false)
      |> Cleaner.extract_fields()

    struct(MungedOps.Comment, op)
  end

  def parse(%FeedPublish{exchange_rate: %{base: base, quote: quote}} = op) do
    base = base |> parse_steemlike_token_amount()
    quote = quote |> parse_steemlike_token_amount()

    op =
      op
      |> Map.from_struct()
      |> Map.delete(:exchange_rate)
      |> Map.merge(%{base_amount: base.amount, base_token: base.token})
      |> Map.merge(%{quote_amount: quote.amount, quote_token: quote.token})

    struct(MungedOps.FeedPublish, op)
  end

  def parse(%CustomJson{json: json} = op) when is_binary(json) do
    parse(%{op | json: Poison.Parser.parse!(json)})
  end

  def parse(%CustomJson{id: id, json: [op_name, op_data]})
      when id == "follow" and op_name == "follow" do
    op =
      op_data
      |> AtomicMap.convert(safe: false)

    struct(MungedOps.Follow, op)
  end

  def parse(%CustomJson{id: id, json: [op_name, op_data]})
      when id == "follow" and op_name == "reblog" do
    op =
      op_data
      |> AtomicMap.convert(safe: false)

    struct(MungedOps.Reblog, op)
  end

  def parse(op), do: op

  def parse_steemlike_token_amount(binary) do
    {int, remaining_token_string} = Float.parse(binary)

    token =
      cond do
        String.match?(remaining_token_string, ~r"GBG") -> "GBG"
        String.match?(remaining_token_string, ~r"GOLOS") -> "GOLOS"
      end

    %{token: token, amount: int}
  end
end
