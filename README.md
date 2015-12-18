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
	
You should now be able to play Stockfighter. You can find a complete documentation
[here](http://hexdocs.pm/xfighter) for each function's return types.

### Check the API is up

```elixir
iex> Xfighter.heartbeat
```

### Check a venue is up

```elixir
iex> Xfighter.Venue.heartbeat("TESTEX")
```
### Stocks on a venue

```elixir
iex> Xfighter.Stock.list("TESTEX")
```

### The Orderbook for a stock

```elixir
iex> Xfighter.Stock.orderbook("FOOBAR", "TESTEX")
```

### Place an order for a stock

```elixir
#Buy order
iex> Xfighter.Stock.buy(10, "FOOBAR", "TESTEX", "EXB123456", "market")
iex> Xfighter.Stock.buy(10, "FOOBAR", "TESTEX", "EXB123456", "limit", 50.16)
iex> Xfighter.Stock.buy(10, "FOOBAR", "TESTEX", "EXB123456", "fok", 40)
iex> Xfighter.Stock.buy(10, "FOOBAR", "TESTEX", "EXB123456", "ioc", 20.5)

#Sell order
iex> Xfighter.Stock.sell(10, "FOOBAR", "TESTEX", "EXB123456", "market")
iex> Xfighter.Stock.sell(10, "FOOBAR", "TESTEX", "EXB123456", "limit", 50.16)
iex> Xfighter.Stock.sell(10, "FOOBAR", "TESTEX", "EXB123456", "fok", 40)
iex> Xfighter.Stock.sell(10, "FOOBAR", "TESTEX", "EXB123456", "ioc", 20.5)
```

### A quote for a stock

```elixir
iex> Xfighter.Stock.quote("FOOBAR", "TESTEX")
```

### Status for an existing order

```elixir
iex> Xfighter.Order.status(1649, "FOOBAR", "TESTEX")
```

### Cancel an order

```elixir
iex> Xfighter.Order.cancel(1649, "FOOBAR", "TESTEX")
```

### Status for all orders for an account

```elixir
iex> Xfighter.Account.status("EXB123456", "TESTEX")
```
### Status for all orders in a stock

```elixir
iex> Xfighter.Account.orders("EXB123456", "FOOBAR", "TESTEX")
```

## License

This project is licensed under the terms of the MIT License.
