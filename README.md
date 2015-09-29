# expr

expr is an Elixir library for parsing and evaluating mathematical expressions.

- [expr](#expr)
  - [Installation](#installation)
  - [Examples](#examples)
    - [Operators and constants](#operators-and-constants)
    - [Basic examples](#basic-examples)
    - [Variable usage](#variable-usage)
    - [Caveats](#caveats)
  - [TODO](#todo)
  - [License](#license)



## Installation

Add Expr to your ```mix.exs``` dependencies:

```elixir 
def deps do
  [{:expr, "~> 0.1.0"}]
end
```

Afterwards, run the command ```mix deps.get``` and you're good to go.

## Examples

##### Operators and constants

| Operator  |Precedence | Associativity |
| :-------------: | :-------------: | :------------: |
| log10  | 4  | RIGHT |
| floor  | 4  | RIGHT |
| ceil  | 4  | RIGHT |
| asin  | 4  | RIGHT |
| acos  | 4  | RIGHT |
| atan  | 4  | RIGHT |
| sqrt  | 4  | RIGHT |
| log  | 4  | RIGHT |
| tan  | 4  | RIGHT |
| cos  | 4  | RIGHT |
| sin  | 4  | RIGHT |
| abs  | 4  | RIGHT |
| !  | 4  | RIGHT |
| #  | 4  | RIGHT |
| ^  | 4  | RIGHT |
| /  | 3  | LEFT |
| *  | 3  | LEFT |
| +  | 2  | LEFT |
| - | 2  | LEFT |
  <br>
  
| Symbol  | Value |
| :-------------: | :-------------: |
| pi  | 3.14 ...  |
| e | 2.71 ...|

##### Basic examples

The result of all evaluations are returned at the front of a list. As of version ```0.1.0``` there is no error checking or expression validation. If something goes wrong, an arithmetic error will be thrown. While the parser will understand your intent for most expressions, the more explicit you are, the better. (Be liberal with parenthesis if you're getting unexpected results!)

```elixir
Expr.eval!("1 + 2 * 3")
=> [7.0]

Expr.eval!("5/2")
=> [2.5]

Expr.eval!("5! + abs(-5)")
=> [125.0]

Expr.eval!("--4") #Negation
=> [4.0]

Expr.eval!("5(sqrt(abs(-16)))") #Implicit multiplication
=> [20.0]

Expr.eval!("(5^2)(floor(2.75))") #Implicit multiplication #2
=> [50.0]

Expr.eval!("sin(60)") #RADIANS!
=> [-0.3048106211022167]
```

##### Variable usage

Valid variable names cannot contain operator names, constant names or start with numbers. Starting with capital letters, containing numbers and unused symbols are fine. However, I recommend using short, lowercase variable names. A map of variable names and their values are passed to ```Expr.eval!``` along with an expression when evaluating expressions that contain variables.

```elixir
Expr.eval!("x + y / x", %{"x" => 2, "y" => 4})
=> [3.0]

Expr.eval!("-x@ + 1", %{"x@" => 2})
=> [-1.0]

Expr.eval!("-(sqrt(abs(some_var)))", %{"some_var" => -2.5})
=> [-1.5811388300841898]

Expr.eval!("ABC+2^CBA", %{"ABC" => 2, "CBA" => 3})
=> [10.0]

vars = %{"a" => 2.5, "b" => 3, "c" => 0.25, "d" => 10, "z" => 6.5}
Expr.eval!("a^(b+c)-d(z)", vars)
=> [-45.35260266120413]
```

##### Caveats

- Technically you can have a variable name that is the same as a constant name, however the constant's value will override the value of the variable.

 ```Expr.eval!("pi + 1", %{"pi" => 1}) => 4.141592...```
 

- Sometimes a malformed expression will actually evaluate and return a list of length ```>1```, whenever this happens know something has gone wrong.


- Complex numbers are not supported, it's not uncommon that you'll have a properly formed expression and somewhere during the calculation an arithmetic error will be thrown. For example, trying to take the square root of a negative number.


- Negation is represented by ```#``` under the hood, ```#``` can be used in expressions. 


- Implicit multiplication is currently only *partially* supported. While ```pi(r^2)``` is entirely valid, ```pir^2``` is unfortunately not. This may be coming in a future version.


## TODO

- Function support for functions with arity ```>2```
- More operator/constant support
- Expression validator
- Improved implicit multiplication
- Clean up messy parser code
- Comments.

## License

```
This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the LICENSE file for more details.
```

