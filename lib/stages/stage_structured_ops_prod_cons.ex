defmodule Golos.Stage.StructuredOps.ProducerConsumer do
  use GenStage
  require Logger
  alias Golos.Ops

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    Logger.info("Golos structured ops producer initializing...")
    {:producer_consumer, state, subscribe_to: state[:subscribe_to], dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_events(events, _from, number) do
    structured_events = for {_op_type, op_data, op_metadata} <- List.flatten(events) do
       {Ops.Transform.prepare_for_db(op_data), op_metadata}
     end
    {:noreply, structured_events, number}
  end

end
