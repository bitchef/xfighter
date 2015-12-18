defmodule Xfighter.Symbols do
  @type t :: %__MODULE__{
            ok: boolean,
            symbols: [Xfighter.Stock.symbol],
            symbol: String.t
  }

  defstruct ok: false,
            symbols: [],
            symbol: ""

end #defmodule
