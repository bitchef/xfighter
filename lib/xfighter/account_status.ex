defmodule Xfighter.AccountStatus do

  @type t :: %__MODULE__{
            ok: boolean,
            orders: [Xfighter.OrderStatus.t],
            venue: String.t
  }

  defstruct ok: false,
            orders: [],
            venue: ""

end #defmodule
