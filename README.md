# Xfighter

An API wrapper for the programming game [Stockfighter](https://starfighter.readme.io/docs)

## Installation

To use Xfighter in your Mix projects:

  1. Add xfighter to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
   [{:xfighter, "~> 0.0.1"}]
  end
  ```

  2. Ensure xfighter is started before your application:

  ```elixir
  def application do
   [applications: [:xfighter]]
  end
  ```

  4. Add the following line to your `config/config.exs` and insert your API key:

  ```elixir
  config :xfighter, api_key: "INSERT_YOUR_API_KEY_HERE"
  ```

  3. To download and install the package run:

  ```
  mix deps.get
  mix deps.compile
  ```

## Overview

Once the installation is complete, type the following command in your terminal:

```
iex -S mix
```
	
You should now be able to play Stockfighter:

```elixir

iex> Xfighter.Venue.heartbeat("TESTEX")
true

iex> Xfighter.Stock.list("TESTEX")
{:ok,
 %{ok: true,
    symbols: [%{name: "Foreign Owned Occluded Bridge Architecture Resources",
          symbol: "FOOBAR"}]}}

iex> Xfighter.Stock.quote("FOOBAR", "TESTEX")
{:ok,
 %{ask: 6000, askDepth: 8310, askSize: 8310, bid: 5850, bidDepth: 21273447,
   bidSize: 20437211, last: 6000, lastSize: 10,
   lastTrade: "2015-12-17T23:47:02.081622723Z", ok: true,
   quoteTime: "2015-12-17T23:52:55.44241142Z", symbol: "FOOBAR",
   venue: "TESTEX"}}

iex> Xfighter.Stock.buy(10, "FOOBAR", "TESTEX","EXB123456",  "market")
{:ok,
 %{account: "EXB123456", direction: "buy",
   fills: [%{price: 6000, qty: 10, ts: "2015-12-17T23:47:02.081622723Z"}],
   id: 1636, ok: true, open: false, orderType: "market", originalQty: 10,
   price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
   ts: "2015-12-17T23:47:02.081620689Z", venue: "TESTEX"}}

iex> Xfighter.Stock.sell(10, "FOOBAR", "TESTEX","EXB123456",  "market")
{:ok,
 %{account: "EXB123456", direction: "sell",
   fills: [%{price: 5850, qty: 10, ts: "2015-12-17T23:49:14.340308147Z"}],
   id: 1637, ok: true, open: false, orderType: "market", originalQty: 10,
   price: 0, qty: 0, symbol: "FOOBAR", totalFilled: 10,
   ts: "2015-12-17T23:49:14.340304585Z", venue: "TESTEX"}}
```

You can find a complete documentation [here](http://hexdocs.pm/xfighter)

## License

This project is licensed under the terms of the MIT License.
