defmodule Driver do
  require Logger

  def stop, do: set_pins(forwards: false, backwards: false, left: false, right: false)
  def forward, do: set_pins(forwards: true, backwards: false, left: false, right: false)
  def backwards, do: set_pins(forwards: false, backwards: true, left: false, right: false)
  def right, do: set_pins(forwards: true, backwards: false, left: false, right: true)
  def left, do: set_pins(forwards: true, backwards: false, left: true, right: false)
  def back_right, do: set_pins(forwards: false, backwards: true, left: false, right: true)
  def back_left, do: set_pins(forwards: false, backwards: true, left: true, right: false)

  defp set_pins([]), do: true
  defp set_pins([{pin, set_low}|tail]) do
    set_pin(pin, set_low)
    set_pins(tail)
  end

  # The TX pins are active LOW
  defp set_pin(pin, true), do: Gpio.turn_off(pin)
  defp set_pin(pin, false), do: Gpio.turn_off(pin)
end
