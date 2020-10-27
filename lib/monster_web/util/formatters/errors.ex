defmodule MonsterWeb.Formatters.Errors do
  @spec bad_request(binary) :: %{msg: binary, status: 400}
  def bad_request(message) when is_binary(message) do
    %{
      status: 400,
      msg: message
    }
  end

  def ecto_errors(errors) when is_list(errors) do
    message = Enum.reduce(errors, "", fn {field, {msg, options}}, acc ->

      msg = Enum.reduce(options, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)

      acc <> "#{Atom.to_string(field)}: #{msg}\n"
    end)

    %{
      status: 400,
      msg: message
    }
  end
end
