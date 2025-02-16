<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

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
Compiling hello-world v0.1.0
Finished dev [unoptimized + debuginfo] target(s) in 0.74s
Running `target/debug/hello-world`
Hello, world!
```

---

## Computing a Simple Sum

```rust {line-numbers="all|1-3|2|5-11|6-10|7,9|all"}
fn main() {
    println!("sum(4) = 4 + 3 + 2 + 1 = {}", sum(4));
}

fn sum(n: u64) -> u64 {
    if n != 0 {
        n + sum(n-1)
    } else {
        n
    }
}
// Note: avoid recursion as you always can :)
```

**Output**:

```text
sum(4) = 4 + 3 + 2 + 1 = 10
```

::: notes

- `fn main()` is the entrypoint of your program
- `println!` (output something to `stdout`)
- Exclamation mark is a macro (we'll see later)
- `fn` short for function, declare a function
- `u64` unsigned integer types, all integers have an explicit size, 64 bits in
  this case
- `if-else` is without parenthesis for the expression, but with required braces
  for the blocks
- no explicit return keyword (will get back to that)

:::
