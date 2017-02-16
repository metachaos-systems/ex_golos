defmodule Golos.Streamer do
  use GenServer

  @doc """
  Starts the handler module
  """
  def start_link(config) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  def init(config) do
    {:ok, %{"head_block_number" => last_height}} = Golos.get_dynamic_global_properties
    Process.send_after(self(), :tick, 3_000)
    {:ok, %{last_height: last_height, stream_to: config.stream_to}}
  end

  def handle_info(:tick, state) do
    {:ok, data} = Golos.get_block(state.last_height)
    for t <- unpack_operations(data), do: Process.send(state.stream_to, t, [])
    Process.send_after(self(), :tick, 3_000)
    state = put_in(state.last_height, state.last_height + 1)
    {:noreply, state}
  end

  def unpack_operations(block) do
     for tx <- block["transactions"] do
      for op <- tx["operations"] do
        convert_to_tuple(op)
      end
     end
  end

  def convert_to_tuple(op = [op_type, op_data]) do
    parse_json_strings = fn x, key ->
      val = x[key]
      case val do
         nil -> x
         _ -> put_in(x, [key], Poison.Parser.parse!(val))
      end
    end
    op_data = op_data
      |> AtomicMap.convert(safe: false)
      |> parse_json_strings.(:json)
      |> parse_json_strings.(:json_metadata)

    op_struct = select_struct(op_type)
    {String.to_atom(op_type), struct(op_struct, op_data)}
  end


  def select_struct(op_type) do
    alias Golos.Ops.{Comment, Vote, CustomJson, POW2, CommentOptions,
      FeedPublish, Transfer, AccountCreate,TransferToVesting, LimitOrderCreate, LimitOrderCancel}
    case op_type do
      "comment" -> Comment
      "vote" -> Vote
      "custom_json" ->
       CustomJson
      "pow2" -> POW2
      "feed_publish" -> FeedPublish
      "transfer" -> Transfer
      "account_create" -> AccountCreate
      "transfer_to_vesting" -> TransferToVesting
      "limit_order_create" -> LimitOrderCreate
      "limit_order_cancel" -> LimitOrderCancel
      "comment_options" -> CommentOptions
      _ ->
        IO.inspect op_type
    end
  end
end
