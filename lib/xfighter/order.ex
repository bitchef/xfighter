defmodule Xfighter.Order do
  alias Xfighter.Exception.ConnectionError
  alias Xfighter.Exception.InvalidJSON
  alias Xfighter.Exception.RequestError
  alias Xfighter.OrderStatus

  import Xfighter.API, only: [decode_response: 2, request: 2]

  @type fill :: %{price: non_neg_integer, qty: non_neg_integer, ts: String.t}

  @type t :: %__MODULE__{
            ok: boolean,
            symbol: String.t,
            venue: String.t,
            direction: String.t,
            originalQty: non_neg_integer,
            qty: non_neg_integer,
            price: non_neg_integer,
            type: String.t,
            id: non_neg_integer,
            account: String.t,
            ts: String.t,
            fills: [__MODULE__.fill],
            totalFilled: non_neg_integer,
            open: boolean

  }

  defstruct ok: false,
            symbol: "",
            venue: "",
            direction: "",
            originalQty: 0,
            qty: 0,
            price: 0,
            type: "",
            id: 0,
            account: "",
            ts: "",
            fills: [],
            totalFilled: 0,
            open: false


  @doc """
  Get the status of an existing order.

  ## Examples:

      iex> Xfighter.Order.status(order)
      {:ok,
       %Xfighter.OrderStatus{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}}

      iex> Xfighter.Order.status(1660, "FOOBAR", "TESTEX")
      {:error,
       {:request,
         "Error 404:  order 1660 not found (highest available on this venue is 1650)"}}
  """
  @spec status(__MODULE__.t) :: {:ok, OrderStatus.t} | {:error, tuple}

  def status(order=%__MODULE__{}), do: status(order.id, order.symbol, order.venue)

  @doc """
  Get the status of an existing order.

  ## Examples:

      iex> Xfighter.Order.status(1649, "FOOBAR", "TESTEX")
      {:ok,
       %Xfighter.OrderStatus{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}}

      iex> Xfighter.Order.status(1660, "FOOBAR", "TESTEX")
      {:error,
       {:request,
         "Error 404:  order 1660 not found (highest available on this venue is 1650)"}}
  """
  @spec status(integer, String.t, String.t) :: {:ok, OrderStatus.t} | {:error, tuple}

  def status(order_id, stock, venue) do
    try do
      {:ok, status!(order_id, stock, venue)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
      e in InvalidJSON -> {:error, {:json, InvalidJSON.message(e)}}
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

  An `InvalidJSON` is raised if the response is not a valid JSON.

  ## Examples:

      iex> Xfighter.Order.status!(order)
       %Xfighter.OrderStatus{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}

      iex> Xfighter.Order.status!(1660, "FOOBAR", "TESTEX")
      ** (RequestError) Error 404:  order 1660 not found (highest available on this venue is 1650)
  """
  @spec status!(__MODULE__.t) :: OrderStatus.t

  def status!(order=%__MODULE__{}), do: status!(order.id, order.symbol, order.venue)

  @doc """
  Get the status of an existing order.

  A `RequestError` exception is raised if:
    - the venue could not be found
    - the stock is not traded on the venue
    - the order id is invalid

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  An `InvalidJSON` is raised if the response is not a valid JSON.

  ## Examples:

      iex> Xfighter.Order.status!(1649, "FOOBAR", "TESTEX")
       %Xfighter.OrderStatus{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}

      iex> Xfighter.Order.status!(1660, "FOOBAR", "TESTEX")
      ** (RequestError) Error 404:  order 1660 not found (highest available on this venue is 1650)
  """
  @spec status!(integer, String.t, String.t) :: OrderStatus.t

  def status!(order_id, stock, venue) do
    request(:get, "/venues/#{venue}/stocks/#{stock}/orders/#{order_id}")
    |> decode_response(as: OrderStatus)
  end

  @doc """
  Cancel an order.

  ## Examples:

      iex> Xfighter.Order.cancel(order)
      {:ok,
       %Xfighter.OrderStatus{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}}

      iex> Xfighter.Order.cancel(1660, "FOOBAR", "TESTEX")
      {:error,
       {:request,
         "Error 404:  order 1660 not found (highest available on this venue is 1650)"}}
  """
  @spec cancel(__MODULE__.t) :: {:ok, OrderStatus.t} | {:error, tuple}

  def cancel(order=%__MODULE__{}), do: cancel(order.id, order.symbol, order.venue)

  @doc """
  Cancel an order.

  ## Examples:

      iex> Xfighter.Order.cancel(1649, "FOOBAR", "TESTEX")
      {:ok,
       %Xfighter.OrderStatus{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}}

      iex> Xfighter.Order.cancel(1660, "FOOBAR", "TESTEX")
      {:error,
       {:request,
         "Error 404:  order 1660 not found (highest available on this venue is 1650)"}}
  """
  @spec cancel(integer, String.t, String.t) :: {:ok, Map.t} | {:error, tuple}

  def cancel(order_id, stock, venue) do
    try do
      {:ok, cancel!(order_id, stock, venue)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
      e in InvalidJSON -> {:error, {:json, InvalidJSON.message(e)}}
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

  An `InvalidJSON` is raised if the response is not a valid JSON.

  ## Examples:

      iex> Xfighter.Order.cancel!(order)
       %Xfighter.OrderStatus{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}

      iex> Xfighter.Order.cancel!(1660, "FOOBAR", "TESTEX")
      ** (RequestError) Error 404:  order 1660 not found (highest available on this venue is 1650)
  """
  @spec cancel!(__MODULE__.t) :: OrderStatus.t

  def cancel!(order=%__MODULE__{}), do: cancel!(order.id, order.symbol, order.venue)

  @doc """
  Cancel an order.

  A `RequestError` exception is raised if:
    - the venue could not be found
    - the stock is not traded on the venue
    - the order id is invalid

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  An `InvalidJSON` is raised if the response is not a valid JSON.

  ## Examples:

      iex> Xfighter.Order.cancel!(1649, "FOOBAR", "TESTEX")
       %Xfighter.OrderStatus{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-18T00:03:40.640740258Z"}],
         id: 1649, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-18T00:03:40.640738101Z", venue: "TESTEX"}

      iex> Xfighter.Order.cancel!(1660, "FOOBAR", "TESTEX")
      ** (RequestError) Error 404:  order 1660 not found (highest available on this venue is 1650)
  """
  @spec cancel!(integer, String.t, String.t) :: OrderStatus.t

  def cancel!(order_id, stock, venue) do
    request(:delete,"/venues/#{venue}/stocks/#{stock}/orders/#{order_id}" )
    |> decode_response(as: OrderStatus)
  end

end #defmodule
