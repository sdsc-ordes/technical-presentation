<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Slices

---

## Vectors and Arrays {auto-animate="true"}

Lets write a `sum` function for arrays `[i64; 10]`:

```rust {data-id="sum" line-numbers=}
fn sum(data: &[i64; 10]) -> i64 {
  let mut total = 0;

  for val in data {
    total += val;
  }

  total
}
```

---

## Vectors and Arrays {auto-animate="true"}

Or one for just vectors:

```rust {data-id="sum" line-numbers=}
fn sum(data: &Vec<i64>) -> i64 {
  let mut total = 0;

  for val in data {
    total += val;
  }

  total
}
```

---

## Slices

There is better way.

Slices are typed as `[T]`, where `T` is the type of the elements in the slice.

### Properties

::: incremental

- A **slice** is a dynamically sized view into a **contiguous sequence**.

- **Contiguous**: elements in memory are evenly spaced.

- **Dynamically Sized**: the size of the slice is not stored in the type. It is
  determined at runtime.

- **View**: a slice is **never an owned data** structure.

:::

---

## Slices {auto-animate="true"}

The catch with size known at compile time:

:::::: {.columns}

::: {.column width="40%"}

```rust {data-id="slice-ref-a" line-numbers="|1"}
fn sum(data: [i64]) -> i64 {
  let mut total = 0;

  for val in data {
    total += val;
  }

  total
}

fn main() {
  let data = vec![10, 11, 12];
  println!("{}", sum(data));
}
```

:::

:::{.column width="60%" .fragment }

```text {data-id="slice-ref-b" .no-compile line-numbers="6-8"}
error[E0277]: the size for values of type `[i64]`
              cannot be known at
              compilation time
 --> src/main.rs:1:8
  |
1 | fn sum(data: [i64]) -> i64 {
  |        ^^^^ doesn't have a size known
                at compile-time
  |
  = help: the trait `Sized` is not
          implemented for `[i64]`
help: function arguments must have a
      statically known size, borrowed types
      always have a known size
```

:::

::::::

::: notes

- This cannot compile because [T] cannot exist on its own because it is never an
  owned data structure
- We must always put slices behind a pointer type.

:::

---

## Slices {auto-animate="true"}

:::::: {.columns}

::: {.column width="40%"}

```rust {data-id="slice-ref-a" line-numbers="1"}
fn sum(data: &[i64]) -> i64 {
  let mut total = 0;

  for val in data {
    total += val;
  }

  total
}

fn main() {
  let data = vec![10, 11, 12];
  println!("{}", sum(data));
}
```

:::

:::{.column width="60%"}

```text {data-id="slice-ref-b" line-numbers="6-8"}
Compiling playground v0.0.1 (/playground)
Finished dev [unoptimized + debuginfo] target(s) in 0.89s
 Running `target/debug/playground`
```

:::

::::::

---

## Slices - Memory Layout

:::::: {.columns}

::: {.column width="50%"}

::: incremental

- `[T]` is an **incomplete type**: we need to know how many `T`s there are.

- Types with known compile-time size implement the `Sized` trait, raw slices
  **do not**.

- Slices must always be behind a reference type, i.e. `&[T]` and `&mut [T]` (but
  also `Box<[T]>` etc.).

- The length of the slice is always stored together with the reference

:::

:::

::: {.column style="width:50%; align-content:center;"}

::: {.r-stack}

![](${meta:include-base-dir}/assets/images/A1-slice-memory-layout-1.svgbob){.svgbob
.fade-in-then-out .fragment}

![](${meta:include-base-dir}/assets/images/A1-slice-memory-layout-2.svgbob){.svgbob
.fade-in-then-out .fragment}

:::

:::

::::::

---

## Creating Slices

One cannot create slices out of thin air, they have to be located somewhere.
Three possibilities:

::: incremental

- **Using a borrow:**

  - We can borrow from arrays and vectors to create a slice of their entire
    contents.

- **Using ranges:**

  - We can use ranges to create a slice from parts of a vector or array.

- **Using a literal** (for immutable slices only)**:**

  - We can have memory statically available from our compiled binary.

:::

---

## Creating Slices - Borrowing

Using a borrow:

```rust
fn sum(data: &[i32]) -> i32 { /* ... */ }

fn main() {
  let v = vec![1, 2, 3, 4, 5, 6];
  let total = sum(&v);

  println!("{}", total);
}
```

---

## Creating Slices - Ranges

Using ranges:

:::::: {.columns}

::: {.column style="width:50%; align-content:center;"}

