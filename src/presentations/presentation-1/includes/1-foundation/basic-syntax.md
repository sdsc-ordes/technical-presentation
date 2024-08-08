<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Basic Syntax

---

## Variables (1)

```rust
fn main() {
    let some_x = 5;
    println!("some_x = {}", some_x);
    some_x = 6;
    println!("some_x = {}", some_x);
}
```

```text {style="font-size:12pt;"}
Compiling hello-world v0.1.0
error[E0384]: cannot assign twice to immutable variable `some_x`
--> src/main.rs:4:5
2 |     let some_x = 5;
  |         ------
  |         |
  |         first assignment to `some_x`
  |         help: consider making this binding mutable: `mut some_x`
3 |     println!("some_x = {}", some_x);
4 |     some_x = 6;
  |     ^^^^^^^^^^ cannot assign twice to immutable variable
```

- Rust uses snake case (e.g. `some_x`) for variable names.
- The **immutable** (_read-only_) variable cannot be mutated in any way.

---

## Variables (2)

```rust {line-numbers="2,4"}
fn main() {
    let mut some_x = 5;
    println!("some_x = {}", some_x);
    some_x = 6;
    println!("some_x = {}", some_x);
}
```

```text
Compiling hello-world v0.1.0 (/home/teach-rs/Projects/hello-world)
Finished dev [unoptimized + debuginfo] target(s) in 0.26s
Running `target/debug/hello-world`
some_x = 5
some_x = 6
```

- Declare a **mutable** variable with `mut` to update

---

## Declaring a Type of Variable

```rust
fn main() {
    let x: i32 = 20;
    //   ^^^^^---------- Type annotation. (as in python)
}
```

- Rust is strongly and strictly typed.
- Variables use _type inference_, so no need to specify a type.
- We can be explicit in our types (and sometimes have to be).

---

## Primitives: Integers

<!-- prettier-ignore-start -->

:::::: {.columns}
::: {.column width="50%"}

| Length        | Signed  | Unsigned |
| ------------- | ------- | -------- |
| 8 bits        | `i8`    | `u8`     |
| 16 bits       | `i16`   | `u16`    |
| 32 bits       | `i32`   | `u32`    |
| 64 bits       | `i64`   | `u64`    |
| 128 bits      | `i128`  | `u128`   |
| pointer-sized | `isize` | `usize`  |{style="font-size:10pt"}

<br>


:::
::: {.column width="50%"}

**Literals**

```rust
let x = 42;
let y = 42u64; // decimal as u64
let z = 42_000; // underscore separator

let u = 0xff; // hexadecimal
let v = 0o77; // octal
let q = b'A'; // byte syntax (is u8)
let w = 0b0100_1101; // binary
```

:::
::::::
<!-- prettier-ignore-end -->

- Rust prefers explicit integer sizes.
- Use `isize` and `usize` sparingly.

::: notes

Use `isize` and `usize` mostly when working with indexing or other things that
need to have a specific size for your platform.

:::

---

## Primitives: Floating Points Numbers

```rust
fn main() {
    let x = 2.0;    // f64
    let y = 1.0f32; // f32
}
```

- `f32`: single precision (32-bit) floating point number.
- `f64`: double precision (64-bit) floating point number.
- `f128`: 128-bit floating point number.

::: notes

- Rust uses f64 by default
- Similar to integers you can append the type of float to indicate a specific
  literal type

:::

---

## Numerical Operations

```rust
fn main() {
    let sum = 5 + 10;
    let difference = 10 - 3;
    let mult = 2 * 8;
    let div = 2.4 / 3.5;
    let int_div = 10 / 3; // 3
    let remainder = 20 % 3;
}
```

::: incremental

- Overflow/underflow checking in **debug**:

  ```rust
  let a: u8 = 0b1111_1111;
  println!("{}", a + 10); // compiler error:
                 ^^^^^^ attempt to compute `u8::MAX + 10_u8`,
                        which would overflow
  ```

- In **release builds** these expressions are wrapping, for efficiency.

:::

---

## Numerical Operations

- You cannot mix and match types, i.e.:

```rust
fn main() {
    let invalid_div = 2.4 / 5;          // Error!
    let invalid_add = 20u32 + 40u64;    // Error!
}
```

- Rust has your typical operations, just as with other `python` languages.

---

## Primitives: Booleans and Operations

```rust
fn main() {
    let yes: bool = true;
    let no: bool = false;
    let not = !no;
    let and = yes && no;
    let or = yes || no;
    let xor = yes ^ no;
}
```

---

## Comparison Operators

```rust
fn main() {
    let x = 10;
    let y = 20;
    x < y;  // true
    x > y;  // false
    x <= y; // true
    x >= y; // false
    x == y; // false
    x != y; // true
}
```

::: notes

As with numerical operators, you cannot compare different integer and float
types with each other

:::

```rust
fn main() {
    3.0 < 20;      // invalid
    30u64 > 20i32; // invalid
}
```

- Boolean operators short-circuit: i.e. if in `a && b`, `a` is already false,
  then the code for `b` is not executed.

---

## Primitives: Characters

