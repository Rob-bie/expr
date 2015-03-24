defmodule ExprTest do
  
  use ExUnit.Case

  test "Stack.push" do
    stack = [1, 2, 3]
    assert Expr.Stack.push(stack, 0) == [0, 1, 2, 3]
  end

  test "Stack.pop" do
    stack = [1, 2, 3]
    assert Expr.Stack.pop(stack) == {1, [2, 3]}
  end

  test "Stack.pop (Empty)" do
    stack = []
    assert Expr.Stack.pop(stack) == {nil, nil}
  end

  test "Lex expr: 1+2/3" do
    expr = "1+2/3"
    result = ["1", "+", "2", "/", "3"]

    assert Expr.Parser.lex(expr) == result
  end

  test "Lex expr: (  (2^4 + 3)  - 1)" do
    expr = "(  (2^4 + 3)  - 1)"
    result = ["(", "(", "2", "^", "4", "+", "3", ")",
              "-", "1", ")"]

    assert Expr.Parser.lex(expr) == result
  end

  test "Format and expand expression" do
    expr = "5(1 + 2)"
    result = [5.0, "*", "(", 1.0, "+", 2.0, ")"]

    assert Expr.Parser.lex(expr)
           |> Expr.Parser.conv
           |> Expr.Parser.format == result
  end

  test "Format and expand expression #2" do
    expr = "-5(1 + -2)"
    result = ["#", 5.0, "*", "(", 1.0, "+", -2.0, ")"]

    assert Expr.Parser.lex(expr)
           |> Expr.Parser.conv
           |> Expr.Parser.format == result
  end

  test "Format and expand expression (complex)" do
    expr = " -( 1  + -2)^2 * -5(cos(60)/2.5^  3)+log(1) "
    result = ["#", "(", 1.0, "+", -2.0, ")", "^",
              2.0, "*", -5.0, "*", "(", "cos", "(",
              60.0, ")", "/", 2.5, "^", 3.0, ")", "+",
              "log", "(", 1.0, ")"]

    assert Expr.Parser.lex(expr)
           |> Expr.Parser.conv
           |> Expr.Parser.format == result
  end


  test "1 + 1 -> postfix" do
    expr = "1 + 1"
    result = [1.0, 1.0, "+"]

    assert Expr.Parser.expressionify(expr) == result
  end

  test "Infix expression -> postfix" do
    expr = "()(( 1 + 1) + 3  ) * 5  ^ 6"
    result = [1.0, 1.0, "+", 3.0, "+", 5.0, 6.0, "^", "*"]

    assert Expr.Parser.expressionify(expr) == result
  end

  test "Eval empty expression" do
    expr = ""
    result = []

    assert Expr.eval!(expr) == result
  end

  test "Eval single value expression" do
    expr = "5"
    result = [5.0]

    assert Expr.eval!(expr) == result
  end

  test "Eval single value expression (neg)" do
    expr = "-5"
    result = [-5.0]

    assert Expr.eval!(expr) == result
  end

  test "Eval basic expression" do
    expr = "1 + 0 + 3 - 4"
    assert Expr.eval!(expr) == [0.0]
  end

  test "Eval factorial expression" do
    expr = "5! + 3.5 * 2"
    result = [127.0]

    assert Expr.eval!(expr) == result
  end

  test "Eval trig expression" do
    expr = "cos(90) / (2^-2)"
    result = [:math.cos(90) / :math.pow(2, -2)]

    assert Expr.eval!(expr) == result
  end

  test "Eval exp expression (Right assoc)" do
    expr = "2^3^4"
    result = [2.4178516392292583e24]

    assert Expr.eval!(expr) == result
  end

  test "Eval exp expression (Forced left assoc)" do
    expr = "(2^3)^4"
    result = [4096.0]

    assert Expr.eval!(expr) == result
  end

  test "Eval negation expression" do
    expr = "-(5 + 8)"
    result = [-13.0]

    assert Expr.eval!(expr) == result
  end

  test "Eval negation expression #2" do
    expr = "--(5 + 8)"
    result = [13.0]

    assert Expr.eval!(expr) == result
  end

  test "Eval negation expression #3" do
    expr = "--(---5)"
    result = [-5.0]

    assert Expr.eval!(expr) == result
  end

  test "Eval negation expression #4" do
    expr = "--5---(---5)"
    result = [10.0]

    assert Expr.eval!(expr) == result
  end

  test "Eval implicit multiplication expression" do
    expr = "5(sqrt(16))"
    result = [20.0]

    assert Expr.eval!(expr) == result
  end

  test "Eval implicit multiplication expression #2" do
    expr = "(abs(-5))(2^3)"
    result = [40.0]

    assert Expr.eval!(expr) == result
  end

  test "Eval rounding expression" do
    expr = "ceil(5.2) + floor(4.9)"
    result = [10.0]

    assert Expr.eval!(expr) == result
  end

  test "Eval complex expression" do
    expr = "((5^2 + 5) / 6^3 +    3 * 4)^2/4+(3-    1 * 2)"
    result = [37.83815586419753]

    assert Expr.eval!(expr) == result
  end

  test "Eval complex expression #2" do
    expr = "5(sqrt(9) + abs(-5)) / 9! - 3"
    result = [-2.999889770723104]

    assert Expr.eval!(expr) == result
  end

  test "Eval complex expression #3" do
    expr = "-2^(sqrt(4) - 2!) / abs(-sin(3.5))"
    result = [-2.850763437540464]

    assert Expr.eval!(expr) == result
  end

  test "Eval complex expression #4" do
    expr = "(4!) / -(sqrt(floor(16.54))) + log10(60)"
    result = [-4.221848749616356]

    assert Expr.eval!(expr) == result
  end

  test "Eval variable expression #1" do
    expr = "(x + y) / z"
    vars = %{"x" => 2, "y" => 4, "z" => 3}
    result = [2.0]

    assert Expr.eval!(expr, vars) == result
  end

  test "Eval variable expression #2" do
    expr = "pi(r^2)"
    vars = %{"r" => 4}
    result = [50.26548245743669]

    assert Expr.eval!(expr, vars) == result
  end

end