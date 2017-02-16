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
    op_data = AtomicMap.convert(op_data, safe: false)
    case op_type do
      "comment" -> struct(Golos.Ops.Comment, op_data)
      "vote" -> struct(Golos.Ops.Vote, op_data)
      "custom_json" ->
        parsed_json = Poison.Parser.parse!(op_data[:json])
        op_data = Map.put(op_data, :json, parsed_json)
        struct(Golos.Ops.CustomJson, op_data)
      "pow" -> struct(Golos.Ops.POW2, op_data)
      "feed_publish" -> struct(Golos.Ops.FeedPublish, op_data)
      "transfer" -> struct(Golos.Ops.Transfer, op_data)
      "account_create" -> struct(Golos.Ops.AccountCreate, op_data)
      _ -> IO.inspect op_data
    end
  end
end
