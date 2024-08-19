<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Trait Objects & Dynamic Dispatch

---

## Trait... Object?

- We learned about [traits](#traits-and-generics).
- We learned about generics and `monomorphization`.

There's more to this story though...

**Question**: What was monomorphization again?

---

## Monomorphization (recap)

::::::{.columns}

:::{.column width="50%"}

```rust
impl MyAdd for i32 {/* ... */}
impl MyAdd for f32 {/* ... */}

fn add_values<T: MyAdd>(l: &T, r: &T) -> T
{
  l.my_add(r)
}

fn main() {
  let sum_one = add_values(&6, &8);
  let sum_two = add_values(&6.5, &7.5);
}
```

:::

:::{.column width="50%"}

Code is <em>monomorphized</em>:

::: incremental

- Two versions of `add_values` end up in binary.
- Optimized separately and very fast to run (static dispatch).
- Slow to compile and larger binary.

:::

:::

::::::

---

## Dynamic Dispatch

_What if don't know the concrete type implementing the trait at compile time?_

::::::{.columns}

:::{.column width="48%"}

```rust {line-numbers="all|1-8|10-12" style="font-size:14pt"}
use std::io::Write;
use std::path::PathBuf;

struct FileLogger { log_path: PathBuf }
impl Write for FileLogger { /* ... */}

struct StdOutLogger;
impl Write for StdOutLogger { /* ... */}

fn log<L: Write>(logger: &mut L, msg: &str) {
  write!(logger, "{}", msg);
}
```

:::

:::{.column width="50%"}

```rust {line-numbers="2|4-7|9" style="font-size:14pt"}
fn main() {
  let file: Option<PathBuf> = // args parsing...

  let mut logger = match file {
      Some(f) => FileLogger { log_file: f },
      None => StdOutLogger,
  };

  log(&mut logger, "Hello, world!🦀");
}
```

:::

::::::

---

## Error!

```txt
error[E0308]: `match` arms have incompatible types
  --> src/main.rs:19:17
   |
17 |       let mut logger = match log_file {
   |  ______________________-
18 | |         Some(log_path) => FileLogger { log_path },
   | |                           -----------------------
   | |                           this is found to be of
   | |                           type `FileLogger`
19 | |         None => StdOutLogger,
   | |                 ^^^^^^^^^^^^ expected struct `FileLogger`,
   | |                              found struct `StdOutLogger`
20 | |     };
   | |_____- `match` arms have incompatible types
```

_What's the type of `logger`?_

---

## Heterogeneous Collections

_What if we want to create collections of different types implementing the same
trait?_

::::::{.columns}

:::{.column width="45%"}

```rust {line-numbers="all|1-3|5-8,10-13"}
trait Render {
  fn paint(&self);
}

struct Circle;
impl Render for Circle {
  fn paint(&self) { /* ... */ }
}

struct Rectangle;
impl Render for Rectangle {
  fn paint(&self) { /* ... */ }
}
```

:::

:::{.column width="55%" .fragment}

```rust {line-numbers="2-3|5-9"}
fn main() {
  let circle = Circle{};
  let rect = Rectangle{};

  let mut shapes = Vec::new();
  shapes.push(circle);
  shapes.push(rect);
  shapes.iter()
        .for_each(|shape| shape.paint());
}
```

:::

::::::

---

## Error Again!

```txt
   Compiling playground v0.0.1 (/playground)
error[E0308]: mismatched types
  --> src/main.rs:20:17
   |
20 |     shapes.push(rect);
   |            ---- ^^^^ expected struct `Circle`,
   |                      found struct `Rectangle`
   |            |
   |            arguments to this method are incorrect
   |
note: associated function defined here
  --> /rustc/2c8cc343237b8f7d5a3c3703e3a87f2eb2c54a74/library/alloc/src/vec/mod.rs:1836:12

For more information about this error, try `rustc --explain E0308`.
error: could not compile `playground` due to previous error
```

_What is the type of `shapes`?_

---

## Trait Objects to the Rescue

::: incremental

- Opaque type that implements a set of traits.
- Type description: `dyn T: !Sized` where `T` is a `trait`.
- Like slices, Trait Objects always live behind pointers (`&dyn T`,
  `&mut dyn T`, `Box<dyn T>`, `...`).
- Concrete underlying types are erased from trait object.

:::

```rust{line-numbers="all|6-8" .fragment}
fn main() {
    let log_file: Option<PathBuf> = // ...

    // Create a trait object that implements `Write`
    let logger: &mut dyn Write = match log_file {
        Some(log_path) => &mut FileLogger { log_path },
        None => &mut StdOutLogger,
    };
}
```

---

::::::{.columns}

:::{.column width="50%"}

```rust {style="font-size:14pt;"}
/// Same code as last slide
fn main() {
  let log_file: Option<PathBuf> = //...

  // Create a trait object that implements `Write`
  let logger: &mut dyn Write = match log_file {
      Some(log_path) => &mut FileLogger { log_path },
      None => &mut StdOutLogger,
  };

  log("Hello, world!🦀", &mut logger);
}
```

::: incremental

- 💸 **Cost**: pointer indirection via vtable &rarr; less performant.
- 💰 **Benefit**: no monomorphization &rarr; smaller binary & shorter compile
  time!

:::

:::

:::{.column width="50%"}

![](${meta:include-base-dir}/assets/images/A1-trait-object-layout.svgbob){.svgbob}

:::

::::::

---

## Fixing Dynamic Logger

- Trait objects `&dyn T`, `Box<dyn T>`, ... implement `T`!

```rust {line-numbers="all|9-12|1-2"}
// We no longer require L be `Sized`, so to accept trait objects
fn log<L: Write + ?Sized>(entry: &str, logger: &mut L) {
    write!(logger, "{}", entry);
}

fn main() {
    let log_file: Option<PathBuf> = // ...

    // Create a trait object that implements `Write`
    let logger: &mut dyn Write = match log_file {
        Some(log_path) => &mut FileLogger { log_path },
        None => &mut StdOutLogger,
    };

    log("Hello, world!🦀", logger);
}
```

And all is well!

---

## Forcing Dynamic Dispatch

Sometimes you want to enforce API users (or colleagues) to use dynamic dispatch

```rust {line-numbers="all|1"}
fn log(entry: &str, logger: &mut dyn Write) {
    write!(logger, "{}", entry);
}

fn main() {
    let log_file: Option<PathBuf> = // ...

    // Create a trait object that implements `Write`
    let logger: &mut dyn Write = match log_file {
        Some(log_path) => &mut FileLogger { log_path },
        None => &mut StdOutLogger,
    };


    log("Hello, world!🦀", &mut logger);
}
```

---

## Fixing the Renderer

::::::{.columns}

:::{.column width="50%"}

```rust
fn main() {
    let mut shapes = Vec::new();

    let circle = Circle;
    shapes.push(circle);

    let rect = Rectangle;
    shapes.push(rect);

    shapes.iter().for_each(|shape| shape.paint());
}
```

:::

:::{.column width="50%" .fragment}

```rust{all|2,3,5}
fn main() {
    let mut shapes: Vec<Box<dyn Render>> = Vec::new();

    let circle = Box::new(Circle);
    shapes.push(circle);

    let rect = Box::new(Rectangle);
    shapes.push(rect);

    shapes.iter().for_each(|shape| shape.paint());
}
```

:::

::::::

All set!

---

## Trait Object Limitations

- Pointer indirection cost.
- Harder to debug.
- Type erasure (you need a trait).

- Not **all traits** work:

  [**Traits need to be _Object Safe_ **]{.emph}

---

## Object Safety

A trait is **object safe** when it fulfills:

- If `trait T: Y`, then`Y` must be object safe.
- Trait `T` must not be `Sized`: _Why?_
- No associated constants allowed.
- No associated types with generic allowed.
- All associated functions must either be dispatchable from a trait object, or
  explicitly non-dispatchable:
  - e.g. function must have a receiver with a reference to `Self`

Details in
[The Rust Reference](https://doc.rust-lang.org/reference/items/traits.html#object-safety).
Read them!

These seem to be compiler limitations.

---

## So far...

- Trait objects allow for dynamic dispatch and heterogeneous containers.
- Trait objects introduce pointer indirection.
- Traits need to be object safe to make trait objects out of them.
