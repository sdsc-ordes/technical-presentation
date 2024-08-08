<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Move Semantics

---

## Memory

- A computer program consists of a set of instructions.
- Those instructions manipulate some memory.
- How does a program know what memory can be used?

:::notes

- A program is not just the code that is running, it is also the current state
  of that program (the memory).
- But central here is the question: when does a program know when it can use a
  specific part of that memory, when is it available?

:::

---

## Program Execution

<!-- prettier-ignore-start -->
:::::: {.columns}
::: {.column width="60%"}

An executable **binary** (a file on your disk) will be loaded first into the memory.

::: incremental

- The **machine instructions** are loaded into the memory.

- The **static data** in the binary (i.e. strings etc)
  is also loaded into memory.

- The CPU starts fetching the instructions
  from the RAM and will start to execute the machine instructions.

- Two memory mechanisms are at play when executing:
  the **stack** and the **heap**
:::

:::
::: {.column .center-content}

![Memory Layout](${meta:include-base-dir}/assets/images/A1-memory-expanded.svg)

:::
::::::

<!-- prettier-ignore-end -->

---

## Stack

<!-- prettier-ignore-start -->
:::::: {.columns}
::: {.column width="60%"}

Continuous areas of memory for local variables
in functions.

::: incremental
  - It is fixed in size.

  - Stack grows and shrinks, it follows **function calls**.
    Each function has its own stack frame for all its local variables.

  - Values must have **fixed sizes known at compile time**.
    (If the compiler doesn't know it cannot compute the stack frame size)

  - Access is extremely fast: offset the **stack pointer**.

  - Great memory locality  CPU caches.
:::


:::
::: {.column .center-content}

![Memory Layout](${meta:include-base-dir}/assets/images/A1-memory-expanded.svg)

:::
::::::
<!-- prettier-ignore-end -->

---

## Stack - Example

```rust {data-line-numbers="|9-11|1-7|2-3|5-6||2,5|"}
fn foo() { // Enter 2. stack frame.
    let a: u32 = 10; // `a` points on the stack containing 10.
    println!("a address: {:p}", &a);

    let b: u32 = a;  // Copy `b` to `a`.
    println!("b address: {:p}", &b;
} // `a,b` out of scope, we leave the stack frame.

fn main() { // Enter 1. stack frame.
  foo()
}
```

Stack frame needs at least $2 \cdot 32$ bits = $2 \cdot 4$ bytes = $8$ bytes.

```text
a address: 0x7ffdb6f09c08
b address: 0x7ffdb6f09c0c  // 08 + 4bytes = 0c
```

:::notes

- First look at the execution flow of this program.
- We enter the `main` function which calls `foo`.
- We enter `foo`, the second stack frame.
- We create a local variable with value `10` and print its memory address.
- We create a local variable `b` by assigning `a` which copies the value from
  `a` to `b`, and we print its memory address.

- Lets look now from the compiler what it does.

- When the compiler compiles this program to machine instruction, it sees that
  function `foo` needs two 32bit variables, so the machine code in function
  `foo` will operate on a stack frame with exactly that size (namely 64 bits),
  to store `a` and `b` essentially for the instructions on line
- 2 and
- 5

:::

---

## The Heap (1)

The **heap** is just one **big pile of memory** for dynamic memory allocation.

::: {.fragment}

### Usage

:::incremental

- Memory which outlives the stack (when you leave the function).

- Storing **big objects** in memory is done using **the heap**.

:::

:::

---

## The Heap (2)

The memory **management** on the **heap depends on the language** you write.

<!-- prettier-ignore-start -->
::: {.fragment}

### Mechanics

:::incremental

- **Allocation/deallocation** on the heap is done by the operating system.
  - Linux: Programs will call into `glibc` (`malloc` , etc.) which interacts
    with the kernel.

- **Depends on the language**:

  :::::: {.columns}
  ::: {.column width="50%"}
  - [**Full Control**]{.red}: C, C++, Pascal,...:
    - Programmer decides when to allocate and deallocate memory.
    - Programmer ensures if some pointer still points to valid memory  🚀 vs. 💣🐞

  :::
  ::: {.column width="50%"}
  - [**Full Safety**]{.green}: Java, Python, Go, Haskell, ...:
    - A runtime system (**garbage collector**) ensures memory is deallocated at
      the right time.  🐌 vs. 🦺
  :::
  ::::::

:::
:::

<!-- prettier-ignore-end -->

---

### Mechanics 🦀

- [**Full Control and Safety**]{.green}: **Rust** - [Via compile
  time enforcement of correct memory management.]{.emph}

  - It does this with an explicit ownership concept.
  - It tracks life times (of references).

---

## Variable Scoping (recap)

```rust
fn main() {
    let i = 10; // `i` in scope.

    if i > 5 {
        let j = i;
    }  // `j` no longer in scope.

    println!("i = {}", i);
} // i is no longer in scope
```

- Types of `i` and `j` are examples of a `Copy` types.
- What if copying is too expensive?

::: notes

- When looking at how Rust solves working with the heap, we have to know a
  little bit about variable scoping.
- In Rust, every variable has a scope, that is, a section of the code that that
  variable is valid for. Note that this is a bit different from python.
- In our example we have `i` and `j`. Note how we can just create a copy by
  assigning `i` to `j`.
- Here the type of i and j is actually known as a `Copy` type.
- But sometimes there is data that would be way too much to Copy around every
  time, it would make our program slow.

:::

---

## Ownership (1)

:::::: {.columns}

::: {.column width="50%" }

```rust {line-numbers=}
// Create two variables on the stack.
let a = 5;
println!("{}", a);
```

Local integer `a` allocated on the <br> **stack**.

![](${meta:include-base-dir}/assets/images/A1-int-stack.svgbob){.svgbob}

:::

::: {.column width="50%"}

```rust {line-numbers=}
// Create an owned, heap allocated string
let a = String::from("hello");
println!("{}, world!", a);
```

Strings (`a`) store data on the **heap** because they **can grow**.

![](${meta:include-base-dir}/assets/images/A1-string-stack.svgbob){.svgbob}

:::

:::::

---

### Ownership (2)

<!-- prettier-ignore-start -->

:::::: {.columns}
::: {.column width="50%" }

```rust {line-numbers=}
fn foo() {
  let a = 5;
  let b = a;
  println!("{}", a);
}
```

Assignment of `a` to `b` **copies** `a` to `b`.

:::{.center-content .p-no-margin}
![](${meta:include-base-dir}/assets/images/A1-int-stack-copy.svgbob){.svgbob style="margin:0;"}
:::

:::
::: {.column width="50%" .fragment}

```rust {line-numbers=}
fn foo() {
  let a = String::from("hello");
  let b = a;
  println!("{}, world!", a);
}
```

Assignment of `a` to `b` transfers ownership.

:::{.center-content .p-no-margin}
![](${meta:include-base-dir}/assets/images/A1-string-stack-copy.svgbob){.svgbob style="margin:0;"}
:::

- When `a` out of scope: nothing happens.
- When `b` goes out of scope: the string **data is deallocated**.

:::
:::::

<!-- prettier-ignore-end -->

---

### Ownership (3)

<!-- prettier-ignore-start -->

:::::: {.columns}
::: {.column width="50%" }
```rust {line-numbers=}
fn foo() {
  let a = String::from("hello");
  let b = a;
  println!("{}, world!", a);
  //                     ^--- Nope!! ❌
}
```
:::
::: {.column width="50%" }

```text
error[E0382]: borrow of moved value: `a`
--> src/main.rs:4:28
  |
2 |     let a = String::from("hello");
  |         - move occurs because `a`
  |           has type `String`, which
  |           does not implement the `Copy`
  |           trait
  |
3 |     let b = a;
  |             - value moved here
4 |     println!("{}, world!", a);
  |                            ^
  |            value borrowed here
  |            after move
```

:::
::::::

<!-- prettier-ignore-end -->

---

## Ownership - The Rules

::: incremental

- There is always **ever only one owner** of a stack value.

- Once the owner goes out of scope (and is removed from the stack), any
  associated values on **the heap** will be deallocated.

- Rust **transfers ownership** for non-copy types: **move semantics**.

:::

:::{.center-content .p-no-margin}

![](${meta:include-base-dir}/assets/images/A1-i-own-this-light-mod.png)

:::

::: notes

- What we've just seen is the Rust ownership system in action.
- In Rust, every part of memory in use always has an owner variable. That
  variable must always be the only owner, there can't be multiple owners.
- Once a scope that contains a variable ends we don't just pop the top from the
  stack, but we also clean up any associated values on the heap.
- We can safely do this because we just said that this variable was the only
  owner of that part of memory.
- Assigning a variable to another one actually moves ownership to the other
  variable and removes it from the first variable, instead of aliasing it (which
  is what C and C++ do)

:::

---

## Ownership - Move into Function

<!-- prettier-ignore-start -->

:::::: {.columns}
::: {.column width="50%" }

```rust {line-numbers=}
fn main() {
  let a = String::from("hello");

  let len = calculate_length(a);
  println!("Length of '{}' is {}.",
           a, len);
}

fn calculate_length(s: String) -> usize {
  s.len()
}
```

:::
::: {.column width="50%"}

```text
error[E0382]: borrow of moved value: `a`
--> src/main.rs:4:43
  |
2 | let a = String::from("hello");
  |     - move occurs because `a`
  |       has type `String`,
  |       which does not implement the
  |       `Copy` trait
  |
3 | let len = calculate_length(a);
  |           value moved here -
  |
4 | println!("Length of '{}' is {}.",
  |          a, len);
  |          ^
  |          value borrowed here after move
```
:::
::::::

<!--prettier-ignore-end -->

::: notes

- Moving also works when calling a function, the function takes ownership of the
  variable that is passed to it
- That means that when the function ends it will go out of scope and should be
  cleaned up
- What do you think that will happen in this case when we try and print the
  string and the length of the string after the function call.

:::

---

## Ownership - Moving Out of Function

We can return a value to move it out of the function

```rust
fn main() {
    let a = String::from("hello");
    let (len, a) = calculate_length(a);

    println!("Length of '{}' is {}.", a, len);
}

fn calculate_length(s: String) -> (usize, String) {
    (s.len(), s)
}
```

```text {.fragment}
Compiling playground v0.0.1 (/playground)
Finished dev [unoptimized + debuginfo] target(s) in 5.42s
Running `target/debug/playground`

Length of 'hello' is 5.
```

::: notes

- But what if we move a value into a function and we still want to use it
  afterwards, we could choose to move it back at the end of the function, but it
  really doesn't make for very nice code
- Note that Rust allows us to return multiple values from a function with this
  syntax.

:::

---

## Clone

:::::: {.columns}

::: {.column style="width:80%; align-content:center;"}

- Many types in Rust are `Clone`-able.

::: incremental

- Use `clone()` to create an **explicit** clone.
  - In contrast to `Copy` which creates an **implicit** copy.
- ⏱️ Clones can be expensive and could take a long time, so be careful.
- 🐌 Not very efficient if a clone is short-lived like in this example .

:::

:::

:::{.column style="width:20%; align-content:center;" .p-no-margin}

<!-- prettier-ignore-start-->
[![](${meta:include-base-dir}/assets/images/A1-clone.svg){.border-dark}]{.center-content style="width:100%;"}
<!-- prettier-ignore-end -->

:::

::::::

```rust
fn main() {
    let x = String::from("hellothisisaverylongstring...");
    let len = get_length(x.clone());
    println!("{}: {}", x, len);
}

fn get_length(arg: String) -> usize {
    arg.len()
}
```

::: notes

- There is something else in Rust
- Many types implement a way to create an explicit copy, such types are
  clone-able. But note how we have to very explicitly say that we want a clone.
- Such a clone is a full deep copy clone and can of course take a long time,
  which is why Rust wants you to be explicit.
- Also in this example this is a really inefficient usage of our clone, because
  it gets destroyed almost immediately after creation

:::

---

## Exercise Time

Approx. Time: 20-45 min.

Do the following exercises:

- `move-semantics`: 01-04

  **Build/Run/Test:**

  ```bash
  just build move-semantics --bin 01
  just run move-semantics --bin 01
  just test move-semantics --bin 01
  ```

  **Continuously evaluate with `cargo-watch`:**

  ```bash
  just watch build move-semantics --bin 01
  just watch run move-semantics --bin 01
  just watch test move-semantics --bin 01
  ```
