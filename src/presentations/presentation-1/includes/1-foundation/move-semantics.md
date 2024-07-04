<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

---

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

# The Heap

The **heap** is just one **big pile of memory** for dynamic memory allocation.

::: {.fragment}

### Usage

:::incremental

- Memory which outlives the stack (when you leave the function).

- Storing **big objects** in memory is done using **the heap**.

:::

:::

---

# The Heap

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

### Mechanics - Rust

- [**Full Control and Safety**]{.green}: **Rust** 🦀 - [Via compile
  time enforcement of correct memory management.]{.emph}

  - It does this with an explicit ownership concept.
  - It tracks life times (of references).

---

# Variable Scoping (recap)

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

## Ownership

:::::: {.columns}

::: {.column width="50%"}

```rust
let x = 5;
let y = x;
println!("{}", x);
```

Some local variables allocated on the stack.

![](${meta:include-base-dir}/assets/images/A1-string-stack.svg)

:::

::: {.column width="50%"}

```rust
// Create an owned, heap allocated string
let s1 = String::from("hello");
let s2 = s1;
println!("{}, world!", s1);
```

Strings store their data on the heap because they can grow

![](${meta:include-base-dir}/assets/images/A1-string-stack.svg)

:::

:::::

:::::: {.columns}

::: {.column width="50%"}

```text
Running `target/debug/playground`
5
```

:::

::: {.column width="50%" }

```text {style="font-size:12pt;"}
error[E0382]: borrow of moved value: `s1`
--> src/main.rs:4:28
  |
2 |     let s1 = String::from("hello");
  |         -- move occurs because `s1`
  |            has type `String`, which
  |            does not implement the `Copy` trait
3 |     let s2 = s1;
  |              -- value moved here
4 |     println!("{}, world!", s1);
  |                            ^^ value borrowed here
  |                               after move
```

:::

::::::

::: notes

- Let's take the previous example and get rid of some scopes, instead we are
  just going to assign x to y, and then print both x and y. What do we think is
  going to happen?
- Now the same example again, but now with a String, "hello", we are just going
  to assign it to another variable and then print both s1 and s2. What do we
  think is going to happen now?
- See how this time the compiler doesn't even let us run the program. Hold on,
  what's going on here?
- Actually, in Rust strings can grow, that means that we can no longer store
  them on the stack, and we can no longer just copy them around by re-assigning
  them somewhere else.

:::

