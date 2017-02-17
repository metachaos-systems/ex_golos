defmodule Golos.OpsHandlerExample do
  use GenServer
  require Logger

  @doc """
  Starts the handler module
  """
  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(config \\ %{}) do
    {:ok, config}
  end

  def handle_info({:comment, data}, state) do
    Logger.info("Новый пост или комментарий:  #{inspect(data)}" )
    {:noreply, state}
  end

  def handle_info({:vote, data}, state) do
    Logger.info("Новый голос:  #{inspect(data)}" )
    {:noreply, state}
  end


  def handle_info({op_type, op_data}, state) do
    Logger.info("Новая операция #{op_type}:  #{inspect(op_data)}" )
    {:noreply, state}
  end


end
