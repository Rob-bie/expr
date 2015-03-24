defmodule Expr.Stack do
  
  def push(stack, e), do: [e|stack]
  def pop([]), do: {nil, nil}
  def pop([e|stack]), do: {e, stack}

end