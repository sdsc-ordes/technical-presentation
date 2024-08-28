# Common Traits from `std`

---

## Operator Overloading: `std::ops::Add<T>` et al.

- Shared behavior

```rust {line-numbers="13-14"}
use std::ops::Add;
pub struct BigNumber(u64);

impl Add for BigNumber {
  type Output = Self;
  fn add(self, rhs: Self) -> Self::Output {
      BigNumber(self.0 + rhs.0)
  }
}
fn main() {
  // Now we can use `+` to add `BigNumber`s!
  let res: BigNumber = BigNumber(1) + (BigNumber(2));
}
```

- Others: `Mul`, `Div`, `Sub`, ..

---

## Markers: `std::marker::Sized`

- Marker traits

```rust
/// Types with a constant size known at compile time.
/// [...]
pub trait Sized { }
```

::: incremental

- _`u32` is `Sized`_
- _Slice `[T]`, `str` is **not** `Sized`_
- _Slice reference `&[T]`, `&str` is `Sized`_

:::

Others:

- `Sync`: Types of which references can be shared between threads.
- `Send`: Types that can be transferred across thread boundaries.

---

## Default Values: `std::default::Default`

```rust{line-numbers="all|5|10-17"}
pub trait Default: Sized {
    fn default() -> Self;
}

##[derive(Default)] // Derive the trait
struct MyCounter {
  count: u32,
}

// Or, implement it (if you really need to)
impl Default for MyCounter {
  fn default() -> Self {
    MyCounter { count: 1 }
  }
}
```

---

## Duplication: `std::clone::Clone` & `std::marker::Copy`

```rust {line-numbers="all|9|4-6"}
pub trait Clone: Sized {
    fn clone(&self) -> Self;

    fn clone_from(&mut self, source: &Self) {
      *self = source.clone()
    }
}

pub trait Copy: Clone { } // That's it!
```

:::incremental

- Both `Copy` and `Clone` can be `#[derive]`d.
- `Copy` is a marker trait.
- `trait A: B` == _"Implementor of `A` must also implement `B`"_
- `clone_from` has default implementation, can be overridden.

:::

---

## Conversion: `Into<T>` & `From<T>`

```rust {line-numbers="all|1-3|5-7|9-15"}
pub trait From<T>: Sized {
    fn from(value: T) -> Self;
}

pub trait Into<T>: Sized {
    fn into(self) -> T;
}

impl <T, U> Into<U> for T
  where U: From<T>
{
    fn into(self) -> U {
      U::from(self)
    }
}
```

::: incremental

- Blanket implementation.
- _Prefer `From` over `Into` if orphan rule allows to_.

:::

---

## Reference Conversion: `AsRef<T>` & `AsMut<T>`

```rust
pub trait AsRef<T: ?Sized>
{
    fn as_ref(&self) -> &T;
}

pub trait AsMut<T: ?Sized>
{
    fn as_mut(&mut self) -> &mut T;
}
```

- Provide flexibility to API users.
- `T` need not be `Sized`, e.g. slices `[T]` can implement `AsRef<T>`,
  `AsMut<T>`

---

## Reference Conversion: `AsRef<T>` & `AsMut<T>` (2)

```rust {line-numbers="1-2|9-10|12-13"}
fn move_into_and_print<T: AsRef<[u8]>>(slice: T) {
  let bytes: &[u8] = slice.as_ref();
  for byte in bytes {
    print!("{:02X}", byte);
  }
}

fn main() {
  let owned_bytes: Vec<u8> = vec![0xDE, 0xAD, 0xBE, 0xEF];
  move_into_and_print(owned_bytes);

  let byte_slice: [u8; 4] = [0xFE, 0xED, 0xC0, 0xDE];
  move_into_and_print(byte_slice);
}
```

_Have user of `move_into_and_print` choose between stack local `[u8; N]` and
heap-allocated `Vec<u8>`_

---

## Destruction: `std::ops::Drop`

```rust
pub trait Drop {
    fn drop(&mut self);
}
```

- Called when owner goes out of scope.

---

## Destruction:`std::ops::Drop`

::::::{.columns}

:::{.column width="55%"}

```rust {line-numbers="1-2|4-8|9-13|17"}
struct Inner;
struct Outer { inner: Inner }

impl Drop for Inner {
  fn drop(&mut self) {
    println!("Dropped inner");
  }
}
impl Drop for Outer {
  fn drop(&mut self) {
    println!("Dropped outer");
  }
}

fn main() {
  // Explicit drop
  std::mem::drop(Outer { inner: Inner });
}
```

:::

:::{.column width="45%"}

**Output**:

```text
Dropped outer
Dropped inner
```

- Destructor runs _before_ members are removed from stack.
- Signature `&mut` prevents explicitly dropping `self` or its fields in
  destructor.
- Compiler inserts `std::mem::drop` call at end of scope

```rust
// Implementation of `std::mem::drop`
fn drop<T>(_x: T) {}
```

**Question:** Why does `std::mem::drop` work?

:::

::::::

::: notes

- You can only borrow once a `&mut`.
- Drop works, because it takes ownership by `T`, which means the borrowing rules
  ensure drop can only be called once. Its a sink function.
- TODO: Whats the rules how drop gets sequenced, same as C++ (AFAIK)

:::

---

## More Std-Traits

There is more:

- [Comparision](https://google.github.io/comprehensive-rust/std-traits/comparisons.html)
  `PartialEq` and `Eq` etc.
- [`Read` and `BufRead`](https://google.github.io/comprehensive-rust/std-traits/read-and-write.html)
  for abstraction over `u8` sources.
- [`Display`](https://doc.rust-lang.org/std/fmt/trait.Display.html) and
  [`Debug`](https://doc.rust-lang.org/std/fmt/trait.Debug.html) to format types.
- [Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html) to provide
  an iterator for your type.

---

## Std-Traits and the Orphan Rule

When you **provide a type**, **always** implement the basic traits from the
standard if they are appropriate, e.g.

::: incremental

- `Default` : Initialize the type with default values.
- `Debug` : Format trait for the debug format specifier `{:?}`
- `Display` : Format trait for the empty format specifier `{}`.
- `Clone`: Cloning the type.
- `Copy`: _Marker_ trait: The type can be bitwise copied.

:::

Other traits for later:

- `Send` : _Auto_ trait: A value `T` can safely be send across thread boundary.
- `Sync` : _Auto_ trait: A value `T` can safely be shared between threads.
- `Sized` : _Marker_ trait to denote that type `T` is known at compile time

::: notes

Marker traits do not need an implementation. Auto traits are auto implemented if
the types fulfills the conditions.

:::

---

## Exercise Time (9)

Approx. Time: 40-50 min.

Do the following exercises:

- `extension-traits`: a very good one!
- `local-storage-vec`: ⚠️ Hardcore exercise (spare for later)

**Build/Run/Test:**

```bash
just build <exercise> --bin 01
just run <exercise> --bin 01
just test <exercise> --bin 01
just watch [build|run|test|watch] <exercise> --bin 01
```
