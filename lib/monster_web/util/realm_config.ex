defmodule MonsterWeb.RealmConfig do
  require Logger
  use GenServer

  def start_link(_) do
    GenServer.start(__MODULE__, %{}, [name: __MODULE__])
  end

  @impl GenServer
  @spec init(any) ::
          {:ok, %{account_endpoint: binary(), name: binary(), public_key: binary(), token_endpoint: binary()}}
  def init(_) do
    {:ok, fetch_realm_config()}
  end

  @impl GenServer
  def handle_call(:get_config, _from, state) do
    {:reply, state, state}
  end

  def fetch_realm_config() do
    [realm_url: url] = Application.get_env(:monster, __MODULE__)
    Logger.info("Keycloak Realm is located at: #{url}")
    Logger.info("Fetching config from realm...")

    resp = Tesla.get!(url)

    %{
      "realm" => name,
      "public_key" => public_key,
      "token-service" => token_endpoint,
      "account-service" => account_endpoint
    } = Jason.decode!(resp.body)

    Logger.info("Keycloak Realm Name: #{name}")
    Logger.info("Keycloak Realm Public Key: <#{public_key}>")
    Logger.info("Keycloak Realm Token Endpoint: #{token_endpoint}")
    Logger.info("Keycloak Realm Account Endpoint: #{account_endpoint}")

    %{
      name: name,
      public_key: public_key,
      token_endpoint: token_endpoint,
      account_endpoint: account_endpoint,
    }
  end

  def get_config() do
    GenServer.call(__MODULE__, :get_config)
  end
end