```rust
fn sum(data: &[i32]) -> i32 { /* ... */ }

fn main() {
  let v = vec![0, 1, 2, 3, 4, 5, 6];
  let all = sum(&v[..]);
  let except_first = sum(&v[1..]);
  let except_last = sum(&v[..5]);
  let except_ends = sum(&v[1..5]);
}
```

:::

::: {.column style="width:50%; align-content:center;"}

- The range `start..end` is half-open, e.g. <br> `x` in `[s..e]` fulfills
  `s <= x < e`.

::: incremental

- A range is a type
  [`std::ops::Range<T>`](https://doc.rust-lang.org/std/ops/struct.Range.html).

  ```rust {.fragment}
  use std::ops::Range;

  fn main() {
    let my_range: Range<u64> = 0..20;

    for i in 0..10 {
      println!("{}", i);
    }
  }
  ```

:::

:::

::::::

---

## Creating Slices

From a literal:

```rust {line-numbers="3-5,12|7-9,13|all"}
fn sum(data: &[i32]) -> i32 { todo!("Sum all items in `data`") }

fn get_v_arr() -> &'static [i32] {
    &[0, 1, 2, 3, 4, 5, 6]
}

fn main() {
  let all = sum(get_v_arr());
}
```

- Interestingly `get_v_arr` works, but **looks like it would only exist
  temporarily**.

- Literals actually exist during the entire lifetime of the program.

- `&'static` indicates: this slice exist for the **entire lifetime** of the
  program (later more on lifetimes).

---

## Strings {id="more-on-strings"}

We have already seen the `String` type being used before, but let's dive a
little deeper

- Strings are used to represent text.

- In Rust they are always valid UTF-8.
- Their data is stored on the heap.

- A `String` is similar to `Vec<u8>` with extra checks to prevent creating
  invalid text.

::: notes

- We store data on the heap, so we can easily have strings of variable sizes and
  grow and shrink them as needed when they are modified.
- In general we really don't care about the exact length of the string -->

:::

---

## Strings {id="more-on-strings"}

Let's take a look at some strings

```rust
fn main() {
  let s = String::from("Hello world 🌏");

  println!("{:?}", s.split_once(" "));

  println!("{}", s.len());

  println!("{:?}", s.starts_with("Hello"));

  println!("{}", s.to_uppercase());

  for line in s.lines() {
    println!("{}", line);
  }
}
```

---

## String Literals {auto-animate="true"}

Constructing some strings

```rust {data-id="str" line-numbers=}
fn main() {
  let s1 = "Hello world 🌏";
  let s2 = String::from("Hello world");
}
```

- `s1` is a slice of type `&str`: a string slice.

---

## String Literals {auto-animate="true"}

Constructing some strings

```rust {data-id="str" line-numbers="2-3"}
fn main() {
  let s1: &str = "Hello world";
  let s2: String = String::from("Hello world");
}
```

---

## The String Slice - `&str`

Its possible to get only a part of a string. But what is it?

::: incremental

- Not `[u8]`: not every sequence of bytes is valid UTF-8

- Not `[char]`: we could not create a slice from a string since it is stored as
  UTF-8 encoded bytes [(one unicode character takes multiple `char`s).]{ .small }

:::

::: {.fragment}

**It needs a new type: `str`.**

- For string slices we do not use brackets!

:::

---

## Types `str`, `String`, `[T; N]`, `Vec`

:::::{.columns}

:::{.column style="width:50%; align-content: center"}

| Static   | Dynamic  | Borrowed |
| -------- | -------- | -------- |
| `[T; N]` | `Vec<T>` | `&[T]`   |
| -        | `String` | `&str`   |

:::

::: {.column width="50%"}

::: incremental

- There is no static variant of `String`.

- Only useful if we wanted strings of an exact length.

- But just like we had the static slice literals, we can use `&'static str`
  literals for that instead!

:::

:::

::::::

---

## `String` or `str` ?

When to use `String` and when `str`?

:::::: {.columns .fragment}

::: {.column}

```rust {line-numbers="1" .no-compile}
fn string_len1(data: &String) -> usize {
  data.len()
}
```

:::

::: {.column .fragment}

```rust {line-numbers="1" .does-compile}
fn string_len1(data: &str) -> usize {
  data.len()
}
```

:::

::::::

::: incremental

- [**Prefer `&str` over `String` whenever possible.**]{.emph} <br> Reason: `&str`
  gives more freedom to the caller  🚀

- To mutate a string use: `&mut str`, but you cannot change a slice's length.

- Use `String` or `&mut String` if you need to fully mutate the string.

:::
