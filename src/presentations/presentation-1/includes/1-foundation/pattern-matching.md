<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Pattern Matching

---

## Extracting Data from `enum`

- We must ensure we interpret `enum` data correctly.
- Use **pattern matching** to do so.

---

## Pattern Matching

Using the `if let [pattern] = [value]` statement:

```rust
fn accept_banana(fruit: Fruit) {
  if let Fruit::Banana(a, _) = fruit {
    println!("Got a banana, {} {}", a, _);
  } else {
    println!("not handled")
  }
}
```

- `a` and `b` are local variables within `if`-body.
- The underscore (`_`) can be used to accept any value.
- **Note:** Abbreviation for the above:
  [`let else`](https://doc.rust-lang.org/rust-by-example/flow_control/let_else.html).
  ```rust
  let b = Fruit::Banana(3, _) else {...}
  ```
- There is also
  [`while let`](https://doc.rust-lang.org/rust-by-example/flow_control/while_let.html).

---

## Match Statement

Pattern matching is very powerful if combined with the `match` statement:

::::::{.columns .fragment}

:::{.column width="50%"}

```rust
fn accept_fruit(fruit: Fruit) {
  match fruit {
    Fruit::Banana(3) => {
      println!("Banana is 3 months old.");
    },
    Fruit::Banana(v) => {
      println!("Banana: age {:?}.", v)
    }
    Fruit::Apple(true, _) => {
      println!("Ripe apple.");
    },
    _ => {
      println!("Wrong fruit...");
    },
  }
}
```

:::

:::{.column width="30%"}

```rust
enum Fruit {
  Banana(u8),
  Apple(bool, bool)
}
```

- Every part of the match is called an arm. First match from top to bottom wins!

- A **match is exhaustive**, meaning
  [**all possible values** must be handled](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=62dc4e2804b91dfc1a7f40f1826fb538)

- Use a catch-all `_` arm for all remaining cases. **Use deliberately!**

:::

::::::

---

## Match Expression

The match statement can even be used as an expression:

```rust
fn get_age(fruit: Fruit) {
  let age = match fruit {
    Fruit::Banana(a) => a,
    Fruit::Apple(_) => 1, // _ matches the tuple.
  };

  println!("The age is: {}", age);
}
```

- All match arms **must return the same type**.
- No catch all (`_ =>`) arm -> all cases are handled.

---

## Complex Match Statements

```rust {contenteditable="true"}
fn main() {
    let input = 'x';
    match input {
        'q'                       => println!("Quitting"),
        'a' | 's' | 'w' | 'd'     => println!("Moving around"),
        '0'..='9'                 => println!("Number input"),
        key if key.is_lowercase() => println!("Lowercase: {key}"),
        _                         => println!("Something else"),
    }
}
```

- `|` means `or`.
- `1..=9` is an inclusive range (later!).

**Quiz:** The `if key.is_lowercase()` after `=>` would never print
`Something else`.
