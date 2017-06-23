defmodule Golos.Stage.Supervisor do
  use Supervisor
  alias Golos.Stage

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: :golos_producer_sup)
  end

  def init(:ok) do
    blocks_producer = Stage.Blocks
    stage_ops_prod_cons = Stage.Ops
    stage_structured_ops_prod_cons = Stage.StructuredOps
    children = [
      worker(blocks_producer, [[], [name: blocks_producer]]),
      worker(stage_ops_prod_cons, [[subscribe_to: [blocks_producer]], [name: stage_ops_prod_cons]]),
      worker(stage_structured_ops_prod_cons, [[subscribe_to: [stage_ops_prod_cons]], [name: stage_structured_ops_prod_cons]]),
      # worker(Stage.StructuredOps.ExampleConsumer, [[subscribe_to: [stage_structured_ops_prod_cons]]]),
    ]

    supervise(children, strategy: :one_for_all)
  end


end
