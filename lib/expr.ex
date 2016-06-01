defmodule Expr do

  import Expr.Stack
  import Expr.Ops

  def eval!(expr) do
    expr
    |> Expr.Parser.expressionify
    |> calculate
  end

  def eval!(expr, vars) do
    expr
    |> Expr.Parser.expressionify(vars)
    |> calculate
  end

  def calculate(rpn), do: calculate(rpn, [])
  def calculate([], stk), do: stk

  def calculate(rpn, stk) do
    {top, stack} = pop(rpn)
    cond do
      is_number(top) -> calculate(stack, push(stk, top))
      true           ->
        func = oprs[top].f
        cond do
          is_function(func, 2) ->
            {{o, _}, {ox, st}} = {pop(stk), elem(pop(stk), 1) |> pop}
            calculate(stack, push(st, func.(ox, o)))
          is_function(func, 1) ->
            {o, st} = pop(stk)
            calculate(stack, push(st, func.(o)))
        end
    end
  end

end
