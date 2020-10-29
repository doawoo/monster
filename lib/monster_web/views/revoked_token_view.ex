defmodule MonsterWeb.RevokedTokenView do
  use MonsterWeb, :view
  alias MonsterWeb.RevokedTokenView

  def render("index.json", %{revoked_tokens: revoked_tokens}) do
    %{data: render_many(revoked_tokens, RevokedTokenView, "revoked_token.json")}
  end

  def render("show.json", %{revoked_token: revoked_token}) do
    %{data: render_one(revoked_token, RevokedTokenView, "revoked_token.json")}
  end

  def render("revoked_token.json", %{revoked_token: revoked_token}) do
    %{id: revoked_token.id,
      token_string: revoked_token.token_string}
  end
end
