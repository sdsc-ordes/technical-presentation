<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Ownership and Borrowing

---

## Ownership

We previously talked about ownership:

::: incremental

- There is always a **single owner** for each **stack value**.
- If **owner** goes out of scope any associated values is cleaned up.
- Copy types (`Copy` trait) creates **copies**, all other types are **_moved_**.

:::

:::notes

- Note once more that the idea of moving is something that exists in the Rust
  world, but not necessarily every move actually copies bytes around, these are
  all things where Rust's model is an abstraction over what the compiled code
  actually does.

:::

---

## Moving Out of a Function

We have previously seen this example:

```rust
fn main() {
    let a = String::from("hello");
    let len = calculate_length(a);

    println!("Length of '{}' is {}.", a, len);
}

fn calculate_length(s: String) -> usize {
    s.len()
}
```

- Does not compile ⇒ ownership of `a` is moved into `calculate_length` ⇒ no
  longer available in `main`.
- We can use `Clone` to create an explicit copy.
- We can give ownership back by returning the value.

**Question: Are there other options?**

---

## Moving Out of a Function (🐍)

In Python we have this:

```python {line-numbers="|8,9" fragment-index="1"}
def main() {
    a = "hello";
    len = calculate_length(a);

    print(f"Length of '{a}' is {len}.");
}

def calculate_length(s: str) -> int {
    return len(s)
}
```

[**Question:** To what memory does `s` refer to? Is it a copy?]{.fragment fragment-index="2"}

---

## Borrowing

- **Analogy:** if somebody owns something you can **borrow** it from them, but
  eventually you have to give it back.

- If a value is **borrowed**, it is **not moved** and the ownership stays with
  the original owner.

- To **borrow** in Rust, we create a **_reference_**

```rust {line-numbers="all|3|8-10|all"}
fn main() {
    let x = String::from("hello");
    let len = get_length(&x); // borrow with &

    println!("{}", x);
}

fn get_length(s: &String) -> usize {
    s.len()
}
```

---

## References (read, immutable)

Create a **read-only** reference `&`:

<!-- prettier-ignore-start -->

:::::: {.columns}
::: {.column width="50%"}

```rust {line-numbers="2|3|8|5"}
fn main() {
    let s = String::from("hello");
    change(&s);

    println!("{}", s);
}

fn change(s: &String) {
    s.push_str(", world");
}
```

:::
::: {.column width="50%" .fragment}

```text
error[E0596]:
    cannot borrow `*s` as mutable,
    as it is behind a `&` reference
 --> src/main.rs:8:5
8 | fn change(s: &String) {
  |              -------
  |     help: consider changing this to
  |            be a mutable reference:
  |           `&mut String`
9 |     s.push_str(", world");
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  |     `s` is a `&` reference, so the data
  |     it refers to cannot be borrowed
  |     as mutable

For more information about this error,
try `rustc --explain E0596`.
```

:::
::::::
<!-- prettier-ignore-end -->

::: notes

- Note how we cannot modify the referenced value through an immutable reference

:::

---

## References (write, mutable)

Create a **write** reference `&`:

<!-- prettier-ignore-start -->

:::::: {.columns}
::: {.column width="50%"}

```rust {line-numbers="|3,8" fragment-index="1"}
fn main() {
    let mut s = String::from("hello");
    change(&mut s);

    println!("{}", s);
}

fn change(s: &mut String) {
    s.push_str(", world");
}
```

:::
::: {.column width="50%" .fragment}

```text
Compiling playground v0.0.1 (/playground)
Finished dev target(s) in 2.55s
Running `target/debug/playground`
hello, world
```

:::
::::::
<!-- prettier-ignore-end -->

:::{.incremental fragment-index="4"}

- A **write** reference can even fully replace the original value.
- Use the dereference operator (`*`) to modify the value:

  ```rust
  *s = String::from("Goodbye");
  ```

:::

::: notes

- We can use a mutable reference here to allow us to modify a borrowed value
- Note that you may also sometimes have to use the deref operator to access the
  value when reading it, but most of the time the Rust compiler will do this
  automatically and you need not worry about it.

:::

---

