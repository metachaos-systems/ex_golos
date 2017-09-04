defmodule Golos.Stage.Blocks do
  @moduledoc """
  Produces Golos block data with @tick_interval
  """
  require Logger
  @tick_interval 1_000
  use GenStage

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state)  do
    Logger.info("Golos blocks producer initializing...")
    :timer.send_interval(@tick_interval, :tick)
    state = if state === [], do: %{}
    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_demand(demand, state) when demand > 0 do
    {:noreply, [], state}
  end

  def handle_info(:tick, state) do
    {:ok, %{head_block_number: height}} = Golos.get_dynamic_global_properties()
    previous_height = Map.get(state, :previous_height, nil)
    if height === previous_height do
      {:noreply, [], state}
    else
      {:ok, block} = Golos.get_block(height)
      if block do
        block = Map.put(block, :height, height)
        new_state = Map.put(state, :previous_height, height)
        meta = %{source: :golos, type: :block}
        events = [%Golos.Event{data: block, metadata: meta}]
        {:noreply, events, new_state}
      else
        {:noreply, [], state}
      end
    end
  end
end