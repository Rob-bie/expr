defmodule Expr.Parser do

  import Expr.Constants
  import Expr.Stack
  import Expr.Ops

  def expressionify(expr) do
    expr
    |> lex
    |> conv
    |> format
    |> parse
  end

  def expressionify(expr, vars) do
    expr
    |> lex
    |> conv(vars)
    |> format
    |> parse
  end
  
  def lex(input) do
    regex = ~r/()[\+|)|\(|\-|\*|\/|^|!|]()/

    String.split(input)
    |> Enum.map(&Regex.split(regex, &1, [on: [1,2], trim: true]))
    |> List.flatten
  end

  def parse(tokens), do: parse(tokens, {[], []})
  def parse([], {[], rpn}), do: Enum.reverse(rpn)
  def parse([], {[o|t], rpn}), do: parse([], {t, [o|rpn]})

  def parse([e|t], {ops, rpn}) when is_number(e) do
    parse(t, {ops, push(rpn, e)})
  end

  def parse([e|t], {ops, rpn}) when e == "(" do
    parse(t, {push(ops, e), rpn})
  end

  def parse([e|t], {ops, rpn}) when e == ")" do
    parse(t, empty_parens({ops, rpn}))
  end

  def parse([e|t], {ops, rpn}) do
    {top, _} = pop(ops)
    a = oprs[e].a
    cond do
      top == nil or top == "(" -> parse(t, {push(ops, e), rpn})
      a == :r and oprs[e].p >= oprs[top].p ->
        parse(t, {push(ops, e), rpn})
      oprs[e].p > oprs[top].p  -> parse(t, {push(ops, e), rpn})
      true                     -> parse(t, shift(e, {ops, rpn}))
    end
  end

  def shift(e, {ops, rpn}) do
    {top, stack} = pop(ops)
    cond do
      top == nil or top == "(" -> {push(ops, e), rpn}
      oprs[top].p >= oprs[e].p -> shift(e, {stack, push(rpn, top)})
      true                     -> {push(ops, e), rpn}
    end
  end

  def empty_parens({ops, rpn}) do
    {top, stack} = pop(ops)
    case top do
      "(" -> {stack, rpn}
      nil -> {[], rpn}
       _  -> empty_parens({stack, push(rpn, top)})
    end
  end

  def format(tokens), do: format(Enum.with_index(tokens), tokens, [])
  def format([], _, acc), do: Enum.reverse(acc)
  def format([{"-", 0}|t], copy, acc), do: format(t, copy, ["#"|acc])

  def format([{"-", i}|t], copy, acc) do
    {prev, next} = if i == 0 do
      {nil, Enum.at(copy, i + 1)}
    else
      {Enum.at(copy, i - 1), Enum.at(copy, i + 1)}
    end

    cond do
      is_number(prev) and is_number(next) ->
        format(t, copy, ["-"|acc])
      prev == "!" -> 
        format(t, copy, ["-"|acc])
      prev == ")" and next == "(" ->
        format(t, copy, ["-"|acc])
      prev == "-" and next == "-" ->
        format(t, copy, ["#"|acc])
      prev == "(" and next == "-" ->
        format(t, copy, ["#"|acc])
      prev == ")" and is_number(next) or next == "-" ->
        format(t, copy, ["-"|acc])
      is_number(next) -> format(tl(t), copy, [next * -1|acc])
      next == "("     -> format(t, copy, ["#"|acc])
      true            -> format(t, copy, ["#"|acc])
    end
  end

  def format([{"(", 0}|t], copy, acc), do: format(t, copy, ["("|acc])

  def format([{"(", i}|t], copy, acc) do
    prev = Enum.at(copy, i - 1)
    empty? = if i - 2 < 0 do
      nil
    else
      Enum.at(copy, i - 2) != "("
    end

    cond do
      is_number(prev)            -> format(t, copy, ["("|["*"|acc]])
      prev == ")" and empty?     -> format(t, copy, ["("|["*"|acc]])
      true                       -> format(t, copy, ["("|acc])
    end  
  end

  def format([{token, _}|t], copy, acc) do
    format(t, copy, [token|acc])
  end

  def conv(input), do: conv(input, [], %{})
  def conv(input, vars), do: conv(input, [], vars)
  def conv([], acc, _), do: Enum.reverse(acc)

  def conv([token|t], acc, vars) do
    is_num? = Float.parse(token)
    constant? = constants[token]
    variable? = vars[token]
    cond do
      is_num? != :error -> conv(t, [elem(is_num?, 0)|acc], vars)
      constant? != nil  -> conv(t, [constant?|acc], vars)
      variable? != nil  -> conv(t, [variable?|acc], vars)
      true              -> conv(t, [token|acc], vars)
    end
  end

end