defmodule Wanderer do
  require Logger
  use GenServer

  @interval 1_000

  ## Public Interface
  def start_link(wandering?), do: GenServer.start_link(__MODULE__, wandering?, name: __MODULE__)
  def pause, do: GenServer.cast(__MODULE__, :pause)
  def resume, do: GenServer.cast(__MODULE__, :resume)

  ## GenServer Callbacks
  def init(wandering?) do
    :random.seed(:os.timestamp)
    {:ok, wandering?, @interval}
  end

  def handle_cast(:pause, _wandering?) do
    Driver.stop
    {:noreply, false, @interval}
  end
  def handle_cast(:resume, _wandering?), do: {:noreply, true, @interval}
  def handle_info(:timeout, false), do: {:noreply, false, @interval}
  def handle_info(:timeout, true) do
    Logger.info "Wanderer :: Picking Random Move"
    random_move
    {:noreply, true, @interval}
  end
  def handle_info(message, wandering?) do
    Logger.error "Wanderer received unexpected message"
    Logger.error message
    {:noreply, wandering?, @interval}
  end

  ## Private Interface
  defp random_move do
    moves = [:stop, :forward, :backward, :right, :left, :back_right, :back_left]
    move = Enum.shuffle(moves) |> List.first
    Logger.info "Driver, please #{move}"
    apply(Driver, move, [])
  end
end
