defmodule Xfighter.Order do
  alias Xfighter.Exception.ConnectionError
  alias Xfighter.Exception.RequestError

  import Xfighter.API, only: [parse_response: 1, request: 2]

  @doc """
  Get the status of an existing order.

  ## Examples:

      iex> Xfighter.Order.status(1649, "FOOBAR", "TESTEX")
      {:ok,
       %{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}}

      iex> Xfighter.Order.status(1660, "FOOBAR", "TESTEX")
      {:error,
       {:request,
         "Error 404:  order 1660 not found (highest available on this venue is 1650)"}}
  """
  @spec status(integer, String.t, String.t) :: {:ok, Map.t} | {:error, tuple}

  def status(order_id, stock, venue) do
    try do
      {:ok, status!(order_id, stock, venue)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
    end
  end

  @doc """
  Get the status of an existing order.

  A `RequestError` exception is raised if:
    - the venue could not be found
    - the stock is not traded on the venue
    - the order id is invalid

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  ## Examples:

      iex> Xfighter.Order.status!(1649, "FOOBAR", "TESTEX")
       %{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}

      iex> Xfighter.Order.status!(1660, "FOOBAR", "TESTEX")
      ** (RequestError) Error 404:  order 1660 not found (highest available on this venue is 1650)
  """
  @spec status!(integer, String.t, String.t) :: Map.t
  def status!(order_id, stock, venue) do
    request(:get, "/venues/#{venue}/stocks/#{stock}/orders/#{order_id}")
    |> parse_response
  end

  @doc """
  Cancel an order.

  ## Examples:

      iex> Xfighter.Order.cancel(1649, "FOOBAR", "TESTEX")
      {:ok,
       %{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}}

      iex> Xfighter.Order.cancel(1660, "FOOBAR", "TESTEX")
      {:error,
       {:request,
         "Error 404:  order 1660 not found (highest available on this venue is 1650)"}}
  """
  @spec cancel!(integer, String.t, String.t) :: {:ok, Map.t} | {:error, tuple}

  def cancel(order_id, stock, venue) do
    try do
      {:ok, cancel!(order_id, stock, venue)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
    end
  end

  @doc """
  Cancel an order.

  A `RequestError` exception is raised if:
    - the venue could not be found
    - the stock is not traded on the venue
    - the order id is invalid

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  ## Examples:

      iex> Xfighter.Order.cancel!(1649, "FOOBAR", "TESTEX")
       %{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}

      iex> Xfighter.Order.cancel!(1660, "FOOBAR", "TESTEX")
      ** (RequestError) Error 404:  order 1660 not found (highest available on this venue is 1650)
  """
  @spec cancel!(integer, String.t, String.t) :: Map.t

  def cancel!(order_id, stock, venue) do
    request(:delete,"/venues/#{venue}/stocks/#{stock}/orders/#{order_id}" )
    |> parse_response
  end

end #defmodule
