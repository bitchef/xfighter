defmodule Xfighter.Venue do
  alias Xfighter.Exception.ConnectionError
  import Xfighter.API, only: [request: 2]
  require Logger

  @doc """
  Check if a venue is up.

  ## Example:

      iex> Xfighter.Venue.heartbeat("TESTEX")
      true
  """
  @spec heartbeat(String.t) :: boolean

  def heartbeat(venue) when is_bitstring(venue) do
    try do
      case request(:get, "/venues/#{venue}/heartbeat") do
        {200, _body} -> true
        _otherwise -> false
      end
    rescue
      _e in ConnectionError -> false
      _e in InvalidJSONError -> false
    end
  end

end #defmodule
