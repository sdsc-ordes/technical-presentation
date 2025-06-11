# Testing your Crate

:::notes

Next up: testing your crate. In bigger projects, automatic testing is key if you
want to keep bugs away. In this section we will discuss some Rust
functionalities that will help you test your application.

:::

---

## Testing Methods

- Testing for correctness:
  - Unit tests
  - Integration tests
- Testing for performance:
  - Benchmarks

:::notes

Automatic testing can help you verify the correctness of your code, as well as
test performance.

- A common of testing correctness are by setting up unit tests, which test a
  small piece of functionality, a unit.
- If you want to test the correctness of interaction between those units, you
  can set up integration test.
- However, if you want to test performance, you can use benchmarking. Let's go
  over how Rust supports these various testing methods.

:::

---

## Unit Tests

- Tests a single function or method.
- Live in child module.
- Can test private code.

To run:

::::::{.columns}

:::{.column width="50%"}

```bash {style="font-size:14pt;"}
cargo test
...
running 2 tests
test tests::test_swap_items ... ok
test tests::test_swap_oob - should panic ... ok
test result: ok.
    2 passed; 0 failed; 0 ignored; 0 measured;
    0 filtered out;
    finished in 0.00s
[..]
```

:::

:::{.column width="50%" .fragment}

```bash
## Don't capture stdout while running tests
cargo test -- --nocapture
```

:::

::::::

_Rust compiles your test code into binary using a **test harness** that itself
has a CLI_:

:::notes

- Unit tests are great for testing behavior of a single function or method.
- In Rust, they live in child modules, allowing them to access private
  functionality
- Once set up, a `cargo test` is sufficient to build and run the tests

:::

---

::::::{.columns}

:::{.column width="50%"}

```rust {style="font-size:14pt;"}
/// Swaps two values at the `first` and
/// `second` indices of the slice.
fn swap(slice: &mut [u32],
        first: usize, second: usize) {
  let tmp = slice[second];
  slice[second] = slice[first];
  slice[first] = tmp;
}

```

:::

:::{.column width="50%" .fragment}

```rust {line-numbers="8-11,28|13-19|18|21-27" style="font-size:14pt;"}
/// This module is only compiled in `test` configuration.
##[cfg(test)]
mod tests {
  use crate::swap;

  // Mark function as test.
  #[test]
  fn test_swap() {
    let mut array = [0, 1, 2, 3, 4, 5];
    swap(&mut array[..], 1, 4);
    assert_eq!(array, [0, 4, 2, 3, 1, 5]);
  }

  #[test]
  #[should_panic] // This should panic.
  fn test_swap_oob() {
    let mut array = [0, 1, 2, 3, 4, 5];
    swap(&mut array[..], 1, 6);
  }
}
```

:::

::::::

:::notes

Here's an example of a function being tested.

-`swap` takes a mutable slice, as well as two indices, and swaps the items at
those indices.

- Below, we've defined a module called `tests`, which is decorated with the
  `#[cfg(test)]` attribute. This attribute makes sure the module is only
  compiled when running tests.
- Inside the `tests` module, we've defined two tests and imported the `swap`
  function from the parent module. The first test, `test_swap`, sets up a slice,
  passes it to `swap` along with two indices.
- `test_swap` uses the `assert_eq!` macro to compare the affected array with an
  expected array. This `assert_eq!` macro panics on inequality, making the test
  fail if the outcome is not as expected.
- The second test, `test_swap_oob` is decorated with the `#[should_panic]`
  macro, meaning this test should only pass if it panics.

Q: Why should `test_swap_oob` panic?

:::

---

## Integration Tests

- Tests crate public API.
- Run with `cargo test`.
- Defined in `tests` folder.

```bash {line-numbers="14"}
tree
├── Cargo.toml
├── examples
│   └── my_example.rs
├── src
│   ├── another_mod
│   │   └── mod.rs
│   ├── bin
│   │   └── my_app.rs
│   ├── lib.rs
│   ├── main.rs
│   └── some_mod.rs
└── tests
    └── integration_test.rs
```

:::notes

To test your application from the outside, you can set up integration tests.
These integration tests test your crates public interface and are also executed
by running `cargo test`.

- They are defined in a separate folder, called `tests`

:::

---

## Tests in Your Documentation

You can even use examples in your documentation as tests

::::::{.columns}

:::{.column width="50%"}

````rust {line-numbers="all|5-10|6"}
/// Calculates fibonacci number n.
///
/// # Examples
/// ```
/// # use example::fib;
/// assert_eq!(fib(2), 1);
/// assert_eq!(fib(5), 5);
/// assert_eq!(fib(55), 55);
/// ```
pub fn fib(n: u64) -> u64 {
    if n <= 1 {
        n
    } else {
        fib(n - 1) + fib(n - 2)
    }
}
````

:::

:::{.column width="50%"}

```bash
cargo test --doc
```

:::

::::::

:::notes

- Note that _doctests_ are executed as if they are in another crate
- Lines with a hash (#) in front of them are not outputted in the generated
  documentation
- Don't try and write all your tests in doc form, only use them if you really
  want to provide an example

:::

---

## Benchmarks

- Test _performance_ of code (vs. correctness).
- Runs a tests many times, yield average execution time.
- **Before you do benchmarking do unit testing!**.

Good benchmarking is **Hard**

- Beware of optimizations.
- Beware of initialization overhead.
- Be sure your benchmark is representative.

### _More in Exercises_

:::notes

Lastly, we'll briefly look at benchmarks, which test code performance instead of
correctness. Basically, a test is run many, many times, and statistics about the
execution time are gathered and reported.

- Note that good benchmarking is hard. You have to make sure tested parts of
  your code are not optimized away when they shouldn't be. Also, be aware of
  overhead. But most of all: make sure you benchmark is representative depending
  on the intended use of your code.
- We'll go a bit deeper into benchmarking in the exercises.

:::