```rust
fn main() {
    let c: char = 'z'; // Note: the single-quotes ''.
    let z = 'ℤ';
    let heart_eyed_cat = '😻';
}
```

- A `char` is a 32-bit **unicode scalar value** (like in python).
<!-- - Very much unlike `C/C++` but like `python` where `char` is 8 bits. -->

::: notes

- The final scalar type is the character, but it isn't often seen.
- Note that it is not the same as u8 (a byte) in Rust, and cannot be used
  interchangeably.
- We'll see later that strings do not use chars, but are encoded as UTF-8
  instead.

:::

---

## Strings

```rust
    let s1 = String::from("Hello, 🌍!");
    //       ^^^^^^ Owned, heap-allocated string
```

::: incremental

- Rust `String`s are UTF-8-encoded.
<!-- - Unlike C/C++: _Not null-terminated_ -->
- Cannot be indexed like Python `str`.
- `String` is heap-allocated.
- Actually many types of strings in Rust
  - `CString`
  - `PathBuf`
  - `OsString`
  - ...

:::

::: notes

- Rusts strings are complicated, because all strings are complicated.
- Rusts strings are UTF-8 encoded sequences.
- Literal strings are static by default and live for the whole life time of the
  program, called string _slices_, being pointers to their start, accompanied
  with the length

:::

---

## Primitives: Tuples

<!-- prettier-ignore-start -->

:::::: {.columns}
::: {.column width="50%"}

```rust {style="font-size:15pt;" .fragment}
fn main() {
  let tup: (i32, f32, char) = (1, 2.0, 'a');
}
```

:::incremental

- Group multiple values into a single compound type.
- Fixed size.
- Different **types** per element.

:::

:::
::: {.column width="50%"}


```rust {.fragment}
fn main() {
  let tup = (1, 2.0, 'Z');
  let (a, b, c) = tup;
  println!("({}, {}, {})", a, b, c);

  let another_tuple = (true, 42);
  println!("{}", another_tuple.1);
}
```

:::incremental

- Tuples can be **destructured** to get to their individual values
- Access an element with `.` followed by a zero based index.

:::

:::
::::::

<!-- prettier-ignore-end -->

::: notes

- Note how the tuple type and the tuple value are constructed similarly, but the
  type contains individual element types.
- We will see more powerful variants of this destructuring later.
- Note that after destructuring the original value is no longer accessible.

:::

---

## Primitives: Arrays

```rust
fn main() {
    let arr: [i32; 3] = [1, 2, 3];
    println!("{}", arr[0]);

    let [a, b, c] = arr;
    println!("[{}, {}, {}]", a, b, c);
}
```

:::incremental

- A collection of multiple values, but **same type**.
- Always **fixed length** at compile time (similar to tuples).
- Use `[i]` to access an individual `i`-th value.
- Destructuring as with tuples.
- Rust always checks array bounds when accessing a value in an array.
- **This is not Pythons `list` type!** (`Vec` later).

:::

:::notes

- Create an array by writing a comma-separated list of values inside brackets
- Note unlike `python` it must always have a length defined at compile time and
  cannot be constructed dynamically
- You can also construct an array using [value; repetitions] instead of having to
  write out each value if you have a repeating value.
- For the type declaration the element type and count are separated by a
  semicolon and written between brackets

:::

---

## Control Flow

<!-- prettier-ignore-start -->

:::::: {.columns}
::: {.column width="50%"}

```rust {line-numbers="|3-10|4-9|8|13-16|18-20|" style="font-size:14pt;"}
fn main() {
    let mut x = 0;
    loop {
        if x < 5 {
            println!("x: {}", x);
            x += 1;
        } else {
            break;
        }
    }

    let mut y = 5;
    while y > 0 {
        y -= 1;
        println!("y: {}", x);
    }

    for i in [1, 2, 3, 4, 5] {
        println!("i: {}", i);
    }
}
```

:::
::: {.column width="50%"}

- A loop or if condition must always evaluate to a boolean type, so no `if 1`.

- Use `break` to break out of a loop, also works with `for` and `while`,
  continue to skip to the next iteration.

:::
::::::

<!-- prettier-ignore-end -->

---

## Functions

```rust
fn add(a: i32, b: i32) -> i32 {
    a + b // or: `return a+b`
}

fn returns_nothing() -> () {
    println!("Nothing to report");
}

fn also_returns_nothing() {
    println!("Nothing to report");
}
```

:::incremental

- The function signature must be annotated with types.
- Type inference may be used in function body.
- A function that returns nothing has the return type **_unit_ `()`**
- Either return an expression on the **last line** with **no semicolon** (or
  write `return expr`).

:::

:::notes

- Rust always uses snake case for variables and functions.
- We must annotate each function parameter with a type, using a colon.
- We must annotate the function return type using an arrow (`->`) followed by
  the return type.
- Unit may be omitted, note the syntax looks like an empty tuple: a tuple with
  no value members has no instances, just as with unit.
- In Rust you must always specify your type signatures for function boundaries.

:::

---

## Statements

- **Statements** are instructions that perform some action and **do not return a
  value**.
- A definition of any kind (function definition etc.)
- The `let var = expr;` statement.
- Almost everything else is an _expression_.

