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

- Question: What is the type of `smaller_than_9`?
- Question: How to write `filter` to be most generic.
