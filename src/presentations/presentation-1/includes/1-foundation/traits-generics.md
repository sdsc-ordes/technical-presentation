<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Traits and Generics

---

## The Problem

```rust
fn add_u32(l: u32, r: u32) -> u32 { /*...*/}

fn add_i32(l: i32, r: i32) -> i32 { /*...*/ }

fn add_f32(l: f32, r: f32) -> f32 { /*...*/ }
```

No-one likes repeating themselves. [**We need generic code!**]{.fragment}

::: notes

Let's have a look at this Rust module. We'd like to provide functionality for
finding the maximum of two numbers, for several distinct types. One way to go
about it, is to define many similar functions that perform the operation. But
there's a number of problems with that:

- What happens if we want to compare other types?
- What happens if we want to compare separate types?

:::

---

## Generic code

An example

```rust
fn add<T>(a: T, b: T) -> T { /*...*/}
```

Or, in plain English:

::: incremental

- `<T>` : _"let `T` be a type"_.
- `a: T` : _"let `a` be of type `T`"_.
- `-> T` : _"let `T` be the return type of this function"_.

:::

::: {.fragment}

Some open points:

- What can we do with a `T`?
- What should the body be?

:::

---

## Bounds on Generic Code

We need to provide information to the compiler:

::: incremental

- Tell Rust what `T` can do.
- Tell Rust what `T` is accepted.
- Tell Rust how `T` implements functionality.

:::

---

## The `trait` Keyword

Describe what the type can do **but not specifying what data it has**:

```rust
trait Add {
    fn add(&self, other: &Self) -> Self;
}
```

This is similar in other languages:

::::::{.columns}

:::{.column .fragment}

Python (not as strict 🙁):

```python
from abc import ABC, abstractmethod
class Add(ABC):
    @abstractmethod
    def add(self, other: Self):
        pass
```

:::

:::{.column .fragment}

Go:

```go
type Add interface {
    func add(other Add)
}
```

:::

::::::

---

## Implementing a `trait`

Describe how the type does it

```rust {line-numbers="all|1|2-8"}
impl Add for u32 {
    fn add(&self, other: &Self) -> Self {
      *self + *other
    }
}
```

---

## Using a `trait`

```rust {line-numbers="all|1-2|5-6|7-9|10-12"}
// Import the trait
use my_mod::Add

fn main() {
  let a: u32 = 6;
  let b: u32 = 8;
  // Call trait method
  let result = a.add(&b);
  // Explicit call
  let result = Add::add(&a, &b);
}
```

- Trait needs to be in scope.
- Call just like a method.
- Or by using the explicit associated function syntax.

---

## Trait Bounds

```rust {line-numbers="all|1-3,5|5,7-11"}
fn add_values<T: Add>(this: &T, other: &T) -> T {
  this.add(other)
}

// Or, equivalently

fn add_values<T>(this: &T, other: &T) -> T
  where T: Add
{
  this.add(other)
}
```

::: incremental

- We've got a _useful_ generic function!

- English: _"For all types `T` that implement the `Add` `trait`, we define..."_

:::

---

## Limitations of `Add`

What happens if...

- We want to add two values of different types?
- Addition yields a different type?

---

## Making `Add` Generic

Generalize on the input type `O`:

```rust {line-numbers="all|1-3|5-9"}
trait Add<O> {
    fn add(&self, other: &O) -> Self;
}

impl Add<u16> for u32 {
    fn add(&self, other: &u16) -> Self {
      *self + (*other as u32)
    }
}
```

We can now add a `u16` to a `u32`.

---

## Defining Output of `Add`

::: incremental

- Addition of two given types always yields one **specific type of output**.
- Add _associated type_ for addition output.

:::

::::::{.columns}

:::{.column width="50%" .fragment}

**Declaration**

```rust {line-numbers="all|2-3"}
trait Add<O> {
  type Out;
  fn add(&self, other: &O) -> Self::Out;
}
```

