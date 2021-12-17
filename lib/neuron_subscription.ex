defmodule Neuron.Subscription do
  use GenServer

  @impl true
  def init(opts) do
    {:ok, opts}
  end

  def supervisor(subscriber: subscriber, url: url, token: token) do
    {AbsintheWebSocket.Supervisor,
     [
       subscriber: subscriber,
       url: url,
       token: token,
       base_name: subscriber,
       async: true
     ]}
  end

  def subscribe(module, query, %{} = variables) do
    callback = fn result ->
      apply(module, :handle_update, [result])
    end

    AbsintheWebSocket.SubscriptionServer.subscribe(
      Module.concat(module, SubscriptionServer),
      Neuron.Subscription,
      callback,
      query,
      variables
    )
  end
end