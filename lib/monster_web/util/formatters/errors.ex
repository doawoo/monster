defmodule MonsterWeb.Formatters.Errors do
  @spec bad_request(binary) :: %{msg: binary, status: 400}
  def bad_request(message) when is_binary(message) do
    %{
      status: 400,
      msg: message
    }
  end
end
