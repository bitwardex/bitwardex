defmodule BitwardexWeb.HubSocket do
  @behaviour Phoenix.Socket.Transport

  @initial_response [123, 125, 30]

  alias Bitwardex.Accounts.Schemas.User

  def child_spec(_opts) do
    # We won't spawn any process, so let's return a dummy task
    %{id: Task, start: {Task, :start_link, [fn -> :ok end]}, restart: :transient}
  end

  def connect(%{params: params}) do
    # Callback to retrieve relevant data from the connection.
    # The map contains options, params, transport and endpoint keys.

    with {:ok, access_token} <- Map.fetch(params, "access_token"),
         {:ok, user, _} <- BitwardexWeb.Guardian.resource_from_token(access_token) do
      {:ok, %{current_user: user}}
    else
      _ -> :error
    end
  end

  def connect(_), do: :error

  def init(%{current_user: %User{} = user} = state) do
    # Now we are effectively inside the process that maintains the socket.
    Process.send_after(self(), :ping, 15_000)

    Phoenix.PubSub.subscribe(BitwardexWeb.PubSub, "notifications:user:#{user.id}")

    {:ok, state}
  end

  def handle_in({"ping", _opts}, state) do
    {:reply, :ok, {:text, "pong"}, state}
  end

  def handle_in({payload, [opcode: :text]}, state) do
    sanitized_json =
      payload
      |> binary_part(0, byte_size(payload) - 1)
      |> Jason.decode!()

    case sanitized_json do
      %{"protocol" => "messagepack", "version" => 1} ->
        {:reply, :ok, {:binary, @initial_response}, state}
    end
  end

  def handle_info(:ping, state) do
    message =
      build_ping()
      |> encode_message()

    Process.send_after(self(), :ping, 15_000)

    {:reply, :ok, {:binary, message}, state}
  end

  def handle_info({:send, payload}, state) do
    message = encode_message(payload)
    {:reply, :ok, {:binary, message}, state}
  end

  def handle_info(_, state) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

  # Message related functions

  def build_update(type, payload) do
    [
      1,
      [],
      nil,
      "ReceiveMessage",
      [
        %{
          "ContextId" => "app_id",
          "Type" => type,
          "Payload" => payload
        }
      ]
    ]
  end

  def build_ping do
    [6]
  end

  def encode_message(message) do
    content = Msgpax.pack!(message, iodata: false)
    content_size = byte_size(content)

    <<content_size::integer, content::bitstring>>
  end
end
