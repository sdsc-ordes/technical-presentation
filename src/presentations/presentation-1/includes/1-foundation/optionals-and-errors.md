<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Optionals and Error Handling

---

## Generics

`struct`s become more powerful with generics:

```rust
struct PointFloat(f64, f64);
struct PointInt(i64, i64);
```

[This is repeating data types 🤨. Is there something better?]{.fragment}

```rust {.fragment}
struct Point<T>(T, T);

fn main() {
  let float_point: Point<f64> = Point(10.0, 10.0);
  let int_point: Point<i64> = Point(10, 10);
}
```

[Generics are much more powerful (later more!)]{.fragment}

::: notes

- The upper case letter between the angled brackets introduces a generic type
  parameter.
- We can now use that generic type variable we introduced as a type name
- Then at the point of using the type we can specify which actual type we want
  to use
- Generics are much more powerful, but this is enough for now

:::

---

## The `Option` Type

A quick look into the
[standard library of Rust](https://doc.rust-lang.org/std/option/enum.Option.html):

::: incremental

- Rust does not have `null` (out of a reason 🤬 💣 🐞).
- For types which do not have a value: use **`Option<T>`**.

:::

```rust {.fragment}
enum Option<T> {
  Some(T),
  None,
}

fn main() {
  let some_int = Option::Some(42);
  let no_string: Option<String> = Option::None; // You need the type here!
}
```

:::notes

- Note how Rust can infer the type of `some_int`, but we have to specify what
  the type of the Option is in the None case, because it cannot possibly know
  what kind of values you could put in that Option
- Also not that for normal enums we have to import the variants, but Option is
  so common that the variants are available by default without needing to prefix
  them with `Option::`

:::

---

## Error Handling {auto-animate="true"}

What would we do when there is an error?

```rust {data-id="devide" line-numbers="3"}
fn divide(x: i64, y: i64) -> i64 {
  if y == 0 {
    // what to do now?
  } else {
    x / y
  }
}
```

---

## Error Handling {auto-animate="true"}

What would we do when there is an error?

```rust {data-id="devide" line-numbers="3"}
fn divide(x: i64, y: i64) -> i64 {
  if y == 0 {
    panic!("Cannot divide by zero");
  } else {
    x / y
  }
}
```

::: incremental

- A `panic!` in Rust is the most basic way to handle errors.
- A `panic!` will **immediately stop** running the current thread/program using
  one of two methods:

  - **Unwinding**: Going up through the stack and making sure that each value is
    cleaned up.
  - **Aborting**: Ignore everything and immediately exit the thread/program (OS
    will clean up).

:::

::: notes

- Unwinding has its usages, mainly to clean up resources that you previously
  opened.
- An unwind can be stopped, but this is highly unusual to do and very expensive
- In a multithreaded program unwinding is essential to make sure that any memory
  owned by that thread is freed, making sure you don't have any memory leaks
- Rust programs are compiled such that if a panic does not occur, it doesn't add
  any extra cost, but that does mean that if a panic does occur, it isn't very
  fast

:::

---

## Error Handling with `panic!`

- Only use [`panic!`](https://doc.rust-lang.org/std/macro.panic.html) in **small
  programs** if normal error handling would also exit the program.

- ❗Avoid using `panic!` in **library code** or other **reusable components**.

::: notes

- Generally panicking should be avoided as much as possible
- The panic! macro is not the only way to trigger a panic, so beware, we will
  see some ways we can also trigger a panic very soon
- Note that if the main thread panics, the entire program will always exit

:::

---

## Error Handling with `Option<T>`

We could use an
[`Option<T>`](https://doc.rust-lang.org/std/option/enum.Option.html) to handle
the error:

```rust
fn divide(x: i64, y: i64) -> Option<i64> {
  if y == 0 {
    None
  } else {
    Some(x / y)
  }
}
```

---

## Error Handling with `Result<T,E>`

The [`Result<T,E>`](https://doc.rust-lang.org/std/result/enum.Result.html) is a
powerful enum for error handling:

:::::: {.columns}

::: {.column}

```rust {line-numbers="all|2|3|6-9"}
enum Result<T, E> {
  Ok(T),
  Err(E),
}

enum DivideError {
  DivisionByZero,
  CannotDivideOne,
}
```

:::

::: {.column .fragment}

```rust {line-numbers="all|3|5|7" .fragment}
fn divide(x: i64, y: i64) -> Result<i64, DivideError> {
  if x == 1 {
    Err(DivideError::CannotDivideOne)
  } else if y == 0 {
    Err(DivideError::DivisionByZero)
  } else {
    Ok(x / y)
  }
}
```

:::

::::::

---

## Handling Results

Handle the error at the call site:

```rust
fn div_zero_fails() {
  match divide(10, 0) {
    Ok(div) => println!("{}", div),
    Err(e) => panic!("Could not divide by zero"),
  }
}
```

::: incremental

- Signature of `divide` function is **explicit** in how it can fail.
- The user (call site) of it **can decide** what to do, even it decides is
  panicking 🌻.

- **Note:** just as with `Option`: `Result::Ok` and `Result::Err` are available
  globally.

:::

::: notes

- Note how in this case the error still causes a panic, but at least we get a
  choice of what we do

:::

---

## Handling Results

When prototyping you can use `unwrap` or `expect` on `Option` and `Result`:

```rust
fn div_zero_fails() {
  let div = divide(10, 0).unwrap();
  println!("{}", div);

  div = divide(10, 0).expect("should work!");
  println!("{}", div);
}
```

::: incremental

- `unwrap`: return `x` in `Ok(x)` or `Some(x)` or `panic!` if `Err(e)`.
- `expect` the same but with a message.

- **To many** `unwraps` is generally a bad practice.
- If ensured an error won't occur, using `unwrap` is a good solution.

:::

---

## Handling Results

Rust has lots of helper functions on `Option` and `Result`:

```rust
fn div_zero_fails() {
  let div = divide(10, 0).unwrap_or(-1);
  println!("{}", div);
}
```

Besides `unwrap`, there are some other useful utility functions

::: incremental

- `unwrap_or(val)`: If there is an error, use the value given to `unwrap_or`
  instead.
- `unwrap_or_default()`: Use the default value for that type if there is an
  error (`Default`).
- `unwrap_or_else(fn)`: Same as `unwrap_or`, but instead call a function `fn`
  that generates a value in case of an error.

:::

::: notes

- unwrap_or_else is mainly useful if generating a default value is an expensive
  operation

:::

---

## The Magic `?` Operator {auto-animate="true"}

There is a special operator associated with `Result`, the
[**`?` operator**](https://doc.rust-lang.org/std/result/index.html#the-question-mark-operator-)

[See how this function changes if we use the `?` operator:]{.fragment}

```rust {data-id="operator" .fragment line-numbers="all|2-4|7-10"}
fn can_fail() -> Result<i64, DivideError> {
  let res = match divide(10, 0) {
    Ok(v) => v,
    Err(e) => return Err(e),
  };

  match divide(res, 0) {
    Ok(v) => Ok(v * 2),
    Err(e) => Err(e),
  }
}
```

---

## The Magic `?` Operator {auto-animate="true"}

```rust {data-id="operator" line-numbers=""}
fn can_fail() -> Result<i64, DivideError> {
  let a = divide(10, 0)?;
  Ok(divide(a, 0)? * 2)
}
```

---

## The Magic `?` Operator {auto-animate="true"}

```rust {data-id="operator" line-numbers=""}
fn can_fail() -> Result<i64, DivideError> {
  let a = divide(10, 0)?;
  Ok(divide(a, 0)? * 2)
}
```

- The `?` operator does an _implicit match_:

  ::: incremental

  - **on** `Err(e)`  `e` is **immediately returned** (early return).

  - **on** `Ok(v)`  the value `v` is extracted and it contiues.

  :::

---

## Exercise Time (5)

Approx. Time: 20-1.5h min.

Do the following exercises:

- `options` (short)
- `error-handling` (longer)
- `error-propagation` (longer)

**Build/Run/Test:**

```bash
just build <exercise> --bin 01
just run <exercise> --bin 01
just test <exercise> --bin 01
just watch [build|run|test|watch] <exercise> --bin 01
```
