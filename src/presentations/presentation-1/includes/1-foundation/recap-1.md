# Recap 1

---

## Recap 1 - References

- [Shared References](#shared-references) `&T`: read-only, many possible.
- [Exclusive Reference](#exclusive-references) `&mut T`: write, only a single at
  any point in the program.

---

## Recap - Borrow Checker

- [The borrow Checkers Scope](#borrow-checkers-scope).

---

## Quiz - Does that Compile?

::::::{.columns}

:::{.column width="55%"}

```rust {line-numbers=}
#[derive(Debug)]
enum Color {None, Blue}
struct Egg { color: Color }

fn colorize(egg: &mut Egg) -> &Color {
  egg.color = Color::Blue;
  return &egg.color
}

fn main() {
  let mut egg = Egg {color: Color::None};
  let color: &Color;
  {
    let egg_ref = &mut egg;
    color = colorize(egg_ref)
  }
  println!("color: {color:?}")
}
```

:::

:::{.column width="45%"}

**Question:** Does that compile?

[**Answer**: Yes, `get` takes a shared reference of a field in a `&mut
Egg` which works because we do not access `egg_ref` after L15.]{.fragment}

:::

::::::

---

## Quiz - Addendum

The `colorize` method is basically a method on `Egg` which takes a **exclusive
reference** `&mut self` only for the duration of that function.

```rust {line-numbers=}
#[derive(Debug)]
enum Color {None, Blue}
struct Egg { color: Color }

impl Egg {
  fn colorize(&mut self) -> &Color {
    self.color = Color::Blue;
    return &self.color
  }
}

fn main() {
  let mut egg = Egg {color: Color::None};
  let color: &Color;
  {
    color = egg.colorize()
  }
  println!("color: {color:?}")
}
```