:::

:::{.column width="50%" .fragment}

**Implementation**

```rust {line-numbers="all|1,9|4-6"}
impl Add<u16> for u32 {
  type Out = u64;

  fn add(&self, other: &u16) -> Self::Out) {
    *self as u64 + (*other as u64)
  }
}
```

:::

::::::

---

## Trait `std::ops::Add`

The way `std` does it

```rust {line-numbers="all|1|2-4"}
pub trait Add<Rhs = Self> {
    type Output;

    fn add(self, rhs: Rhs) -> Self::Output;
}
```

- Default type of `Self` for `Rhs`

---

## Implementation of `std::ops::Add`

```rust
use std::ops::Add;
pub struct BigNumber(u64);

impl Add for BigNumber {
  type Output = Self;

  fn add(self, rhs: Self) -> Self::Output {
      BigNumber(self.0 + rhs.0)
  }
}

fn main() {
  // Call `Add::add`
  let res = BigNumber(1).add(BigNumber(2));
}
```

**Quiz:** What's the type of `res`? [ `BigNumber(u64)`]{.fragment}

---

## Implementation `std::ops::Add` (2)

```rust
pub struct BigNumber(u64);

impl std::ops::Add<u32> for BigNumber {
  type Output = u128;

  fn add(self, rhs: u32) -> Self::Output {
      (self.0 as u128) + (rhs as u128)
  }
}

fn main() {
  let res = BigNumber(1) + 3u32;
}
```

**Quiz:** What's the type of `res`? [ `u128`]{.fragment}

---

## Type Parameter vs. Associated Type

:::::: {.columns}

::: {.column width="50%"}

#### Type Parameter

_if trait can be implemented for many combinations of types_

```rust
// We can add both a u32 value and
// a u32 reference to a u32
impl Add<u32> for u32 {/* */}
impl Add<&u32> for u32 {/* */}
```

:::

:::{.column width="50%"}

#### Associated Type

_to define a type for a single <br> implementation_

```rust
impl Add<u32> for u32 {
  // Addition of two u32's is always u32
  type MyBananaOut = u32;
}
```

:::

::::::

---

## Derive a Trait

```rust
#[derive(Clone, Debug)]
struct Dolly {
  num_legs: u32,
}

fn main() {
  let dolly = Dolly { num_legs: 4 };
  let second_dolly = dolly.clone();

  println!("Dolly: {:?}", second_dolly)
}
```

::: incremental

- Some traits are trivial to implement.
- Use `#[derive(...)]` to quickly implement a trait.
- For `Clone`: derived `impl` calls `clone` on each field.
- `Debug`: provide a debug implementation for string formatting.

:::

---

## Orphan Rule

_Coherence: There must be **at most one** implementation of a trait for any
given type_

::: {.fragment}

#### Rule

Trait can be implemented for a type **iff**:

::: incremental

- Either your crate (library) defines the trait
- or your crate (library) defines the type
- or both.

:::

::: incremental

<br>

- **You cannot implement a foreign trait for a foreign type.**

:::

:::

---

## Compiling Generic Functions

```rust
impl Add for i32 {/* ... */}
impl Add for f32 {/* ... */}

fn add_values<T: Add>(a: &T, b: &T) -> T
{
  a.add(b)
}

fn main() {
  let sum_one = add_values(&6, &8);
  let sum_two = add_values(&6.5, &7.5);
}
```

Code is **monomorphized**:

::: incremental

- Two versions of `add_values` end up in binary.
- Optimized separately and very fast to run (static dispatch).
- Slow to compile and larger binary.

:::

---

## Exercise Time (8)

Approx. Time: 40-50 min.

Do the following exercises:

- `generics`: all

**Build/Run/Test:**

```bash
just build <exercise> --bin 01
just run <exercise> --bin 01
just test <exercise> --bin 01
just watch [build|run|test|watch] <exercise> --bin 01
```
