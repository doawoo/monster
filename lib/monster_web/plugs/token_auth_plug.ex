defmodule MonsterWeb.Plugs.TokenAuthPlug do
  import Plug.Conn
  require Logger

  @token_salt "USER_AUTH_TOKEN"

  def init(_params) do
    :ok
  end

  def call(%Plug.Conn{} = conn, _params) do
    with [token_string] <- Plug.Conn.get_req_header(conn, "token"),
    {:ok, token_data} <- Phoenix.Token.verify(MonsterWeb.Endpoint, @token_salt, token_string),
    :gt <- NaiveDateTime.compare(token_data.expires, NaiveDateTime.utc_now),
    nil <- Monster.Tokens.get_revoked_token_by_string(token_string) do
      conn |> assign(:token, token_data) |> assign(:token_string, token_string)
    else
      _ -> conn |> resp(:unauthorized, "unauthorized") |> halt()
    end
  end
end
