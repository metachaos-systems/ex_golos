defmodule Golos.Stage.RawOps do
  use GenStage
  require Logger
  alias Golos.Cleaner

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    Logger.info("Golos ops producer initializing...")
    {:producer_consumer, state, subscribe_to: state[:subscribe_to], dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_events(events, _from, number) do
    events = for block <- events, do: unpack_and_convert_operations(block) |> List.flatten
    {:noreply, events, number}
  end

  def unpack_and_convert_operations(%{data: block, metadata: metadata}) do
     for tx <- block.transactions do
      for op <- tx.operations do
        convert_to_event(op, block, metadata)
      end
     end
  end

  def convert_to_event(op = [op_type, op_data], block, metadata) do
    op_data = op_data
      |> AtomicMap.convert(safe: false)
      |> Cleaner.parse_json_strings(:json_metadata)
      |> Cleaner.parse_json_strings(:json)

    op_struct = select_struct(op_type)
    op_data = if op_struct, do: struct(op_struct, op_data), else: op_data
    new_metadata = %{block_height: block.height, timestamp: block.timestamp, blockchain: :golos, type: String.to_atom(op_type) }

    metadata = Map.merge(new_metadata, metadata)
    metadata = Map.put_new(metadata, :source, :naive_realtime)

    %Golos.Event{data: op_data, metadata: metadata}
  end

  def select_struct(op_type) do
    alias Golos.RawOps.{Comment, Vote, CustomJson, POW2, CommentOptions,
      FeedPublish, Transfer, AccountCreate, TransferToVesting, LimitOrderCreate, LimitOrderCancel}
    case op_type do
      "comment" -> Comment
      "vote" -> Vote
      "custom_json" -> CustomJson
      "pow2" -> POW2
      "feed_publish" -> FeedPublish
      "transfer" -> Transfer
      "account_create" -> AccountCreate
      "transfer_to_vesting" -> TransferToVesting
      "limit_order_create" -> LimitOrderCreate
      "limit_order_cancel" -> LimitOrderCancel
      "comment_options" -> CommentOptions
      _ ->
        # Logger.info("ExGolos Ops ProducerConsumer encountered unknown op_type: #{op_type}")
        nil
    end
  end

end
