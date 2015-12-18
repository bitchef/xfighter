defmodule Xfighter.Account do
  alias Xfighter.AccountStatus
  alias Xfighter.Exception.ConnectionError
  alias Xfighter.Exception.InvalidJSON
  alias Xfighter.Exception.RequestError

  import Xfighter.API, only: [decode_response: 2, request: 2]

  @doc """
  Get the status of all orders sent for a given account on a venue.

  ## Examples:

      iex> Xfighter.Account.status("EXB123456", "TESTEX")
      {:ok,
       %Xfighter.AccountStatus{ok: true,
         orders: [%{account: "EXB123456", direction: "buy",
                    fills: [%{price: 100, qty: 1000, ts: "2015-12-17T21:05:41.973124481Z"},
                            %{price: 5000, qty: 1000, ts: "2015-12-17T21:06:21.389102834Z"},
                            %{price: 5000, qty: 1000, ts: "2015-12-17T21:06:21.389085567Z"},
                            %{price: 5000, qty: 1000, ts: "2015-12-17T21:06:21.391050771Z"}, ...],
                    id: 1519, ok: true, open: true, orderType: "limit", originalQty: 450000,
                    price: 5000, qty: 375879, symbol: "FOOBAR", totalFilled: 74121,
                    ts: "2015-12-17T21:05:41.973122583Z", venue: "TESTEX"},
                  %{account: "EXB123456", direction: "buy", fills: [], id: 1523, ok: true,
                    open: true, orderType: "limit", originalQty: 1000, price: 100, qty: 1000,
                    symbol: "FOOBAR", totalFilled: 0, ts: "2015-12-17T21:06:23.405102527Z",
                    venue: "TESTEX"}, ...],
        venue: "TESTEX"}}

      iex> Xfighter.Account.status("SUPERUSER", "TESTEX")
      {:error,
       {:request,
         "Error 401:  Not authorized to access details about that account's orders."}}
  """
  @spec status(String.t, String.t) :: {:ok, AccountStatus.t} | {:error, tuple}

  def status(account, venue) do
    try do
      {:ok, status!(account, venue)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
      e in InvalidJSON -> {:error, {:json, InvalidJSON.message(e)}}
    end
  end

  @doc """
  Get the status of all orders sent for a given account on a venue.

  A `RequestError` exception is raised if:
    - the venue could not be found
    - you are not authorized to access the account

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  An `InvalidJSON` is raised if the response is not a valid JSON.

  ## Examples:

      iex> Xfighter.Account.status!("EXB123456", "TESTEX")
       %Xfighter.AccountStatus{ok: true,
         orders: [%{account: "EXB123456", direction: "buy",
                    fills: [%{price: 100, qty: 1000, ts: "2015-12-17T21:05:41.973124481Z"},
                            %{price: 5000, qty: 1000, ts: "2015-12-17T21:06:21.389102834Z"},
                            %{price: 5000, qty: 1000, ts: "2015-12-17T21:06:21.389085567Z"},
                            %{price: 5000, qty: 1000, ts: "2015-12-17T21:06:21.391050771Z"}, ...],
                    id: 1519, ok: true, open: true, orderType: "limit", originalQty: 450000,
                    price: 5000, qty: 375879, symbol: "FOOBAR", totalFilled: 74121,
                    ts: "2015-12-17T21:05:41.973122583Z", venue: "TESTEX"},
                  %{account: "EXB123456", direction: "buy", fills: [], id: 1523, ok: true,
                    open: true, orderType: "limit", originalQty: 1000, price: 100, qty: 1000,
                    symbol: "FOOBAR", totalFilled: 0, ts: "2015-12-17T21:06:23.405102527Z",
                    venue: "TESTEX"}, ...],
        venue: "TESTEX"}

      iex> Xfighter.Account.status!("SUPERUSER", "TESTEX")
      ** (RequestError) Error 401:  Not authorized to access details about that account's orders.
  """
  @spec status!(String.t, String.t) :: AccountStatus.t

  def status!(account, venue) do
    request(:get, "/venues/#{venue}/accounts/#{account}/orders")
    |> decode_response(as: AccountStatus)
  end

  @doc """
  Get the status for all orders in a stock for an account.

  ## Examples:

      iex> Xfighter.Account.orders("EXB123456", "FOOBAR", "TESTEX")
      {:ok,
       %Xfighter.AccountStatus{ok: true,
          orders: [%{account: "EXB123456", direction: "buy",
                     fills: [%{price: 100, qty: 1000, ts: "2015-12-17T21:05:41.973124481Z"},
                       %{price: 5000, qty: 1000, ts: "2015-12-17T21:06:21.389102834Z"},
                       %{price: 5000, qty: 1000, ts: "2015-12-17T21:06:21.389085567Z"}, ...],
                     id: 1519, ok: true, open: true, orderType: "limit", originalQty: 450000,
                     price: 5000, qty: 375879, symbol: "FOOBAR", totalFilled: 74121,
                     ts: "2015-12-17T21:05:41.973122583Z", venue: "TESTEX"},
                   %{account: "EXB123456", direction: "buy", fills: [], id: 1523, ok: true,
                     open: true, orderType: "limit", originalQty: 1000, price: 100, qty: 1000,
                     symbol: "FOOBAR", totalFilled: 0, ts: "2015-12-17T21:06:23.405102527Z",
                     venue: "TESTEX"},
                   %{account: "EXB123456", direction: "buy", fills: [...], ...},
                   %{account: "EXB123456", direction: "sell", ...},
                   %{account: "EXB123456", ...}, %{...}, ...],
          venue: "TESTEX"}}

      iex> Xfighter.Account.orders("EXB123456", "F", "TESTEX")
      {:error, {:request, "Error 404:  Stock F does not trade on venue TESTEX"}}
  """
  @spec orders(String.t, String.t, String.t) :: {:ok, AccountStatus.t} | {:error, tuple}

  def orders(account, stock, venue) do
    try do
      {:ok, orders!(account, stock, venue)}
    rescue
      e in RequestError -> {:error, {:request, RequestError.message(e)}}
      e in ConnectionError -> {:error, {:connection, ConnectionError.message(e)}}
      e in InvalidJSON -> {:error, {:json, InvalidJSON.message(e)}}
    end
  end

  @doc """
  Get the status for all orders in a stock for an account.

  A `RequestError` exception is raised if:
    - the venue could not be found
    - the stock is not traded on the venue
    - you are not authorized to access the account

  A `ConnectionError` exception is raised if a connection attempt to the venue failed.

  An `UnhandledAPIResponse` exception is raised if an unexpected event occurs.

  An `InvalidJSON` is raised if the response is not a valid JSON.

  ## Examples:

      iex> Xfighter.Account.orders!("EXB123456", "FOOBAR", "TESTEX")
       %Xfighter.AccountStatus{ok: true,
          orders: [%{account: "EXB123456", direction: "buy",
                     fills: [%{price: 100, qty: 1000, ts: "2015-12-17T21:05:41.973124481Z"},
                       %{price: 5000, qty: 1000, ts: "2015-12-17T21:06:21.389102834Z"},
                       %{price: 5000, qty: 1000, ts: "2015-12-17T21:06:21.389085567Z"}, ...],
                     id: 1519, ok: true, open: true, orderType: "limit", originalQty: 450000,
                     price: 5000, qty: 375879, symbol: "FOOBAR", totalFilled: 74121,
                     ts: "2015-12-17T21:05:41.973122583Z", venue: "TESTEX"},
                   %{account: "EXB123456", direction: "buy", fills: [], id: 1523, ok: true,
                     open: true, orderType: "limit", originalQty: 1000, price: 100, qty: 1000,
                     symbol: "FOOBAR", totalFilled: 0, ts: "2015-12-17T21:06:23.405102527Z",
                     venue: "TESTEX"},
                   %{account: "EXB123456", direction: "buy", fills: [...], ...},
                   %{account: "EXB123456", direction: "sell", ...},
                   %{account: "EXB123456", ...}, %{...}, ...],
          venue: "TESTEX"}

      iex> Xfighter.Account.orders!("EXB123456", "F", "TESTEX")
      ** (RequestError) Error 404:  Stock F does not trade on venue TESTEX
  """
  @spec orders!(String.t, String.t, String.t) :: AccountStatus.t

  def orders!(account, stock, venue) do
    request(:get, "/venues/#{venue}/accounts/#{account}/stocks/#{stock}/orders")
    |> decode_response(as: AccountStatus)
  end

end #defmodule
