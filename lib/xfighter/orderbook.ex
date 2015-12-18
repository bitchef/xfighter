defmodule Xfighter.Orderbook do

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
end #defmodule
