defmodule Golos.Stage.MungedOps.ExampleConsumer do
  use GenStage
  alias Golos.MungedOps
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

  def process_event(%{
        data: %MungedOps.Reblog{} = op_data,
        metadata: op_metadata = %{block_height: h, timestamp: t}
      }) do
    Logger.info("""
    Новый реблог:
    #{inspect(op_data)} в блоке #{h}, время: #{t}
    """)
  end

  def process_event(%{data: op_data, metadata: %{block_height: h, timestamp: t} = op_metadata}) do
    Logger.info("""
    Новая операция:
    #{inspect(op_data)} в блоке #{h}, время: #{t}
    """)
  end
end
