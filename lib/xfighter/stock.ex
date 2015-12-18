defmodule Xfighter.Stock do
  alias Xfighter.Exception.ConnectionError
  alias Xfighter.Exception.RequestError

  import Xfighter.API, only: [parse_response: 1, request: 2, request: 3]

  @doc """
  List stocks available for trading on a venue.

  ## Examples:

      iex> Xfighter.Stock.list("TESTEX")
      {:ok,
       %{ok: true,
          symbols: [%{name: "Foreign Owned Occluded Bridge Architecture Resources",
                symbol: "FOOBAR"}]}}

      iex> Xfighter.Stock.list("TEST")
      {:error, {:request, "Error 404:  No venue exists with the symbol TEST"}}
  """
  @spec list(String.t) :: {:ok, Map.t} | {:error, tuple}

  def list(venue) when is_bitstring(venue) do
    try do
      {:ok, list!(venue)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
    end
  end

  @doc """
  List stocks available for trading on a venue.

  A `RequestError` exception is raised if the venue could not be found.

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  ## Examples:

      iex> Xfighter.Stock.list!("TESTEX")
       %{ok: true,
          symbols: [%{name: "Foreign Owned Occluded Bridge Architecture Resources",
                symbol: "FOOBAR"}]}

      iex> Xfighter.Stock.list!("TEST")
      ** (RequestError) Error 404:  No venue exists with the symbol TEST
  """
  @spec list(String.t) :: Map.t

  def list!(venue) when is_bitstring(venue) do
    request(:get, "/venues/#{venue}/stocks")
    |> parse_response
  end

  @doc """
  Get the orderbook for a particular stock.

  ## Examples:
      iex> Xfighter.Stock.orderbook("FOOBAR", "TESTEX")
      {:ok,
       %{asks: [%{isBuy: false, price: 6000, qty: 3320},
                %{isBuy: false, price: 6000, qty: 5000}],
         bids: [%{isBuy: true, price: 5850, qty: 2554654},
                %{isBuy: true, price: 5000, qty: 375879}],
         ok: true, symbol: "FOOBAR", ts: "2015-12-17T23:30:37.455298328Z",
         venue: "TESTEX"}}

      iex> Xfighter.Stock.orderbook("FOOBAR", "TEST")
      {:error, {:request, "Error 404:  No venue exists with the symbol TEST"}}
  """
  @spec orderbook(String.t, String.t) :: {:ok, Map.t} | {:error, tuple}

  def orderbook(stock, venue) when is_bitstring(stock) and is_bitstring(venue) do
    try do
      {:ok, orderbook!(stock, venue)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
    end
  end

  @doc """
  Get the orderbook for a particular stock.

  A `RequestError` exception is raised if the venue could not be found or
  the stock is not traded on the venue.

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  ## Examples:

      iex> Xfighter.Stock.orderbook!("FOOBAR", "TESTEX")
       %{asks: [%{isBuy: false, price: 6000, qty: 3320},
                %{isBuy: false, price: 6000, qty: 5000}],
         bids: [%{isBuy: true, price: 5850, qty: 2554654},
                %{isBuy: true, price: 5000, qty: 375879}],
         ok: true, symbol: "FOOBAR", ts: "2015-12-17T23:30:37.455298328Z",
         venue: "TESTEX"}

      iex> Xfighter.Stock.orderbook!("FOOBAR", "TEST")
      ** (RequestError) Error 404:  No venue exists with the symbol TEST
  """
  @spec orderbook!(String.t, String.t) :: Map.t

  def orderbook!(stock, venue) when is_bitstring(stock) and is_bitstring(venue) do
    request(:get, "/venues/#{venue}/stocks/#{stock}")
    |> parse_response
  end

  @doc """
  Get a quick look at the most recent trade information for a stock.

  Examples:

      iex> Xfighter.Stock.quote("FOOBAR", "TESTEX")
      {:ok,
       %{ask: 6000, askDepth: 8310, askSize: 8310, bid: 5850, bidDepth: 21273447,
         bidSize: 20437211, last: 6000, lastSize: 10,
         lastTrade: "2015-12-17T23:47:02.081622723Z", ok: true,
         quoteTime: "2015-12-17T23:52:55.44241142Z", symbol: "FOOBAR",
         venue: "TESTEX"}}

      iex> Xfighter.Stock.quote("F", "TESTEX")
      {:error, {:request, "Error 404:  Stock F does not trade on venue TESTEX"}}
  """
  @spec quote(String.t, String.t) :: {:ok, Map.t} | {:error, tuple}

  def quote(stock, venue) do
    try do
      {:ok, quote!(stock, venue)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
    end
  end

  @doc """
  Get a quick look at the most recent trade information for a stock.

  A `RequestError` exception is raised if:
    - the venue could not be found
    - the stock is not traded on the venue
    - a request parameter is invalid

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  Examples:

      iex> Xfighter.Stock.quote!("FOOBAR", "TESTEX")
       %{ask: 6000, askDepth: 8310, askSize: 8310, bid: 5850, bidDepth: 21273447,
         bidSize: 20437211, last: 6000, lastSize: 10,
         lastTrade: "2015-12-17T23:47:02.081622723Z", ok: true,
         quoteTime: "2015-12-17T23:52:55.44241142Z", symbol: "FOOBAR",
         venue: "TESTEX"}

      iex> Xfighter.Stock.quote!("F", "TESTEX")
      ** (RequestError) Error 404:  Stock F does not trade on venue TESTEX
  """
  @spec quote!(String.t, String.t) :: Map.t

  def quote!(stock, venue) do
    request(:get, "/venues/#{venue}/stocks/#{stock}/quote")
    |> parse_response
  end

  @doc """
  Place an order to buy a stock.

  ## Examples:

      iex> Xfighter.Stock.buy(10, "FOOBAR", "TESTEX", "EXB123456", "market")
      {:ok,
       %{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-17T23:47:02.081622723Z"}],
         id: 1636, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-17T23:47:02.081620689Z", venue: "TESTEX"}}

      iex> Xfighter.Stock.buy(10, "FOOBAR", "TESTEX", "EXB123456", "limit", 50.16)
      iex> Xfighter.Stock.buy(10, "FOOBAR", "TESTEX", "EXB123456", "fok", 40)
      iex> Xfighter.Stock.buy(10, "FOOBAR", "TESTEX", "EXB123456", "ioc", 20.5)

      iex> Xfighter.Stock.buy(10, "F", "TESTEX", "EXB123456", "limit", 50.16)
      {:error, {:request, "Error 200:  symbol F does not exist on venue TESTEX"}}
  """
  @spec buy(non_neg_integer, String.t, String.t, String.t, String.t, non_neg_integer) :: {:ok, Map.t} | {:error, tuple}

  def buy(qty, stock, venue, account, order_type, price \\ 0) do
    try do
      {:ok, buy!(qty, stock, venue, account, order_type, price)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
    end
  end

  @doc """
  Place an order to buy a stock.

  A `RequestError` exception is raised if:
    - the venue could not be found
    - the stock is not traded on the venue
    - you are not authorized to trade on that account
    - a request parameter is invalid

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  ## Examples:

      iex> Xfighter.Stock.buy!(10, "FOOBAR", "TESTEX", "EXB123456", "market")
       %{account: "EXB123456", direction: "buy",
         fills: [%{price: 6000, qty: 10, ts: "2015-12-17T23:47:02.081622723Z"}],
         id: 1636, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-17T23:47:02.081620689Z", venue: "TESTEX"}

      iex> Xfighter.Stock.buy!(10, "FOOBAR", "TESTEX", "EXB123456", "limit", 50.16)
      iex> Xfighter.Stock.buy!(10, "FOOBAR", "TESTEX", "EXB123456", "fok", 40)
      iex> Xfighter.Stock.buy!(10, "FOOBAR", "TESTEX", "EXB123456", "ioc", 20.5)

      iex> Xfighter.Stock.buy!(10, "F", "TESTEX", "EXB123456", "limit", 50.16)
      ** (RequestError) Error 200:  symbol F does not exist on venue TESTEX
  """
  @spec buy!(non_neg_integer, String.t, String.t, String.t, String.t, non_neg_integer) :: Map.t
  def buy!(qty, stock, venue, account, order_type, price \\ 0)
  def buy!(qty, stock, venue, account, "fok", price) do
    buy!(qty, stock, venue, account, "fill-or-kill", price)
  end
  def buy!(qty, stock, venue, account, "ioc", price) do
    buy!(qty, stock, venue, account, "immediate-or-cancel", price)
  end
  def buy!(qty, stock, venue, account, order_type, price) do
    send_order(qty, stock, venue, account, order_type, price, "buy")
  end

  @doc """
  Place an order to sell a stock.

  ## Examples:

      iex> Xfighter.Stock.sell(10, "FOOBAR", "TESTEX", "EXB123456", "market")
      {:ok,
       %{account: "EXB123456", direction: "sell",
         fills: [%{price: 5850, qty: 10, ts: "2015-12-17T23:49:14.340308147Z"}],
         id: 1637, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-17T23:49:14.340304585Z", venue: "TESTEX"}}

      iex> Xfighter.Stock.sell(10, "FOOBAR", "TESTEX", "EXB123456", "limit", 50.16)
      iex> Xfighter.Stock.sell(10, "FOOBAR", "TESTEX", "EXB123456", "fok", 40)
      iex> Xfighter.Stock.sell(10, "FOOBAR", "TESTEX", "EXB123456", "ioc", 20.5)

      iex> Xfighter.Stock.sell(10, "F", "TESTEX", "EXB123456", "limit", 50.16)
      {:error, {:request, "Error 200:  symbol F does not exist on venue TESTEX"}}
  """
  @spec sell(non_neg_integer, String.t, String.t, String.t, String.t, non_neg_integer) :: {:ok, Map.t} | {:error, tuple}

  def sell(qty, stock, venue, account, order_type, price \\ 0) do
    try do
      {:ok, sell!(qty, stock, venue, account, order_type, price)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
    end
  end

  @doc """
  Place an order to sell a stock.

  A `RequestError` exception is raised if:
    - the venue could not be found
    - the stock is not traded on the venue
    - you are not authorized to trade on that account
    - a request parameter is invalid

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  ## Examples:

      iex> Xfighter.Stock.sell!(10, "FOOBAR", "TESTEX", "EXB123456", "market")
       %{account: "EXB123456", direction: "sell",
         fills: [%{price: 5850, qty: 10, ts: "2015-12-17T23:49:14.340308147Z"}],
         id: 1637, ok: true, open: false, orderType: "market", originalQty: 10,
         price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
         ts: "2015-12-17T23:49:14.340304585Z", venue: "TESTEX"}

      iex> Xfighter.Stock.sell!(10, "FOOBAR", "TESTEX", "EXB123456", "limit", 50.16)
      iex> Xfighter.Stock.sell!(10, "FOOBAR", "TESTEX", "EXB123456", "fok", 40)
      iex> Xfighter.Stock.sell!(10, "FOOBAR", "TESTEX", "EXB123456", "ioc", 20.5)

      iex> Xfighter.Stock.sell!(10, "F", "TESTEX", "EXB123456", "limit", 50.16)
      ** (RequestError) Error 200:  symbol F does not exist on venue TESTEX
  """
  @spec sell!(non_neg_integer, String.t, String.t, String.t, String.t, non_neg_integer) :: Map.t

  def sell!(qty, stock, venue, account, order_type, price \\ 0)
  def sell!(qty, stock, venue, account, "fok", price) do
    sell!(qty, stock, venue, account, "fill-or-kill", price)
  end
  def sell!(qty, stock, venue, account, "ioc", price) do
    sell!(qty, stock, venue, account, "immediate-or-cancel", price)
  end
  def sell!(qty, stock, venue, account, order_type, price) do
    send_order(qty, stock, venue, account, order_type, price, "sell")
  end

  ### Helper function
  defp send_order(qty, stock, venue, account, order_type, price, direction) when is_float(price) do
    send_order(qty, stock, venue, account, order_type, round(price*100), direction)
  end
  defp send_order(qty, stock, venue, account, order_type, price, direction) do
    order = %{"account" => account, "venue" => venue, "stock" => stock,
      "qty" => qty, "price" => price, "orderType" => order_type,
      "direction" => direction} |> Poison.encode!

    request(:post, "/venues/#{venue}/stocks/#{stock}/orders", order)
    |> parse_response
  end

end #defmodule
