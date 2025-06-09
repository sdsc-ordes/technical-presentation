# Recap 2

---

## Recap 2 - Closures

```rust
fn main() {
    let numbers = vec![1, 2, 5, 9];
    let smaller_than_5 = |x: i32| -> bool { x < 5 };

    let res = filter(&numbers, smaller_than_5);

    print!("Result: {res:?}")
}
```

- **Question:** What is the trait of `smaller_than_9`? [**Answer: `Fn`**]{.fragment}
- **Question:** How to write `filter` to be most generic.

  :::{.fragment}

  **Answer:**

  ```rust
  fn filter(nums: impl Iterator<Item = i32>, mut f: impl FnMut(i32) -> bool)
    -> impl Iterator<Item = i32>
  ```

  :::

:::notes

```rust
fn main() {
    let numbers = vec![1, 2, 5, 9];
    let smaller_than_5 = |x: i32| -> bool { x < 5 };

    let res = filter(numbers.into_iter(), smaller_than_5);
    println!("Result: {:?}", res.collect::<Vec<i32>>())
}

fn filter(
    nums: impl Iterator<Item = i32>,
    mut f: impl FnMut(i32) -> bool,
) -> impl Iterator<Item = i32> {
    nums.filter(move |&x| f(x))
}
```

:::
