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
    {:ok, %{last_height: last_height}}
  end

  def handle_info(:tick, state) do
    {:ok, data} = Golos.get_block(state.last_height)
    unpack_operations(data)
    Process.send_after(self(), :tick, 3_000)
    state = put_in(state.last_height, state.last_height + 1)
    {:noreply, state}
  end

  def unpack_operations(block) do
     for tx <- block["transactions"] do
      for op <- tx["operations"] do
        convert_to_struct(op)
      end
     end
  end

  def convert_to_struct(op = [op_type, op_data]) do
    alias Golos.Ops.{Comment, Vote, CustomJson, POW2, CommentOptions,
      FeedPublish, Transfer, AccountCreate,TransferToVesting, LimitOrderCreate, LimitOrderCancel}
    op_data = AtomicMap.convert(op_data, safe: false)
    build_struct_from_op = fn x -> struct(x, op_data) end
    case op_type do
      "comment" -> build_struct_from_op(Comment)
      "vote" -> build_struct_from_op(Vote)
      "custom_json" ->
        parsed_json = Poison.Parser.parse!(op_data[:json])
        op_data = Map.put(op_data, :json, parsed_json)
        build_struct_from_op(CustomJson)
      "pow2" -> build_struct_from_op(POW2)
      "feed_publish" -> build_struct_from_op(FeedPublish)
      "transfer" -> build_struct_from_op(Transfer)
      "account_create" -> build_struct_from_op(AccountCreate)
      "transfer_to_vesting" -> build_struct_from_op(TransferToVesting)
      "limit_order_create" -> build_struct_from_op(LimitOrderCreate)
      "limit_order_cancel" -> build_struct_from_op(LimitOrderCancel)
      "comment_options" -> build_struct_from_op(CommentOptions)
      _ ->
        IO.inspect op_type
        IO.inspect op_data
    end
  end
end