<br>

### Examples

<!-- prettier-ignore-start -->

:::::: {.columns}
::: {.column width="50%"}

```rust
fn my_fun() {
    println!("{}", 5);
}
```

```rust
let x = 10;
```

:::
::: {.column width="50%"}

```rust
return 42;
```

```rust {.fragment}
let x = (let y = 10); // invalid
```

:::
::::::

<!-- prettier-ignore-end -->

:::notes

- Note how `let` within a `let` is not allowed because of `let` being a
  statement, thus you may not declare multiple variables at the same time with
  the same value
- `let` is a statement because ownership makes multiple assignments behave
  differently than many would expect, it is almost never what you want in Rust
- It also makes sense if you think of all other declarations also being
  statements

:::

---

## Expressions

::: incremental

- **Expressions** evaluate to a **resulting value**.
- Expressions make up most of the Rust code you write.
- Includes all control flow such as `if` and `loop`.
- Includes scoping braces (`{` and `}`).
- Semicolon (`;`) turns expression into statement.

:::

```rust {line-numbers="all|2-5" data-fragment-index="1"}
fn main() {
    let y = {
        let x = 3;
        x + 1
    };
    println!("{}", y); // 4
}
```

---

## Scope

- We just mentioned the scope braces (`{` and `}`).
- Variable scopes are actually **very important** for how Rust works.

```rust
fn main() {
    println!("Hello, {}", name);  // invalid: name is not yet defined

    {
        let name = "world";  // from this point name is in scope
        println!("Hello, {}", name);
    } // name goes out of scope

    println!("Hello, {}", name);  // invalid: name is no more defined
}
```

---

## Expressions - Control Flow

- **Remember**: A block/function can end with an expression, but it needs to
  have the correct type

- Control flow expressions as a statement do not <br> need to end with a
  semicolon if they return _unit_ (`()`).

```rust {data-fragment-index="all|3-8|10-15" style="font-size:14pt;"}
fn main() {
    let y = 11;

    // if as an expression
    let x = if y < 10 {
        42    // missing ;
    } else {
        24    // missing ;
    };

    // if (control-flow expr.) as a statement
    if x == 42 {
        println!("Foo");
    } else {
        println!("Bar");
    } // no ; necessary
}
```

---

## Expression - Control Flow

### Quiz: Does this compile?

<!-- prettier-ignore-start -->

:::::: {.columns}

::: {.column width="50%"}

```rust {line-numbers=""}
fn main() {
    if 2 < 10 {
        42
    } else {
        24
    }
}
```

:::

::: {.column width="50%"}

::: {.fragment}
```rust {line-numbers=""}
fn main() {
    if 2 < 10 {
        42
    } else {
        24
    };
}
```

**Answer:** [**No**]{.red} - It needs a `;` on line 2 because the `if`
expression returns a value which must be turned into statement
with `};`

:::

:::

::::::


<!-- prettier-ignore-end -->

:::notes

Fix the thing on the last line. Not by adding ; to 42, 24.

:::

---

## Expression - Control Flow

### Quiz: Does this compile?

```rust {line-numbers=""}
fn main() {
    let a = if if 1 != 2 { 3 } else { 4 } == 4 {
        2
    } else {
        1
    };

    println!("{}", a)
}}
```

::: {.fragment}

**Answer:** [**Yes**]{.green} - `a == 1`.

:::

---

## Scope (more)

When a scope ends, all variables for that scope become "extinct"
(deallocated/removed from the stack).

<!-- prettier-ignore-start -->

:::::: {.columns}

::: {.column width="50%"}

```rust
fn main() { // nothing in scope here
  let i = 10; // i is now in scope

  if i > 5 {
      let j = 20; // j is now in scope
      println!("i = {}, j = {}", i, j);
  } // j is no longer in scope

  println!("i = {}", i);
} // i is no longer in scope
```
:::

::: {.column width="50%"}

```python {.fragment}
def main():
  i = 10;

  if i > 5:
      j = 20
      print(j)


  print(i, j) # 💩: j is STILL in scope
```
:::
::::::

<!-- prettier-ignore-end -->

**Note**: This is very **different** from `python`.

---

## Printing & Formatting Values

With the `format!` or `println!` macros (later) you can format or print
variables to `stdout` of your application:

```rust
fn main() {
  let x = 130;
  let y = 50;

  println!("{} + {}", x, y);
  println!("{x} + {y}");

  let s: String = format!("{x:04} + {0:>10}", y);
  println!("{s}")
}
```

**Output:**

```
130 + 50
130 + 50
0130 +         50
```

---

## Exercise Time

Approx. Time: 20-45 min.

Do the following exercises:

- `basic-syntax`: 01-07, 08 (optional)

  **Build/Run/Test:**

  ```bash
  just build basic-syntax --bin 01
  just run basic-syntax --bin 01
  just test basic-syntax --bin 01
  ```

  **Continuously evaluate with `cargo-watch`:**

  ```bash
  just watch build basic-syntax --bin 01
  just watch run basic-syntax --bin 01
  just watch test basic-syntax --bin 01
  ```