<!-- --- -->
<!---->
<!-- <LightOrDark> -->
<!--   <template #dark> -->
<!--     <img src="/images/A1-i-own-this-dark.png" class="pl-30 h-90 float-right" /> -->
<!--   </template> -->
<!--   <template #light> -->
<!--     <img src="/images/A1-i-own-this-light.png" class="pl-30 h-90 float-right" /> -->
<!--   </template> -->
<!-- </LightOrDark> -->
<!---->
<!-- # Ownership -->
<!---->
<!-- - There is always ever only one owner of a stack value -->
<!-- - Once the owner goes out of scope (and is removed from the stack), any -->
<!--   associated values on the heap will be cleaned up as well -->
<!-- - Rust transfers ownership for non-copy types: _move semantics_ -->
<!---->
<!-- <!-- -->
<!-- * What we've just seen is the Rust ownership system in action. -->
<!-- * In Rust, every part of memory in use always has an owner variable. That -->
<!-- variable must always be the only owner, there can't be multiple owners. -->
<!-- * Once a scope that contains a variable ends we don't just pop the top from the -->
<!-- stack, but we also clean up any associated values on the heap. -->
<!-- * We can safely do this because we just said that this variable was the only -->
<!-- owner of that part of memory. -->
<!-- * Assigning a variable to another one actually moves ownership to the other -->
<!-- variable and removes it from the first variable, instead of aliasing it -->
<!-- (which is what C and C++ do) -->
<!-- --> -->
<!---->
<!-- --- -->
<!---->
<!-- ```rust -->
<!-- fn main() { -->
<!--     let s1 = String::from("hello"); -->
<!--     let len = calculate_length(s1); -->
<!--     println!("The length of '{}' is {}.", s1, len); -->
<!-- } -->
<!---->
<!-- fn calculate_length(s: String) -> usize { -->
<!--     s.len() -->
<!-- } -->
<!-- ``` -->
<!---->
<!-- <v-click> -->
<!---->
<!-- <div class="no-line-numbers"> -->
<!---->
<!-- ```text -->
<!-- Compiling playground v0.0.1 (/playground) -->
<!-- error[E0382]: borrow of moved value: `s1` -->
<!-- --> src/main.rs:4:43 -->
<!--   | -->
<!-- 2 | let s1 = String::from("hello"); -->
<!--   |     -- move occurs because `s1` has type `String`, which does not implement the `Copy` trait -->
<!-- 3 | let len = calculate_length(s1); -->
<!--   |                            -- value moved here -->
<!-- 4 | println!("The length of '{}' is {}.", s1, len); -->
<!--   |                                       ^^ value borrowed here after move -->
<!-- ``` -->
<!---->
<!-- </div> -->
<!---->
<!-- </v-click> -->
<!---->
<!-- <!-- -->
<!-- * Moving also works when calling a function, the function takes ownership of -->
<!-- the variable that is passed to it -->
<!-- * That means that when the function ends it -->
<!-- will go out of scope and should be cleaned up -->
<!-- * What do you think that will happen in this case when we try and print the -->
<!-- string and the length of the string after the function call. -->
<!-- --> -->
<!---->
<!-- --- -->
<!---->
<!-- # Moving out of a function -->
<!---->
<!-- We can return a value to move it out of the function -->
<!---->
<!-- ```rust -->
<!-- fn main() { -->
<!--     let s1 = String::from("hello"); -->
<!--     let (len, s1) = calculate_length(s1); -->
<!--     println!("The length of '{}' is {}.", s1, len); -->
<!-- } -->
<!---->
<!-- fn calculate_length(s: String) -> (usize, String) { -->
<!--     (s.len(), s) -->
<!-- } -->
<!-- ``` -->
<!---->
<!-- <v-click> -->
<!---->
<!-- <div class="no-line-numbers"> -->
<!---->
<!-- ```text -->
<!-- Compiling playground v0.0.1 (/playground) -->
<!-- Finished dev [unoptimized + debuginfo] target(s) in 5.42s -->
<!-- Running `target/debug/playground` -->
<!-- The length of 'hello' is 5. -->
<!-- ``` -->
<!---->
<!-- </div> -->
<!---->
<!-- </v-click> -->
<!---->
<!-- <!-- -->
<!-- * But what if we move a value into a function and we still want to use it -->
<!-- afterwards, we could choose to move it back at the end of the function, but -->
<!-- it really doesn't make for very nice code -->
<!-- * Note that Rust allows us to return multiple values from a function with -->
<!-- this syntax. -->
<!-- --> -->
<!---->
<!-- --- -->
<!---->
<!-- # Clone -->
<!---->
<!-- <img src="/images/A1-clone.jpg" class="float-right w-40" /> -->
<!---->
<!-- - Many types in Rust are `Clone`-able -->
<!-- - Use can use clone to create an explicit clone (in contrast to `Copy` which -->
<!--   creates an implicit copy). -->
<!-- - Creating a clone can be expensive and could take a long time, so be careful -->
<!-- - Not very efficient if a clone is short-lived like in this example -->
<!---->
<!-- ```rust -->
<!-- fn main() { -->
<!--     let x = String::from("hellothisisaverylongstring..."); -->
<!--     let len = get_length(x.clone()); -->
<!--     println!("{}: {}", x, len); -->
<!-- } -->
<!---->
<!-- fn get_length(arg: String) -> usize { -->
<!--     arg.len() -->
<!-- } -->
<!-- ``` -->
<!---->
<!-- <!-- -->
<!-- * There is something else in Rust -->
<!-- * Many types implement a way to create an explicit copy, such types are -->
<!-- clone-able. But note how we have to very explicitly say that we want a -->
<!-- clone. -->
<!-- * Such a clone is a full deep copy clone and can of course take a long -->
<!-- time, which is why Rust wants you to be explicit. -->
<!-- * Also in this example this is a really inefficient usage of our clone, -->
<!-- because it gets destroyed almost immediately after creation -->
<!-- --> -->
