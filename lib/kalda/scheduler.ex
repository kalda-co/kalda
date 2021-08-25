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

# TODO: add it to your list of child processes in Kalda.Application
# See [tutorial](https://blog.appsignal.com/2020/06/24/best-practices-for-background-jobs-in-elixir.html)
