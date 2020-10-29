defmodule MonsterWeb.Plugs.TokenAuthPlug do
  import Plug.Conn

  @token_salt "USER_AUTH_TOKEN"

  def init(_params) do
  end

  def call(%Plug.Conn{} = conn, _params) do
    with [token_string] <- Plug.Conn.get_req_header(conn, "token"),
    {:ok, token_data} <- Phoenix.Token.verify(MonsterWeb.Endpoint, @token_salt, token_string),
    :gt <- NaiveDateTime.compare(token_data.expires, NaiveDateTime.utc_now) do
      # validate token expiration
      NaiveDateTime.utc_now() |> NaiveDateTime.compare(token_data.expires)
      conn |> assign(:token, token_data)
    else
      _ -> conn |> resp(:unauthorized, "unauthorized") |> halt()
    end
  end
end
