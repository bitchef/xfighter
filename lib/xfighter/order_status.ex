defmodule Xfighter.OrderStatus do

  @type t :: %__MODULE__{
            ok: boolean,
            symbol: String.t,
            venue: String.t,
            direction: String.t,
            originalQty: non_neg_integer,
            qty: non_neg_integer,
            price: non_neg_integer,
            orderType: String.t,
            id: non_neg_integer,
            account: String.t,
            ts: String.t,
            fills: [Xfighter.Order.fill],
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
            orderType: "",
            id: 0,
            account: "",
            ts: "",
            fills: [],
            totalFilled: 0,
            open: false

end #defmodule
