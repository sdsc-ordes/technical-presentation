# Design patterns in Rust

---

## Why Design Patterns?

- Common problems call for common, tried an tested solutions.
- Make crate architecture more clear.
- Speed up development.
- Rust does some patterns ever-so-slightly differently.

_Learning common Rust patterns makes understanding new code easier_

---

## What Do We Cover?

```rust
const PATTERNS: &[Pattern] = &[
    Pattern::new("Newtype"),
    Pattern::new("RAII with guards"),
    Pattern::new("Typestate"),
    Pattern::new("Strategy"),
];
fn main() {
    for pattern in PATTERNS {
        pattern.introduce();
        pattern.show_example();
        pattern.when_to_use();
    }
}
```

---

## 1. The Newtype Pattern

A small but useful pattern.

---

## Newtype: Introduction

#### Wrap an external type in a new local type

```rust
pub struct Imei(String)
```

That's it!

---

## Newtype: Example

```rust {style="font-size:14pt;"}
pub enum ValidateImeiError { /* - snip - */}
pub struct Imei(String);

impl Imei {
  fn validate(imei: &str) -> Result<(), ValidateImeiError> {
      todo!();
  }
}

impl TryFrom<String> for Imei {
  type Error = ValidateImeiError;

  fn try_from(imei: String) -> Result<Self, Self::Error> {
    Self::validate(&imei)?;
    Ok(Self(imei))
  }
}

fn register_phone(imei: Imei, label: String) {
  // We can certain `imei` is valid here
}
```

---

## Newtype: When to Use?

New types solve some problems:

