defmodule Golos.Cleaner do
  def strip_token_names_and_convert_to_number(data) do
    to_clean =
      ~w(max_accepted_payout promoted total_payout_value pending_payout_value total_pending_payout_value
    curator_payout_value promoted balance vesting_withdraw_rate rshares weight
    savings_balance savings_sbd_balance sbd_balance vesting_balance vesting_shares)a

    for {k, v} <- data, into: %{} do
      {k,
       if(
         k in to_clean and !is_float(v) and !is_integer(v),
         do: v |> Float.parse() |> elem(0),
         else: v
       )}
    end
  end

  def prepare_tags(data) do
    update_in(data.tags, &List.wrap/1)
  end

  def parse_empty_strings(data) do
    data
    |> Map.update!(:parent_author, &if(&1 == "", do: nil, else: &1))
    |> Map.update!(:author, &if(&1 == "", do: nil, else: &1))
    |> Map.update!(:permlink, &if(&1 == "", do: nil, else: &1))
  end

  def parse_json_strings(x, key) do
    parsed =
      case x[key] do
        val when is_boolean(val) ->
          %{}

        val when is_map(val) ->
          val

        nil ->
          %{}

        val ->
          case Poison.decode(val) do
            {:ok, map} -> map
            {:error, _, _} -> %{}
          end
      end

    Map.put(x, key, parsed)
  end

  def parse_timedate_strings(data) do
    to_parse =
      ~w(created timestamp time last_payout cashout_time max_cashout_time active last_update)a

    for {k, v} <- data, into: %{} do
      {k, if(k in to_parse, do: NaiveDateTime.from_iso8601!(v), else: v)}
    end
  end

  def extract_fields(data) do
    data
    |> Map.put(:tags, data.json_metadata["tags"] || data.json_metadata[:tags] || [])
    |> Map.put(:app, data.json_metadata["app"] || data.json_metadata[:app] || nil)
  end

  def parse_votes(data) do
    Map.update!(data, :active_votes, fn active_votes ->
      for vote <- active_votes do
        vote
        |> strip_token_names_and_convert_to_number()
        |> parse_timedate_strings()
      end
    end)
  end
end