## Rules for Borrowing and References

To any value, you can either have **at the same time**:

::::::{.columns}

:::{.column width="50%" .fragment}

### References

- **Single write** reference `&T` 🖊️

**OR**

- **Many read** references `&mut T` 📑 📑 📑

:::

:::{.column width="50%" .fragment}

### Lifetime

- References **cannot live** longer than their owners.
- A reference will always at all times **point to a valid value**.

:::

::::::

[These rules are enforced by the **borrow checker**.]{.fragment .emph}

::: notes

- Rust tries to be smart about enforcing these rules, such that you don't notice
  them that often in real life usage, but there may be some cases that clearly
  appear valid, but Rust won't allow. There are generally pretty easy
  workarounds though.
- Again: references are not pointers, but in practice of course they do look
  similar and are implemented the same way, but Rust's memory model is not the
  same as that of C/C++ and implementation is not the same as our model.
- Think about the second rule : This will enable lock-free parallelization!

:::

---

## Borrowing and Memory Safety

- The ownership model does guarantee **no**: <br> null pointer dereferences,
  data races, dangling pointers, use after free.

- 🦺 Rust is memory safe without any runtime garbage collector.

- 🚀 Performance of a language that would normally let you manage memory
  manually.

::: notes

- Memory bugs such as: null pointer dereferences, data races, dangling pointers,
  use after free.

:::

---

## Reference Example

::::::{.columns}

:::{.column width="50%" }

```rust {line-numbers="|3,5"}
fn main() {
    let mut s = String::from("hello");
    let a = &s;
    let b = &s;
    let c = &mut s;
    println!("{} - {} - {}", a, b, c);
}
```

:::

:::{.column width="50%" .fragment}

```text
error[E0502]: cannot borrow `s` as mutable
              because it is also
              borrowed as immutable
 --> src/main.rs:5:14
  |
3 |     let a = &s;
  |              - immutable borrow occurs
  |                here
4 |     let b = &s;
5 |     let c = &mut s;
  |              ^^^^^ mutable borrow occurs here
  |
6 |     println!("{} - {} - {}", a, b, c);
  |                              ^
  |  immutable borrow later used here

For more information about this error,
try `rustc --explain E0502`.
```

:::

::::::

---

## Returning References - Quiz

**Question: Does the following work?**
[Link](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=c26cf791529a35d2c105c1d5c55022bd)

::::::{.columns}

:::{.column width="40%" }

```rust
fn give_me_a_ref() -> &String {
  let s = String::from("Ups");
  &s
}
```

:::

:::{.column width="70%" }

```text {line-numbers="|13-15" style="font-size=14pt" .fragment}
error[E0106]: missing lifetime specifier
1 | fn give_me_a_ref() -> &String {
  |                       ^ expected named
  |                         lifetime parameter
  = help: this function's return type
        contains a borrowed value,
          but there is no value for it to be borrowed from
help: consider using the `'static` lifetime,
      but this is uncommon unless you're returning a
      borrowed value from a `const` or a `static`
1 | fn give_me_a_ref() -> &'static String {
  |                        +++++++
help: instead, you are more likely
      to want to return an owned value
1 | fn give_me_a_ref() -> String {
```

:::

::::::

[**❗Note: Returning a reference to a stack value (e.g. `s`) is
not possible.**]{ .fragment }

---

## Returning References - Quiz

The following is the correct signature:

```rust {.fragment}
fn give_me_a_value() -> String {
    let s = String::from("Hello, world!");
    s
}
```

---

## Returning References

You can however pass a reference through the function:

```rust
fn give_me_a_ref(input: &(String, i32)) -> &String {
    &input.0
}
```

- Rust annotates each reference with a **lifetime**.
- How to use lifetimes?  later!

:::notes

We will later see how these work if we have to use them to help the compiler in
certain cases.

:::

---

## Exercise Time (3)

Approx. Time: 20-30 min.

Do the following exercises:

- `borrowing`: all

**Build/Run/Test:**

```bash
just build <exercise> --bin 01
just run <exercise> --bin 01
just test <exercise> --bin 01
just watch [build|run|test|watch] <exercise> --bin 01
```
