defmodule Truck do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Gpio, [17, [name: :right]], id: :right),
      worker(Gpio, [22, [name: :left]], id: :left),
      worker(Gpio, [23, [name: :forwards]], id: :forwards),
      worker(Gpio, [24, [name: :backwards]], id: :backwards),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Truck.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
