defmodule Xfighter.Exception.RequestError do
  defexception [:errors, :message]

  def message(%{errors: errors, message: nil}) do
    "#{inspect errors}"
  end

  def message(%{message: message}), do: message

end #defmodule
