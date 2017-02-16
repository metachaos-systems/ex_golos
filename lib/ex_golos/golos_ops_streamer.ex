defmodule Golos.Streamer do
  use GenServer

  @doc """
  Starts the handle module
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, %{"head_block_number" => last_height}} = Golos.get_dynamic_global_properties
    Process.send_after(self(), :tick, 3_000)
    # Process.send_after(__MODULE__, :tick, 3_000)
    {:ok, %{last_height: last_height}}
  end

  def handle_info(:tick, state) do
    {:ok, data} = Golos.get_block(state.last_height)
    IO.inspect data
    Process.send_after(self(), :tick, 3_000)
    state = put_in(state.last_height, state.last_height + 1)
    {:noreply, state}
  end


end
