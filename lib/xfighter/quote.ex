defmodule Xfighter.Quote do
  @type t :: %__MODULE__{
            ok: boolean,
            symbol: String.t,
            venue: String.t,
            bid: non_neg_integer,
            ask: non_neg_integer,
            bidSize: non_neg_integer,
            askSize: non_neg_integer,
            bidDepth: non_neg_integer,
            askDepth: non_neg_integer,
            last: non_neg_integer,
            lastSize: non_neg_integer,
            lastTrade: String.t,
            quoteTime: String.t
  }

  defstruct ok: false,
            symbol: "",
            venue: "",
            bid: 0,
            ask: 0,
            bidSize: 0,
            askSize: 0,
            bidDepth: 0,
            askDepth: 0,
            last: 0,
            lastSize: 0,
            lastTrade: "",
            quoteTime: ""
end #defmodule
