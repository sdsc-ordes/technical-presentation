<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Composite Types

---

## Types Redux

We have seen so far:

::: incremental

- Primitives (integers, floats, booleans, characters)
- Compounds (tuples, arrays)
- Most of the types we looked at were `Copy`

:::

[Borrowing will make more with some more **complex data types**.]{.fragment}

---

## Structuring data

Rust has two important ways to structure data

- `struct` : **product type**
- `enum`s : **sum type**
- ~~unions~~

::: notes

- We have unions in Rust, but almost everywhere you will use enums instead.
  Unions become relevant once we start talking about FFI and unsafe Rust code.

:::

---

## Structs (_tuple structs_)

A tuple `struct` is similar to a tuple but it has an own name:

```rust
struct ControlPoint(f64, f64, bool);
```

::: {.fragment}

Access to members the same as with tuples:

```rust
fn main() {
  let cp = ControlPoint(10.5, 12.3, true);
  println!("{}", cp.0); // prints 10.5
}
```

:::

::: notes

- Note that two tuples with the same fields in the same order are always the
  same type, whereas two structs with different names but the same fields are
  different types.

:::

---

## Structs

More common (and preferred) - `struct`s with named fields:

```rust
struct ControlPoint {
  x: f64,
  y: f64,
  enabled: bool,
}
```

- Each member has a proper identifier.

::: incremental

```rust {line-numbers="all|2-6|8"}
fn main() {
  let cp = ControlPoint {
    x: 10.5,
    y: 12.3,
    enabled: true,
  };

  println!("{}", cp.x); // prints 10.5
}
```

:::

:::notes

- Named fields are especially easier in usage, as a type alone will most of the
  time not be enough information to determine the full meaning, here we now now
  that the two floats meant the x and y coordinates and we know what the boolean
  indicated.
- To instantiate (create a value) of a struct we use the syntax shown
- Now, we can use the same `x.y` syntax as with tuples, but we have a nice name
  for referencing our fields instead of having to remember the exact field
  index.

:::

---

## Enumerations

One other powerful type is the `enum`. It is a **sum type**:

::::::{.columns}

:::{.column width="50%"}

```rust {line-numbers="all|2|all"}
enum Fruit {
  Banana,
  Apple,
}
```

:::

:::{.column width="50%" .fragment fragment-index="2"}

```rust
fn main() {
  let ip_type = Fruit::Banana;
}
```

:::

::::::

- An enumeration has different _variants_, `python` analogy:

  ```python
  variant: str | int | List[str]
  ```

- Each variant is an alternative value of the `enum`, pick a value on creation.

---

## Enumeration - Mechanics

```rust {line-numbers=}
enum Fruit {
  Banana, // discriminant: 0
  Apple, // discriminant: 1
}
```

::: incremental

- Each `enum` has a _discriminant_ (hidden by default):

  - A numeric value (`isize` by default, can be changed by using
    `#[repr(numeric_type)]`) to determine the current variant.

  - One cannot rely on the discriminant being `isize`, the compiler may decide
    to optimize it.

:::

---

## Enumerations - Data (1)

`Enum`s are very powerful: each variant can have associated data

::::::{.columns .fragment}

:::{.column width="55%"}

```rust
enum Fruit {
  Banana(u16),     // discriminant: 0
  Apple(f32, f32), // discriminant: 1
}
```

```rust {.fragment}
fn main() {
  let 🍌 = Fruit::Banana(3);
  let 🍎 = Fruit::Apple(3.0, 4.);
}
```

:::

:::{.column width="50%" style="align-content:center;"}

- The associated data and the variant are **bound together**.
- Impossible to create `Apple` only giving `u16` integers.

::: incremental

- An `enum` is as large as the largest variant + <br> size of the discriminant.

  ::: {.center-content .p-no-margin}

  ![](${meta:include-base-dir}/assets/images/A1-enum-storage.svgbob){.svgbob}

  :::

:::

:::

::::::

---

## Mix Sum and Product Types

Combining **sum-type** with a **product-type**:

```rust {line-numbers="|2,6,11"}
struct Color {
  rgb: (bool, bool, bool)
}

enum Fruit {
  Banana(Color),
  Apple(bool, bool)
}

fn main() {
  let 🍌 = Fruit::Banana(Color{rgb: (false,true,false)});
  let 🍎 = Fruit::Apple(false, true);
}
```

The type `Fruit` has $(2\cdot 2 \cdot 2) + (2\cdot 2) = 32$ possible states.

---

## Enumerations - Discriminant

You can control the discriminant like:

```rust
#[repr(u32)]
enum Bar {
    A, // 0
    B = 10000,
    C, // 10001
}

fn main() {
    println!("A: {}", Bar::A as u32);
    println!("B: {}", Bar::B as u32);
    println!("C: {}", Bar::C as u32);
}
```

:::notes

- See the explicitness of the cast!

:::
