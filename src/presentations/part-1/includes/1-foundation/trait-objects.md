<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Trait Objects & Dynamic Dispatch

---

## Trait... Object?

- We learned about [traits](#traits-and-generics).
- We learned about generics and `monomorphization`.

There's more to this story though...

**Question**: What was monomorphization again?

---

## Static Dispatch: Monomorphization (recap)

The [`Add`](#the-trait-keyword/1) trait.

::::::{.columns}

:::{.column width="50%"}

```rust
impl Add for i32 {/* ... */}
impl Add for f32 {/* ... */}

fn add_values<T: Add>(l: &T, r: &T) -> T
{
  l.add(r)
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

:::{.column width="50%"}

```rust {line-numbers="all|1-8|10-12" style="font-size:14pt"}
use std::io::Write;
use std::path::PathBuf;

struct FileLogger { log_file: PathBuf }
impl Write for FileLogger { /* ... */}

struct StdOutLogger;
impl Write for StdOutLogger { /* ... */}

fn log<L: Write>(logger: &mut L, msg: &str) {
  write!(logger, "{}", msg);
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
18 | |         Some(log_file) => FileLogger { log_file },
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

```rust {line-numbers="2-3|5-7,9-10"}
fn main() {
  let circle = Circle{};
  let rect = Rectangle{};

  let mut shapes = Vec::new();
  shapes.push(circle);
  shapes.push(rect);

  shapes.iter()
        .for_each(|s| s.paint());
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

## Dynamically Sized Types (DST)

Rust supports **Dynamically Sized Types** (DSTs): types **without a statically
known size or alignment**.

On the surface,
[this is a bit nonsensical](https://doc.rust-lang.org/nomicon/exotic-sizes.html):
`rustc` always needs to know the size and alignment to compile code!

::: incremental

- [`Sized`](https://doc.rust-lang.org/std/marker/trait.Sized.html) is a
  **marker** trait for types with know-size at compile time.

- Types in Rust can be `Sized` or `!Sized` (unsized  DSTs).

:::

---

## Examples of `Sized` vs. `!Sized`

::: incremental

- Most types are `Sized`, and **automatically** marked as such

  - `i64`
  - `String`
  - `Vec<String>`
  - etc.

- Two major DSTs (`!Sized`) exposed by the language (**note the absence of a
  reference!**):

  - Trait Objects: `dyn MyTrait` (covered in the next section)
  - Slices: `[T]`, `str`, and others.

- DSTs can **only** be used (local variable) **through a reference**: `&[T]`,
  `&str`, `&dyn MyTrait` (references are `Sized`).

:::

:::notes

Pointers, which essentially references (`&str`) are, always have a known size at
compile, time that is why they can be stored in local variables (which as you
know live on the stack).

:::

---

## Trait Objects `dyn Trait`

::: incremental

- Opaque type that implements a set of traits.

  Type Description: `dyn MyTrait: !Sized`

- Like slices, trait objects **always live behind pointers** (`&dyn MyTrait`,
  `&mut dyn MyTrait`, `Box<dyn MyTrait>`, `...`).

- Concrete underlying types are erased from trait object.

:::

```rust{line-numbers="5|6-8" .fragment}
fn main() {
  let log_file: Option<PathBuf> = // ...

  // Create a trait object that implements `Write`
  let logger: &mut dyn Write = match log_file {
    Some(log_file) => &mut FileLogger { log_file },
    None => &mut StdOutLogger,
  };
}
```

---

## Quiz - Instantiate a Trait?

```rust {contenteditable="true"}
trait MyTrait { fn show(&self) {}; }
struct A{}
impl MyTrait for A {}

fn main() {
  let a: MyTrait = A{};
  let b: dyn MyTrait = A{};
}
```

**Question:** Does that compile?

::: {.fragment }

**Answer: No! - It's invalid code.**

::: incremental

- You can't declare a local variable `a`, `MyTrait` **is not a type**.
- You can't declare `b` as `dyn MyTrait`, because for the type system its
  `!Sized`  **can't compute size of memory of `b` on the stack**.
- _Also: You can't pass the value of an unsized type into a function as an
  argument or return it from a function._

:::

:::

---

## Quiz - Correct Code

So the correct code is this:

```rust {contenteditable="true"}
trait MyTrait { fn show(&self) {}; }
struct A{}
struct B{}
impl MyTrait for A {}
impl MyTrait for B {}

fn main() {
  let a: &dyn MyTrait = &A{};
  let b: &dyn MyTrait = &B{};
}
```

---

## Generics and `Sized` : How?

::: incremental

- Given a concrete type you can always say if its `Sized` or `!Sized` (DST).

- Generics?

  All **generic type parameters** are **implicitly** `Sized` by default
  (everywhere `structs`, `fn`s etc.):

  For example:

  ```rust {.fragment}
  fn generic_fn<T: Eq + Sized>(x: T) -> u32
  // -------------------^^^^^ : Sized is obsolete here.
  { /* ... */ }
  ```

  :::{.fragment}

  ```rust
  fn generic_fn(x: T) -> u32
  where
    T: Eq + Sized
    // -----^^^^^ : Sized is obsolete here.

  ```

  :::

:::

---

## Generics and `Sized`

This default is problematic in the following:

```rust
fn generic_fn<T: Eq>(x: &T) -> T { /*..*/ }
```

:::incremental

- If `T` is `Sized`, all is OK!.

- If `T` is `!Sized`, then the definition of `generic_fn` **is incorrect**!<br>

  [**But when does that happen?**]{.fragment}

  ::: incremental

  -  pass `let a: &dyn MyTrait = ...` as `generic_fn(a)`
  -  `T := dyn MyTrait` which is `!Sized` -> incorrect.

  :::

:::

---

## Generics and `?Sized`

Sometimes we want to opt-out of `Sized`: use `?Sized`:

```rust
fn generic_fn<T: Eq + ?Sized>(x: &T) -> u32 { ... }
```

::: incremental

- In English: `?Sized` means `T` also allows for dyn. sized types (DST)  e.g.
  `T := dyn Eq`.

- So a `x: &dyn Eq` is a reference to a **trait object** which implements
  [`Eq`](https://doc.rust-lang.org/std/cmp/trait.Eq.html).

:::

---

## Generics and `?Sized` - Quiz

Does that compile? Why?/Why not?

```rust
fn generic_fn<T: Eq + ?Sized>(x: &T) -> u32 { 42 }

fn main() {
  generic_fn("hello world")`
}
```

::: {.fragment}

**Answer:** `generic_fn` is instantiated with `&str`:

::: incremental

-  match `&T <-> &str`
-  `T := str` which is `!Sized`
-  `x: &str` which is `Sized`
-  ✅ Yes it compiles.

:::

:::

---

## Generics and `?Sized` - Quiz

Does that compile? Why?/Why not?

```rust {line-numbers=}
// removed the reference ------- v
fn generic_fn<T: Eq + ?Sized>(x: T) -> u32 { 42 }

fn main() {
  generic_fn("hello world");
}
```

::: {.fragment}

**Answer:** ❌ No - declaration `generic_fn` is invalid (**line 5** is not the
problem!):

::: incremental

- The declaration is invalid for the compiler because `T` can **potentially** be
  `dyn Eq`  this leads to `x: dyn Eq` which is `!Sized` and gives a compile
  error. It has nothing to do with the call of the function! The function
  declaration is already wrong. So be careful when doing this.
- [**Remember: function parameter go onto the stack!**]{.emph}

:::

:::

::: notes

The compile error has nothing to do with the call in 5!

:::

## Generics and `?Sized` - Quiz (Tip)

How to print the type `T`?

::::::::{.columns}

:::{.column width="42%"}

```rust
fn generic_fn<T: Eq>(x: T) -> u32 {
    42
}

fn main() {
    generic_fn("hello world");
}
```

:::

:::{.column width="58%" .fragment}

```rust {line-numbers="5-6"}
fn generic_fn(x: T) -> u32
where
  T: Eq + std::fmt::Display
{
    println!("x: {} = '{x}'",
      std::any::type_name::<T>());

    42
}

fn main() {
    generic_fn("hello world");
}
```

```rust
x: &str = 'hello world'
```

:::

::::::

---

## Fixing Dynamic Logger

- Trait objects `&dyn Trait`, `Box<dyn Trait>`, ... implement `Trait`!

```rust {line-numbers="all|9-13|1-4"}
// L no longer must be `Sized`, so to accept also trait objects.
fn log<L: Write + ?Sized>(entry: &str, logger: &mut L) {
    write!(logger, "{}", entry);
}

fn main() {
    let log_file: Option<PathBuf> = //...

    // Create a trait object that implements `Write`
    let logger: &mut dyn Write = match log_file {
      Some(log_file) => &mut FileLogger{log_file},
      None => &mut StdOutLogger,
    };

    log(&mut logger, "Hello World!");
}
```

And all is well!
[Live Stack Dyn. Dispatch](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=2f631621994c6a685ecad19c59704647).

---

## Dynamic Dispatch on the [Stack<small>(adv.)</small>](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=2f631621994c6a685ecad19c59704647)

::::::{.columns}

:::{.column width="50%"}

```rust {style="font-size:14pt;"}
/// Same code as last slide
fn main() {
  let log_file: Option<PathBuf> = //...

  // Create a trait object that implements `Write`
  let logger: &mut dyn Write = match log_file {
    Some(log_file) => &mut FileLogger{log_file},
    None => &mut StdOutLogger,
  };

  log(&mut logger, "Hello World!");
}
```

:::

:::{.column width="50%" .p-no-margin}

![](${meta:include-base-dir}/assets/images/A1-trait-object-layout.svgbob){.svgbob}

:::

::::::

::: incremental

- 💸 **Cost**: same as before.
- 💰 **Benefit**: same as before.
- 💻 **Memory**: `logger` is a **wide-pointer** which lives **only** on the
  **stack**  🚀.

:::

::: notes

- `&mut dyn Write` is called a **wide-pointer** because you have a pointer to
  data and a pointer to the vtable with the functions. Do not think about the
  pointer indirection, and less performant -> this is 100% premature
  optimization!

- Assigning `&FileLogger` to `&dyn Writer` is possible due to **unsized**
  coercion which is a compiler intrinsic feature.

:::

---

## Dynamic Dispatch on the [Heap](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=cf8fdfe6a4b6672a938db4834bc83ace).

::::::{.columns}

:::{.column width="55%"}

```rust {style="font-size:14pt;"}
/// Same code as last slide
fn main() {
  let log_file: Option<PathBuf> = //...

  // Create a trait object on heap that impl. `Write`
  let logger: Box<dyn Write> = match log_file {
    Some(log_file) => Box::new(FileLogger{log_file}),
    None => Box::new(StdOutLogger),
  };

  log("Hello, world!🦀", &mut logger);
}
```

:::

:::{.column width="45%" .p-no-margin}

![](${meta:include-base-dir}/assets/images/A1-trait-object-layout-heap.svgbob){.svgbob}

:::

::::::

::: incremental

- 💸 **Cost**: pointer indirection via vtable (**dynamic dispatch**)  less
  performant.
- 💰 **Benefit**: no monomorphization (no generics)  smaller binary & shorter
  compile time!
- 💻 **Memory**: `logger` is a smart-pointer where the data and vtable is on the
  **heap** (dyn. mem. allocation  🐌, **this is fine 99% time**)

:::

::: notes

A boxed dyn. Trait is totally fine and most of the time easier to deal with in
code. The dynamic memory allocation should not be your premature optimization
point! The pointer indirection is the same as in the stack-based dynamic
dispatch, do not think about this, it is 80% premature optimization. Except if
you are in a very hot loop where you do dynamic dispatch always, then think
about it, in all other cases dont!.

:::

---

## Forcing Dynamic Dispatch

If one wants to enforce API users to use dynamic dispatch, use `&mut dyn Write`
on `log`:

```rust {line-numbers="1"}
fn log(entry: &str, logger: &mut dyn Write) {
    write!(logger, "{}", entry);
}

fn main() {
    let log_file: Option<PathBuf> = // ...

    // Create a trait object that implements `Write`
    let logger: &mut dyn Write = match log_file {
        Some(log_file) => &mut FileLogger { log_file },
        None => &mut StdOutLogger,
    };

    log("Hello, world!🦀", &mut logger);
}
```

---

## Heterogeneous Collection: Heap

::::::{.columns}

:::{.column width="45%"}

```rust {.no-compile}
fn main() {
  let mut shapes = Vec::new();


  let circle = Circle;
  shapes.push(circle);

  let rect = Rectangle;
  shapes.push(rect);

  shapes.iter()
        .for_each(|s| s.paint());
}
```

:::

:::{.column width="55%" .fragment}

```rust{line-numbers="2,3,5,8" .does-compile}
fn main() {
  let mut shapes: Vec<Box<dyn Render>>
    = Vec::new();

  let circle = Box::new(Circle);
  shapes.push(circle);

  let rect = Box::new(Rectangle);
  shapes.push(rect);

  shapes.iter()
        .for_each(|s| s.paint());
}
```

:::

::::::

[All set!]{.fragment}

---

## Heterogeneous Collection: Stack 🍭

```rust
fn main() {
    let shapes: [&dyn Render; 2] = [&Circle {}, &Rectangle {}];
    shapes.iter().for_each(|shape| shape.paint());
}
```

[All set!]{.fragment}

---

## Trait Object Limitations

- Pointer indirection cost.
- Harder to debug.
- Type erasure (you need a trait).

- Not **all traits** work:

  [**Traits need to be _dyn-compatible_ **]{.emph}

---

## Summary - Static vs Dynamic Dispatch

<table>
<colgroup>
<col >
<col >
<col style="width: 40%">
<col >
</colgroup>
<thead>
<tr class="header">
<th></th>
<th>Technique</th>
<th>Example</th>
<th>With:</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><emph>Static</emph></td>
<td><emph>Compile Time</emph><br>(monomo.)</td>
<td><code>fn add&lt;T: Addable&gt;(x: T)</code></td>
<td>Generics and Trait Bounds</td>
</tr>
<tr class="even">
<td>Dynamic</td>
<td>Runtime (vtable)</td>
<td><code>fn add(x: &amp;dyn Addable)</code></td>
<td><code>Box&lt;dyn Trait&gt;</code>or<br><code>&amp;dyn Trait</code></td>
</tr>
</tbody>
</table>

## Summary - Trait Object `dyn Trait`

- Trait objects allow for dynamic dispatch and heterogeneous containers.
- Trait objects introduce pointer indirection.
- Traits need to be _dyn-compatible_ to make trait objects out of them.

## Static Dispatch or Dynamic Dispatch?

When to use what is rarely a clear-cut, but broadly

- **In libraries**: use static dispatch for the user to decide if they want to
  pass

  - a `let d: &dyn MyTrait` for a signature
    `fn lib_func(s: impl MyTrait + ?Sized)`.
  - or a concrete type `A` which implements `Trait`.

- **For binaries**, you are writing final code - use dynamic dispatch (no
  generics)  cleaner code, faster compile with little performance cost.

---

## _Dyn-Compatible_ Trait

A trait `T` is **dyn-compatible** (formerly _object safe_) when it fulfills:

- It does not require `Self: Sized`.
- If `trait T: Y`, then`Y` must be _dyn-compatible_.
- No associated constants allowed.
- No associated types with generic allowed.
- All associated functions must either be dispatchable from a trait object, or
  explicitly non-dispatchable:
  - e.g. function must have a receiver with a reference to `Self`

Details in
[The Rust Reference](https://doc.rust-lang.org/beta/reference/items/traits.html#dyn-compatibility).
Read them!

These seem to be compiler and combinatoric limitations.

---

## Non _Dyn-Compatible_ Trait (😱)

```rust {line-numbers="1-4|6|8-13|16-19"}
trait Fruit {
  fn clone(&self) -> Self;
  fn show(&self) -> String;
}

struct Banana { color: i32 }

impl Fruit for Banana {
  fn clone(&self) -> Self { Banana {} }

  fn show(&self) -> String {
      return format!("banana: color {}", self.color).to_string();
  }
}

fn main() {
    let obj: Box<dyn Fruit> = Box::new(Banana { color: 10 });
    println!("type: {}", obj.show())
}
```

---

## Non _Dyn-Compatible_ Trait (💩)

```text
error[E0038]: the trait `Fruit` cannot be made into an object

18 |     println!("type: {}", obj.show())
   |                          ^^^^^^^^^^ `Fruit` cannot be made into an object

note: for a trait to be "dyn-compatible" it needs to
      allow building a vtable to allow the call to be
      resolvable dynamically; for more information
      visit <https://doc.rust-lang.org/beta/reference/items/traits.html#dyn-compatibility>

1  | trait Fruit {
   |       ----- this trait cannot be made into an object...
2  |   fn clone(&self) -> Self;
   |                       ^^^^ ...because method `clone` references
                                the `Self` type in its return type
```

---

## Exercise Time (11)

Approx. Time: 20-40 min.

Do the following exercises:

- `config-reader`

**Build/Run/Test:**

```bash
just build config-reader
just run config-reader
just test config-reader
just watch [build|run|test|watch] config-reader
```
