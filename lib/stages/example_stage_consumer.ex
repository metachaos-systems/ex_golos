defmodule Golos.Stage.StructuredOps.ExampleConsumer do
  use GenStage
  alias Golos.StructuredOps
  require Logger

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    Logger.info("Golos example consumer is initializing...")
    {:consumer, state, subscribe_to: state[:subscribe_to]}
  end

  def handle_events(events, _from, state) do
    for op <- events do
      process_event(op)
    end
    {:noreply, [], state}
  end

  def process_event({%StructuredOps.Reblog{} = op_data, %{height: h, timestamp: t} =  op_metadata}) do
      Logger.info """
      Новый реблог:
      #{inspect op_data} в блоке #{h}, время: #{t}
      """
  end

  def process_event({op_data, %{height: h, timestamp: t} =  op_metadata}) do
      Logger.info """
      Новая операция:
      #{inspect op_data} в блоке #{h}, время: #{t}
      """
  end

end
