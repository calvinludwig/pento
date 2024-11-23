defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess:",
       random_number: :rand.uniform(10),
       won: false
     )}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <.link href="#" phx-click="guess" phx-value-number={n}>
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <%= if @won do %>
      <button phx-click="restart">Play Again</button>
    <% end %>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    guess_number = String.to_integer(guess)
    random_number = socket.assigns.random_number

    if guess_number == random_number do
      {:noreply, assign(socket, message: "You won!", won: true, score: socket.assigns.score + 5)}
    else
      {:noreply, assign(socket, message: "Try again!", score: socket.assigns.score - 1)}
    end
  end

  def handle_event("restart", _params, socket) do
    {:noreply,
     assign(socket, message: "Make a guess:", random_number: :rand.uniform(10), won: false)}
  end
end
