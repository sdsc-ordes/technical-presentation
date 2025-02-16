# The `Sized` Trait

---

## Trait [`std::marker::Sized`](https://doc.rust-lang.org/std/marker/trait.Sized.html)

Rust supports **Dynamically Sized Types** (DSTs): types **without a statically
known size or alignment**. On the surface,
[this is a bit nonsensical](https://doc.rust-lang.org/nomicon/exotic-sizes.html):
`rustc` always needs to know the size and alignment to compile code!

::: incremental

- `Sized` is a **marker** trait for types with know-size at compile time.

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

- DSTs can be **only** be used (local variable) **through a reference**: `&[T]`,
  `&str`, `&dyn MyTrait`.

:::

:::notes

Pointers, which essentially references (`&str`) are, always have a known size at
compile, time that is why they can be stored in local variables (which as you
know live on the stack).

:::

---

## Quiz - Instantiate a Trait?

```rust
struct A{}
trait MyTrait { fn show(&self); }

fn main() {
  let a: MyTrait = A{};
}
```

**Question:** Does that compile?

::: {.fragment }

**Answer: No! - It's invalid code.**

- You can't make a local variable without knowing its size (to allocate enough
  bytes on the stack), and
- you can't pass the value of an unsized type into a function as an argument or
- return it from a function

:::

---

## Generics and `Sized` : How?

::: incremental

- Given a concret type you can always say if its `Sized` or `!Sized` (DST).

- Whats with generics?

```rust {.fragment}
fn generic_fn<T: Eq>(x: T) -> T { /*..*/ }
```

- If `T` is `!Sized`, then the definition of `generic_fn` is incorrect! (why?)

- If `T` is `Sized`, all is OK!.

:::

::: notes

It is incorrect because, you take a `T` which needs to be constructed on the
stack ergo have a fixed-size at compile time! You also return a `T` which needs
to have a fixed-size at compile time (also on the stack frame).

:::

---

## Generics and `Sized`

- All generic type parameters are **implicitly** `Sized` by default (everywhere
  `structs`, `fn`s etc.):

  For example:

  ```rust {.fragment}
  fn generic_fn<T: Eq + Sized>(x: T) -> T { // Sized is obsolete here.
    //...
  }
  ```

---

## Generics and `?Sized`

Sometimes we want to opt-out of `Sized`: use `?Sized`:

```rust
fn generic_fn<T: Eq + ?Sized>(x: &T) -> u32 { ... }
```

::: incremental

- In English: `?Sized` means `T` also allows for dyn. sized types  e.g.
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
-  `T := str`
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
  generic_fn("hello world")`
}
```

::: {.fragment}

**Answer:** ❌ No - `generic_fn` is invalid:

::: incremental

-  `T` can be `dyn Eq` which is not `Sized`  compile error.
-  Remember: function parameter go onto the stack!
-  Remember:

:::

:::

::: notes

The compile error has nothing to do with the call in 5!

:::
