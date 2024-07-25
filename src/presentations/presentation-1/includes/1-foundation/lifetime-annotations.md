## Lifetime Annotations

---

## What Lifetime?

::: incremental

- References refer to variable.

- Variable has a lifetime:
  - Starts at declaration.
  - Ends at `drop`.

:::

::: {.fragment}

**Question**: Will this compile?

```rust
/// Return reference to longest of `a` or `b`.
fn longer(a: &str, b: &str) -> &str {
    if a.len() > b.len() {
        a
    } else {
        b
    }
}
```

:::

---

## Lifetimes

**Answer**: No. `rustc` needs to know more about `a` and `b`.

::::::{.columns}

:::{.column width="45%"}

```rust {line-numbers="3"}
/// Return reference to longest
/// of `a` and `b`.
fn longer(a: &str, b: &str) -> &str {
  if a.len() > b.len() {
      a
  } else {
      b
  }
}
```

:::

:::{.column width="55%"}

```text {line-numbers="4,12" .no-compile style="font-size:14pt"}
error[E0106]: missing lifetime specifier
 --> src/lib.rs:2:32
  |
2 | fn longer(a: &str, b: &str) -> &str {
  |              ----     ----     ^
  | expected named lifetime parameter
  |
  = help: this function's return type contains
    a borrowed value, but the signature does
    not say whether it is borrowed from `a` or `b`
help: consider introducing a named lifetime parameter
2 | fn longer<'a>(a: &'a str, b: &'a str) -> &'a str {
  |          ++++     ++          ++          ++

For more information about this error,
try `rustc --explain E0106`.
```

:::

::::::

---

## Lifetime Annotations

Solution with lifetime `'l`:

```rust {line-numbers="1"}
fn longer<'l>(a: &'l str, b: &'l str) -> &'l str {
    if a.len() > b.len() {
        a
    } else {
        b
    }
}
```

::::::{.columns}

:::{.column width="50%"}

**English:**

::: incremental

- Given a lifetime called `'l`,
- `longer` takes two references `a` and `b`
- that live for **`>= 'l`**
- and returns a reference that lives for `'l`.

:::

:::

:::{.column width="50%"}

::: {.fragment}

**❗: [Annotations do NOT change the lifetime of variables! Their scopes
do!]{.emph}**<br> They just provide information for the borrow checker.

:::

:::

::::::

---

## Validating Boundaries

- Lifetime validation is done within function boundaries.
- No information of calling context is used.

**Question:** Why?

---

## Lifetime Annotations in Types

```rust
/// A struct that contains a reference to a T
pub struct ContainsRef<'r, T> {
  reference: &'r T
}
```

---

## Lifetime Elision

Question: "Why haven't I come across this before?"

[Answer: "Because of lifetime elision!"]{.fragment}

---

### Lifetime Elision

Rust compiler has heuristics for eliding lifetime bounds:

::: incremental

- Each elided lifetime in input position becomes a distinct lifetime parameter.

  ::::::{.columns}

  :::{.column width="40%"}

  ```rust {.code-no-margin}
  fn print(a: &str, b: &str)
  ```

  :::

  :::{.column width="60%"}

  ```rust {.code-no-margin}
  fn print(a: &'l1 str, b: &'l2 str)
  ```

  :::

  ::::::

- If there is exactly one input lifetime position (elided or annotated), that
  lifetime is assigned to all elided output lifetimes.

  ::::::{.columns}

  :::{.column width="40%"}

  ```rust {.code-no-margin}
  fn print(a: &str) -> (&str, &str)
  ```

  :::

  :::{.column width="60%"}

  ```rust {.code-no-margin}
  fn print(a: &'l1 str) -> (&'l1 str, &'l1 str)
  ```

  :::

  ::::::

- If there are multiple input lifetime positions, but one of them is `&self` or
  `&mut self`, the lifetime of `self` is assigned to all elided output
  lifetimes.

  ::::::{.columns}

  :::{.column width="40%"}

  ```rust {.code-no-margin}
  fn print(&self, a: &str) -> &str
  ```

  :::

  :::{.column width="60%"}

  ```rust {.code-no-margin}
  fn print(&self: &'l1 str, a: &'l2 str) -> &'l1 str
  ```

  :::

  ::::::

- Otherwise, annotations are needed to satisfy compiler.

:::

::: notes

- Rust is smart and tries to infer the lifetimes if it can do so.

:::

---

## Lifetime Elision Examples

```rust {line-numbers="all|1-2|4-5|7-8|10|12|14-15"}
fn print(s: &str);                                      // elided
fn print<'a>(s: &'a str);                               // expanded

fn debug(lvl: usize, s: &str);                          // elided
fn debug<'a>(lvl: usize, s: &'a str);                   // expanded

fn substr(s: &str, until: usize) -> &str;               // elided
fn substr<'a>(s: &'a str, until: usize) -> &'a str;     // expanded

fn get_str() -> &str;                                   // ILLEGAL (why?)

fn frob(s: &str, t: &str) -> &str;                      // ILLEGAL (why?)

fn get_mut(&mut self) -> &mut T;                        // elided
fn get_mut<'a>(&'a mut self) -> &'a mut T;              // expanded
```
