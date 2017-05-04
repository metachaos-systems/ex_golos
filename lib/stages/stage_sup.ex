defmodule Golos.ProducerSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: :golos_producer_sup)
  end

  def init(:ok) do
    children = [
      worker(Golos.Stage.Blocks.Producer, [[], [name: Golos.Stage.Blocks.Producer]]),
      worker(Golos.Stage.Ops.ProducerConsumer, [%{subscribe_to: [Golos.Stage.Blocks.Producer]}, [name: Golos.Stage.Ops.ProducerConsumer]]),
    ]
    supervise(children, strategy: :one_for_all)
  end


end