- Orphan rule: no `impl`s for external `trait`s on external types.
- Allow for semantic typing (`url` example [from before](#url-example))
- Enforce input validation.

---

## 2. The RAII Guard Pattern

More robust resource handling.

---

## RAII Guards: Introduction

- RAII: **R**esource **A**cquisition **I**s **I**nitialization.
- Link acquiring/releasing a resource to the lifetime of a variable.
- A constructor initializes the resource, the destructor frees it.
- Access resource through the guard.

_Do you know of an example?_

---

## RAII Guards: Example

::::::{.columns}

:::{.column width="50%"}

```rust {style="font-size:14pt;"}
pub struct Transaction<'c> {
  connection: &'c mut Connection,
  did_commit: bool,
  id: usize,
}

impl<'c> Transaction<'c> {
  pub fn begin(connection: &'c mut Connection)
    -> Self {
    let id = connection.start_transaction();
    Self { did_commit: false, id, connection }
  }

  pub fn query(&self sql: &str) {
    /* - snip - */
  }

  pub fn commit(self) {
      self.did_commit = true;
  }
}
```

:::

:::{.column width="50%" .fragment}

```rust {style="font-size:14pt;"}
impl Drop for Transaction<'_> {
  fn drop(&mut self) {
    if self.did_commit {
      self
        .connection
        .commit_transaction(self.id);

    } else {
      self
        .connection
        .rollback_transaction(self.id);
    }
  }
}
```

:::

::::::

---

## RAII Guards: When to Use?

- Ensure a resource is freed at some point.
- Ensure **invariants** hold while guard lives.

---

## 3. The Typestate Pattern

Encode state in the type.

---

## Typestate: Introduction

- Define **uninitializable types** for each state of your object `O`.

```rust
pub enum Ready {} // No variants, cannot be initialized
```

::: incremental

- Implement methods on `O` **only for relevant** states.

- Methods on `O` that **update state** take **owned `self`** and return instance
  with new state.

- Make your type generic over its state using `std::marker::PhantomData`. _👻
  `PhantomData<T>` makes types act like they own a `T`, and takes no space_.

:::

---

## Typestate: Example

::::::{.columns}

:::{.column width="50%"}

```rust {style="font-size:14pt;"}
pub enum Idle {} // Nothing to do.
pub enum ItemSelected {} // Item was selected.
pub enum MoneyInserted {} // Money was inserted.

pub struct CandyMachine<S> {
  state: PhantomData<S>,
}
impl<S> CandyMachine<S> {
  /// Just update the state
  fn into_state<NS>(self) -> CandyMachine<NS> {
    CandyMachine { state: PhantomData, }
  }
}
impl CandyMachine<Idle> {
  pub fn new() -> Self {
    Self { state: PhantomData }
  }
}
```

:::

:::{.column width="50%"}

```rust {style="font-size:14pt;"}
impl CandyMachine<Idle> {
  fn select_item(self, item: usize)
    -> CandyMachine<ItemSelected> {
    println!("Selected item {item}");
    self.into_state()
  }
}
impl CandyMachine<ItemSelected> {
  fn insert_money(self)
    -> CandyMachine<MoneyInserted> {
    println!("Money inserted!");
    self.into_state()
  }
}
impl CandyMachine<MoneyInserted> {
  fn make_beverage(self)
    -> CandyMachine<Idle> {
    println!("There you go!");
    self.into_state()
  }
}
```

:::

::::::

---

## Typestate: When to Use?

- If your problem is like a state machine.
- Ensure _at compile time_ that no invalid operation is done.

:::incremental

_References: Look at
[`serde::Serialize`](https://docs.rs/serde/latest/serde/ser/trait.Serializer.html)
and `serialize_struct` which starts the typestate pattern._

:::

---

## 4. The Strategy Pattern

Select behavior dynamically.

---

## Strategy: Introduction

- Turn set of behaviors into objects.
- Make them interchangeble inside context.
- Execute strategy depending on input.

_Trait objects work well here!_

---

## Strategy: Example

::::::{.columns}

:::{.column width="50%"}

```rust
trait PaymentStrategy {
  fn pay(&self);
}

struct CashPayment;
impl PaymentStrategy for CashPayment {
  fn pay(&self) {
    println!("🪙💸");
  }
}

struct CardPayment;
impl PaymentStrategy for CardPayment {
  fn pay(&self) {
    println!("💳");
  }
}
```

:::

:::{.column width="50%" .fragment}

```rust
fn main() {
  let method = todo!("Read input");

  let strategy: &dyn PaymentStrategy
    = match method {
    "card" => &CardPayment,
    "cash" => &CashPayment,
    _ => panic!("Oh no!"),
  };

  strategy.pay();
}
```

:::

::::::

---

## Strategy: When to Use?

- Switch algorithms based on some **run-time parameter** (input, config, ...).

---

## Anti-Patterns

What _not_ to do

---

## Deref Polymorphism

A common pitfall you'll want to avoid.

---

## Deref Polymorphism: Example

::::::{.columns}

:::{.column width="50%"}

```rust
use std::ops::Deref;

struct Animal {
    name: String,
}

impl Animal {
    fn walk(&self) {
        println!("Tippy tap")
    }
    fn eat(&self) {
        println!("Om nom")
    }
    fn say_name(&self) {
        // Animals generally can't speak
        println!("...")
    }
}
```

:::

:::{.column width="60%"}

```rust
struct Dog {
    animal: Animal
}
impl Dog {
    fn eat(&self) {
        println!("Munch munch");
    }
    fn bark(&self) {
        println!("Woof woof!");
    }
}
impl Deref for Dog {
    type Target = Animal;

    fn deref(&self) -> &Self::Target {
        &self.animal
    }
}
fn main (){
    let dog: Dog = todo!("Instantiate Dog");
    dog.bark();
    dog.walk();
    dog.eat();
    dog.say_name();
}
```

:::

::::::

---

## The Output

```txt
Woof woof!
Tippy tap
Munch munch
...
```

_Even overloading works!_

---

## Why Is It Bad?

:::incremental

- No _real_ inheritance: `Dog` is no subtype of `Animal`.
- Traits on `Animal` are not implemented on `Dog` automatically.
- `Deref` and `DerefMut` intended for 'pointer-to-`T`' to `T` conversions.
- Deref coercion by `.` 'converts' `self` from `Dog` to `Animal`
- Rust favours **explicit conversions** for easier reasoning about code.

:::

::: {.fragment}

_Confusion: for OOP programmers it's incomplete, for Rust programmers it is
unidiomatic_.

### ⚠️ Don't do OOP in Rust!

:::

---

## What to Do Instead?

- _Move away from OOP constructs_
- Compose your `struct`s.
- Use the
  [facade pattern](https://refactoring.guru/design-patterns/facade/rust/example)
  and methods.
- Use `AsRef` and `AsMut` for explicit conversion.

:::notes

- Facade pattern: Make an object which intracts with different types to
  accomplish some logic. E.g. A filtering type `GraphFilter` which provides a
  filtering interface which acts on a graph type `Graph` and a filter lambda
  `FilterFunc`. It might provide different methods for filtering.

:::

---

## More Anti-Patterns

- Use global state: Singleton patterns and global variables.
- Forcing dynamic dispatch in libraries.
- `clone()` _to satisfy the borrow checker_.
- `unwrap()` or `expect()` _to handle conditions that are recoverable or not
  impossible_
