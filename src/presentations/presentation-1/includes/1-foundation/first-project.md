<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

---

# Your First Project

---

## Create a Project

```bash
cargo new hello-world
```

Cargo is the build tool for Rust. It includes a package manager, commands for
initiating libraries/CLI etc.

```bash
cd hello-world
cargo run
```

```text
Compiling hello-world v0.1.0 (/home/teach-rs/Projects/hello-world)
Finished dev [unoptimized + debuginfo] target(s) in 0.74s
Running `target/debug/hello-world`
Hello, world!
```

---

## First Project

### Hello World!

```rust {data-line-numbers="all|1-3|2|5-11|6-10|7,9|all"}
fn main() {
    println!("Hello, world! fib(6) = {}", fib(6));
}

fn fib(n: u64) -> u64 {
    if n <= 1 {
        n
    } else {
        fib(n - 1) + fib(n - 2)
    }
}
```

```text
Compiling hello-world v0.1.0 (/home/teach-rs/Projects/hello-world)
Finished dev [unoptimized + debuginfo] target(s) in 0.28s
Running `target/debug/hello-world`
Hello, world! fib(6) = 8
```

::: notes

- `fn main()` is the entrypoint of your program
- `println!` (output something to `stdout`)
- Note the call syntax `fib(6)` with comma separated parameters
- exclamation mark is a macro (we'll see later)
- `fn` short for function, declare a function
- we see our first types here, we'll see more about them later
- `u64` unsigned integer types, all integers have an explicit size, 64 bits in
  this case
- `if-else` is without parenthesis for the expression, but with required braces
  for the blocks
- no explicit return keyword (will get back to that)

:::
