<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

---

# Implementation Blocks `impl`

---

## Implementing Member Functions

To associate functions to `structs` and `enums`, we use `impl` blocks

```rust
fn main() {
  let x = "Hello";
  x.len();
}
```

- Syntax `x.len()` similar to field access in `struct`s.

---

## The `impl` Block (2)

:::::: {.columns}

::: {.column width="40%"}

```rust {line-numbers="6-10,14"}
struct Banana
{
  size: f64;
}

impl Banana {
  fn get_volume() -> f64 {
    return size * size * 1.5;
  }
}

fn main() {
  let b = Banana{size: 4};
  let v = b.get_volume();
}
```

:::

:::{.column style="width:50%; align-content:center;"}

- Functions can be defined on our types using `impl` blocks.

- Implementation blocks possible on any type, not just `struct`s (with
  exceptions).

:::

::::::

::: notes

- Here we define the get_volume method
- Note how the impl block is separate from the type definition.
- In fact we can have multiple impl blocks for the same type, as long as
  function definitions do not overlap (not useful right now, but it will be once
  we get more into generics)

:::

---

## The `self` and `Self`

- `Self` type: A shorthand for the type of current implementation.
- `self` parameter: Defines how the method can be used.

```rust {line-numbers="all|4-6|8-10|12-14"}
struct Banana { size: f64; }

impl Banana {
  fn new(i: f64) -> Self {
    return Self(10);
  }

  fn consume(self) -> Self {
    return Self::new(self.size + 5)
  }

  fn borrow(&self) -> &f64 { // Take read reference of `Banana` instance.
    return &self.size;
  }

  fn borrow_mut(&mut self) -> &mut f64 { // Take write reference of `Banana` instance.
    return &mut self.size;
  }
}
```

---

## The `self` Parameter

The `self` parameter is called the **_receiver_**.

- `self` is always first argument and its always the type on which `impl` is
  defined (type not needed).
- Prepend `&` or `&mut ` to `self` to indicate that we take a value by
  reference.
- Absence of a `self` parameter means its an **_associated function_** on that
  type.

```rust
fn main () {
  let mut f = Banana::new();
  println!("{}", f.borrow());

  *f.borrow_mut() = 10;

  let g = f.consume();
  println!("{}", g.borrow());
}
```
