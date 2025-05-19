<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Smart Pointers

---

## Put it in a `Box`

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

![Smart Pointer to the Heap](${meta:include-base-dir}/assets/images/A1-smart-pointer.svgbob){.svgbob
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

## Boxing

Reasons to box a type `T` on the heap:

::: incremental

- When something is too large to move around ⏱️.

- Need something dynamically sized (`dyn Trait` later).

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
