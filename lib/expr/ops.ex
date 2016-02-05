defmodule Expr.Ops do
  
  alias __MODULE__ 

  def __struct__ do
    %{
      :p => nil,
      :f => nil,
      :a => :r
    }
  end

  def oprs do
    %{"#"     => %Ops{:p => 4, :f => &(&1 * - 1)},
      "!"     => %Ops{:p => 4, :f => &fact/1},
      "abs"   => %Ops{:p => 4, :f => &abs/1},
      "sin"   => %Ops{:p => 4, :f => &:math.sin/1},
      "cos"   => %Ops{:p => 4, :f => &:math.cos/1},
      "tan"   => %Ops{:p => 4, :f => &:math.tan/1},
      "log"   => %Ops{:p => 4, :f => &:math.log/1},
      "sqrt"  => %Ops{:p => 4, :f => &:math.sqrt/1},
      "atan"  => %Ops{:p => 4, :f => &:math.atan/1},
      "acos"  => %Ops{:p => 4, :f => &:math.acos/1},
      "asin"  => %Ops{:p => 4, :f => &:math.asin/1},
      "ceil"  => %Ops{:p => 4, :f => &Float.ceil/1},
      "floor" => %Ops{:p => 4, :f => &Float.floor/1},
      "log10" => %Ops{:p => 4, :f => &:math.log10/1},
      "^"     => %Ops{:p => 4, :f => &:math.pow/2},
      "*"     => %Ops{:p => 3, :f => &(&1 * &2), :a => :l},
      "/"     => %Ops{:p => 3, :f => &(&1 / &2), :a => :l},
      "%"     => %Ops{:p => 3, :f => &fmod/2,    :a => :l},
      "+"     => %Ops{:p => 2, :f => &(&1 + &2), :a => :l},
      "-"     => %Ops{:p => 2, :f => &(&1 - &2), :a => :l}}
  end

  def fact(0.0), do: 1.0
  def fact(0), do: 1

  def fact(n) do
   {i, dec} = to_string(n) |> Integer.parse
   case {i, dec} do
    {_, ".0"} -> fact(i, 1)
    {_, ""}   -> fact(i, 1)
    _         -> :bad_arg
   end
  end

  def fact(0, acc), do: acc
  def fact(n, acc), do: fact(n - 1, acc * n)

  def fmod(x, y) do
    n = Float.floor( x / y )
    x - y * n |> Float.round(15)
  end

end

