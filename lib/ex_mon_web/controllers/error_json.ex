defmodule ExMonWeb.ErrorJSON do
  import Ecto.Changeset, only: [traverse_errors: 2]
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render("400.json", %{result: %Ecto.Changeset{} = result}) do
    %{message: translate_errors(result)}
  end

  def render("400.json", %{result: message}) do
    %{message: message}
  end

  defp translate_errors(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
