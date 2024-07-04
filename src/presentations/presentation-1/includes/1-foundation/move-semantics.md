<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

---

# Move Semantics

---

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
::: {.column width="50%"}

A binary (a executable file on your disk) will be loaded first into the memory.

::: incremental

- The machine instructions are loaded into the memory.

- The static data in the binary (i.e. strings etc)
  is also loaded into memory.

- The CPU starts fetching the instructions
  from the RAM and will start to execute the machine instructions.

- Two memory mechanisms are at play when executing:
  the **stack** and the **heap**
:::

:::
::: {.column width="50%"}

![Memory Layout](${meta:include-base-dir}/assets/images/A1-memory-expanded.svg)

:::
::::::

<!-- prettier-ignore-end -->

---

## Stack

<!-- prettier-ignore-start -->
:::::: {.columns}
::: {.column width="50%"}

Continuous areas of memory for local variables
in functions.

::: incremental
  - It is fixed in size.

  - Stack grows and shrinks, it follows **function calls**.
    Each function has its own stack frame for all its local variables.

  - Values must have **fixed sizes known at compile time**.
    (If the compiler doesn't know it cannot compute the stack frame size)

  - Access is extremely fast: offset the **stack pointer**.

  - Great memory locality -> CPU caches.
:::


:::
::: {.column width="50%"}

![Memory Layout](${meta:include-base-dir}/assets/images/A1-memory-expanded.svg)

:::
::::::
<!-- prettier-ignore-end -->

---

## Fundamentals - Stack & Heap

There are two mechanisms at play here, generally known as the stack and the heap

![TODO](Stack-image.svg)

::: notes

- In this simplified view we see the stack mechanism and the heap mechanism.

- The stack is a growing stack of used memory, where the only way to remove
  memory from being used is by removing it from the top of the stack and the
  only way to add is to put it on top of the stack.

- Somehow, as with a lot of CS stuff, we like to turn things around and think of
  stacks growing down instead of up in the real world. That is because they are
  at the end of the virtual memory address range. So if the stack grows, the
  stack pointer (to the current stack frame) is decreased.

:::

---

## Fundamentals - Stack & Heap

There are two mechanisms at play here, generally known as the stack and the heap

![TODO](Stack-image2.svg)

::: notes

- We create a new part of the stack, called stack frame, every time we enter a
  function, meanwhile we have a small special bit of memory, register, where the
  current top of the stack is recorded.

:::

---

## Fundamentals - Stack & Heap

![TODO](Stack-image3.svg)

::: notes

- And as we leave a function, we just put the stack pointer back down and we
  just act as if everything above it doesn't exist.
- Also take a look at the heap memory instead, look at how there are many
  differently sized blocks of memory scattered across the heap.

:::

---

# The Heap

If you want memory (i.e. a local variable of function) to outlive the stack you
need **the heap**.

The **heap** is just one big pile of memory for dynamic memory allocation.

- Allocation of memory on the heap is done by the OS.
- Rust provides ways of allocating objects of any type on **the heap**.

::: notes

- Meanwhile on the other side of our memory the heap is an unstructured pile of
  data just waiting to be used. But how do we know what to use, when to use,
  when to stop using? We can't keep on adding more and more memory or we would
  run into a runaway memory leak quickly.
- Let's take a look how Rust solves working with the heap for us.

:::

---

# Variable Scoping (recap)

```rust
fn main() {
    // Enter stack frame.

    let i = 10; // `i` points to stack memory `s1`.

    if i > 5 {

        // Copy `i` to `j` (`s2` on stack frame)
        let j = i;
    }  // `j` no longer in scope,

    println!("i = {}", i);
} // i is no longer in scope
```

:::notes

- `i` and `j` are examples containing a `Copy` type.
- What if copying is too expensive?

:::

<!--
* When looking at how Rust solves working with the heap, we have to know a little
bit about variable scoping.
* In Rust, every variable has a scope, that is, a section of the code that that
variable is valid for. Note that this isn't that much different to other
programming languages.
* In our example we have `i` and `j`. Note how we can just create a copy by
assigning `i` to `j`.
* Here the type of i and j is actually known as a `Copy` type
* But sometimes there is data that would be way too much to Copy around every
time, it would make our program slow.
-->

---

<!---->
<!-- ## layout: four-square -->
<!---->
<!-- # Ownership -->
<!---->
<!-- ::topleft:: -->
<!---->
<!-- ```rust -->
<!-- let x = 5; -->
<!-- let y = x; -->
<!-- println!("{}", x); -->
<!-- ``` -->
<!---->
<!-- ::topright:: -->
<!---->
<!-- <div class="no-line-numbers"> -->
<!---->
<!-- <v-click> -->
<!---->
<!-- ```text -->
<!-- Compiling playground v0.0.1 (/playground) -->
<!-- Finished dev [unoptimized + debuginfo] target(s) in 4.00s -->
<!-- Running `target/debug/playground` -->
<!-- 5 -->
<!-- ``` -->
<!---->
<!-- </v-click> -->
<!---->
<!-- </div> -->
<!---->
<!-- ::bottomleft:: -->
<!---->
<!-- <v-click> -->
<!---->
<!-- ```rust -->
<!-- // Create an owned, heap allocated string -->
<!-- let s1 = String::from("hello"); -->
<!-- let s2 = s1; -->
<!-- println!("{}, world!", s1); -->
<!-- ``` -->
<!---->
<!-- </v-click> -->
<!---->
<!-- <v-click at="4"> -->
<!---->
<!-- Strings store their data on the heap because they can grow -->
<!---->
<!-- </v-click> -->
<!---->
<!-- ::bottomright:: -->
<!---->
<!-- <v-click at="3"> -->
<!---->
<!-- <div class="no-line-numbers"> -->
<!---->
<!-- ```text -->
<!-- Compiling playground v0.0.1 (/playground) -->
<!-- error[E0382]: borrow of moved value: `s1` -->
<!-- --> src/main.rs:4:28 -->
<!--   | -->
<!-- 2 |     let s1 = String::from("hello"); -->
<!--   |         -- move occurs because `s1` has type `String`, which does not implement the `Copy` trait -->
<!-- 3 |     let s2 = s1; -->
<!--   |              -- value moved here -->
<!-- 4 |     println!("{}, world!", s1); -->
<!--   |                            ^^ value borrowed here after move -->
<!-- ``` -->
<!---->
<!-- </div> -->
<!---->
<!-- </v-click> -->
<!---->
<!-- <!-- -->
<!-- * Let's take the previous example and get rid of some scopes, instead we are -->
<!-- just going to assign x to y, and then print both x and y. What do we think -->
<!-- is going to happen? -->
<!-- * Now the same example again, but now with a String, "hello", we are just going -->
<!-- to assign it to another variable and then print both s1 and s2. What do we -->
<!-- think is going to happen now? -->
<!-- * See how this time the compiler doesn't even let us run the program. Hold on, -->
<!-- what's going on here? -->
<!-- * Actually, in Rust strings can grow, that means that we can no longer store -->
<!-- them on the stack, and we can no longer just copy them around by re-assigning -->
<!-- them somewhere else. -->
<!-- --> -->
<!---->
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
