<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Smart Pointers

---

## What is a Smart Pointer?

- A wrapper type which manages a type `T`
- `T` is allocated on the heap.

---

## Single Ownership - [`Box<T>`](https://doc.rust-lang.org/std/boxed/struct.Box.html)

[`Box<T>`](https://doc.rust-lang.org/std/boxed/struct.Box.html) will allocate a
type `T` on the heap and wrap the pointer underneath:

::::::{.columns}

:::{.column width="50%"}

```rust
fn main() {
  // Put an integer on the heap
  let boxed_int: Box<i64> = Box::new(10);
}
```

:::

:::{.column width="50%"}

::: {.center-content .p-no-margin}

![Smart Pointer `Box<T>`](${meta:include-base-dir}/assets/images/A1-smart-pointer.svgbob){.svgbob
#fig:smart-pointer-box}

:::

:::

::::::

- 🧰 **Boxing**: Store a type `T` on the heap.

::: incremental

- 👑 `Box` **uniquely owns** that value. Nobody else does.
- 🧺 A `Box` variable will deallocate the memory when out-of-scope.
- 🚂 Move semantics apply to a `Box`. Even if the type inside the box is `Copy`.

:::

---

## When to use `Box<T>`?

Reasons to box a type `T` on the heap:

::: incremental

- When something is too large to move around ⏱️.

- Need something dynamically sized (`dyn Trait` later).

- You need single ownership.

- For writing recursive data structures:

  ```rust {.fragment}
  struct Node {
    data: Vec<u8>,
    parent: Box<Node>,
  }
  ```

:::

::: notes

- Allowing arbitrarily large values on the stack would quickly let our function
  calls exhaust the stack limit

  - Especially if a move actually would involve memcopying the bits to another
    location in memory that would take way too long

- Of course the main reason that a vector uses the heap is to be able to be
  sized dynamically, but even so, a vector can be large, whereas an array will
  generally always have a limited size

:::

---

## Shared Ownership - [`Arc<T>`](https://doc.rust-lang.org/std/sync/struct.Arc.html)

An [`Arc<T>`](https://doc.rust-lang.org/std/sync/struct.Arc.html)
(**A**tomic-**R**eference-**C**ounted)

::::::{.columns}

:::{.column width="55%" style="align-content:center;"}

- allows shared ownership of a value of type `T`.
- inner value `T` allocated on the heap.
- disallows mutation of the inner value `T` (more in the docs).

:::

:::{.column width="45%"}

![Smart Pointer `Arc<T>`](${meta:include-base-dir}/assets/images/A1-smart-pointer-arc.svgbob){.svgbob
#fig:smart-pointer-arc}

:::

::::::

---

## Shared Ownership - [`Arc<T>`](https://doc.rust-lang.org/std/sync/struct.Arc.html) (2)

```rust {line-numbers="4|7|11|12|15"}
use std::sync::Arc;

fn main() {
    let data = Arc::new(vec![1, 2, 3]);

    {
      let data_other = data.clone();
      // Is always a cheap pointer copy
      // and does not copy the Vec!

      println!("Owners: {}", Arc::strong_count(&data));
      println!("Data: {:?}", data_other)
    }

} // data is last owner -> deallocated heap memory.
```

---

## Exercise Time (7)

Approx. Time: 40-50 min.

Do the following exercises:

- exercise: `boxed-data`: all

**Build/Run/Test:**

```bash
just build <exercise> --bin 01
just run <exercise> --bin 01
just test <exercise> --bin 01
just watch [build|run|test|watch] <exercise> --bin 01
```
