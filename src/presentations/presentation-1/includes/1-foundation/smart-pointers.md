<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Smart Pointers

---

## Put it in a `Box`

That pointer from the stack to the heap, how do we create such a thing?

::: {.center-content .p-no-margin}

![Smart Pointer to the Heap](${meta:include-base-dir}/assets/images/A1-smart-pointer.svgbob){.svgbob
#fig:smart-pointer-box}

:::

::: incremental

- 🧰 **Boxing**: Store a type `T` on the heap.

- 👑 `Box` **uniquely owns** that value. Nobody else does.

- 🚂 Move semantics apply to a `Box`. Even if the type inside the box is `Copy`.

:::

```rust {.fragment}
fn main() {
  // Put an integer on the heap
  let boxed_int = Box::new(10);
}
```

---

## Boxing

Reasons to box a type `T` on the heap:

::: incremental

- When something is too large to move around ⏱️.

- Need something dynamically sized.

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
