defmodule Golos.ProducerSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: :golos_producer_sup)
  end

  def init(:ok) do
    children = [
      worker(Golos.Stage.Blocks.Producer, [[], [name: :blocks_producer]]),
      worker(Golos.Stage.Txs.ProducerConsumer, [%{subscribe_to: [:blocks_producer]}, [name: :txs_prod_cons]]),
    ]
    supervise(children, strategy: :one_for_all)
  end


end
