defmodule Xfighter do
  alias Xfighter.Exception.ConnectionError
  import Xfighter.API, only: [request: 2]
  require Logger

  @doc """
  A simple health check for the API.

  ## Example:
  iex> Xfighter.heartbeat
  true
  """
  @spec heartbeat :: boolean

  def heartbeat do
    try do
      case request(:get, "/heartbeat") do
        {200, %{:ok => true}} -> true
        _otherwise -> false
      end
    rescue
      _e in ConnectionError -> false
    end
  end

end #defmodule
