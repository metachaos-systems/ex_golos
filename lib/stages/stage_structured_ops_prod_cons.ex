defmodule Golos.Stage.StructuredOps do
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
    structured_events = for event <- List.flatten(events) do
      Map.update!(event, :data, &Ops.Transform.prepare_for_db/1)
    end
    {:noreply, structured_events, number}
  end

end
