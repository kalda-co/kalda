defmodule Scheduler do
  use GenServer

  def init(state) do
    send(self(), :work)
    {:ok, state}
  end

  def handle_info(:work, state) do
    # TODO: do the work here
    # Schedule again in an hour
    Process.send_after(self(), :work, 1_000 * 60 * 60)
    {:noreply, state}
  end
end
