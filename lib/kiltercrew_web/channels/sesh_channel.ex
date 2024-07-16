defmodule KiltercrewWeb.SeshChannel do
  # use KiltercrewWeb, :channel
  use Phoenix.Channel

  @impl true
  def join("sesh:lobby", payload, socket) do
    if authorized?(payload) do
      Process.flag(:trap_exit, true)
      send(self(), {:after_join, payload})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_info({:after_join, _message}, socket) do
    # user_name = socket.assigns.current_user.name
    broadcast!(socket, "crew:joined", %{user_name: "hardcoded"})
    push(socket, "joined", %{status: "connected"})
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (sesh:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
