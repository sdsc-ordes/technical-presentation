<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# The Type `Vec<T>`

---

## `Vec<T>`: Storage for Same Type `T`

The `Vec<T>` is an array of types `T` that **can grow**.

- Compare this to the array, which has a fixed size:

  ```rust {line-numbers=}
  fn main() {
    let arr = [1, 2];
    println!("{:?}", arr);

    let mut nums = Vec::new();
    nums.push(1);
    nums.push(2);

    println!("{:?}", nums);
  }
  ```

---

## `Vec`: Constructor Macro

`Vec` is common type. Use the macro `vec!` to initialize it with values:

```rust {line-numbers="2"}
fn main() {
  let mut nums = vec![1, 2];
  nums.push(3);

  println!("{:?}", nums);
}
```

---

## `Vec`: Memory Layout

How can a vector grow? Things on the stack need to be of a fixed size.

:::::: {.columns}

:::{.column width="50%" .fragment}

![`Vec<T>` Memory Layout](${meta:include-base-dir}/assets/images/A1-vec-memory-layout.svgbob){.svgbob}

:::

::: {.column style="width:50%; align-content:center;" .fragment}

::: incremental

- A `Vec` allocates its contents on the heap (a `[i64; 4]` is on the stack).

- **Quiz:** What happens if the capacity is full and we add another element.

  - The `Vec` **reallocates** its memory with more capacity to another memory
    location  Lots of copies 🐌 ⏱️.

:::

:::

::::::
