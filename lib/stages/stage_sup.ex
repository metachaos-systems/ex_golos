defmodule Golos.StageSupervisor do
  use Supervisor
  alias Golos.Stage

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: :golos_producer_sup)
  end

  def init(:ok) do
    blocks_producer = Stage.Blocks
    raw_ops_stage = Stage.RawOps
    munged_ops_stage = Stage.MungedOps
    children = [
      worker(blocks_producer, [[], [name: blocks_producer]]),
      worker(raw_ops_stage, [[subscribe_to: [blocks_producer]], [name: raw_ops_stage]]),
      worker(munged_ops_stage, [[subscribe_to: [raw_ops_stage]], [name: munged_ops_stage]]),
      # worker(Stage.MungedOps.ExampleConsumer, [[subscribe_to: [munged_ops_stage]]]),
    ]

    supervise(children, strategy: :one_for_all)
  end


end
