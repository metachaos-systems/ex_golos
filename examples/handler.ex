defmodule GolosOpsHandler do
  use GenServer

  @doc """
  Starts the handle module
  """
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:golos, :comment}, state) do
    #
  end

  def handle_cast({:golos, :vote}, state) do
    #
  end


end
