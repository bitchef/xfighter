defmodule Xfighter.Orderbook do
  import Xfighter.API, only: [decode_response: 2, request: 2]

  @type entry :: %{price: non_neg_integer, qty: non_neg_integer, isBuy: boolean}

  @type t :: %__MODULE__{
            ok: boolean,
            venue: String.t,
            symbol: String.t,
            bids: [__MODULE__.entry],
            asks: [__MODULE__.entry],
            ts: String.t
  }

  defstruct ok: false,
            venue: "",
            symbol: "",
            bids: [],
            asks: [],
            ts: ""

  @doc """
  Get the orderbook for a particular stock.

  ## Examples:

  ```
  iex> Xfighter.Orderbook.state("FOOBAR", "TESTEX")
  {:ok,
   %Xfighter.Orderbook{
     asks: [%{isBuy: false, price: 6000, qty: 3320},
            %{isBuy: false, price: 6000, qty: 5000}],
     bids: [%{isBuy: true, price: 5850, qty: 2554654},
            %{isBuy: true, price: 5000, qty: 375879}],
     ok: true, symbol: "FOOBAR", ts: "2015-12-17T23:30:37.455298328Z",
     venue: "TESTEX"}}

  iex> Xfighter.Orderbook.state("FOOBAR", "TEST")
  {:error, {:request, "Error 404:  No venue exists with the symbol TEST"}}
  ```
  """
  @spec state(String.t, String.t) :: {:ok, __MODULE__.t} | {:error, tuple}

  def state(stock, venue) when is_bitstring(stock) and is_bitstring(venue) do
    try do
      {:ok, state!(stock, venue)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
      e in InvalidJSON -> {:error, {:json, InvalidJSON.message(e)}}
    end
  end

  @doc """
  Get the orderbook for a particular stock.

  A `RequestError` exception is raised if the venue could not be found or
  the stock is not traded on the venue.

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  An `InvalidJSON` is raised if the response is not a valid JSON.

  ## Examples:

  ```
  iex> Xfighter.Orderbook.state!("FOOBAR", "TESTEX")
   %Xfighter.Orderbook{
     asks: [%{isBuy: false, price: 6000, qty: 3320},
            %{isBuy: false, price: 6000, qty: 5000}],
     bids: [%{isBuy: true, price: 5850, qty: 2554654},
            %{isBuy: true, price: 5000, qty: 375879}],
     ok: true, symbol: "FOOBAR", ts: "2015-12-17T23:30:37.455298328Z",
     venue: "TESTEX"}

  iex> Xfighter.Orderbook.state!("FOOBAR", "TEST")
  ** (RequestError) Error 404:  No venue exists with the symbol TEST
  ```
  """
  @spec state!(String.t, String.t) :: __MODULE__.t

  def state!(stock, venue) when is_bitstring(stock) and is_bitstring(venue) do
    request(:get, "/venues/#{venue}/stocks/#{stock}")
    |> decode_response(as: __MODULE__)
  end
end #defmodule
