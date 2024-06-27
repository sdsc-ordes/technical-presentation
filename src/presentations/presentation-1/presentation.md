<!-- markdownlint-disable-file MD034 MD033 MD001 -->

# Rust Workshop 🦀

### Part 1: From Python to Rust & Basics

**Author:** Gabriel Nützi, gabriel.nuetzi@sdsc.ethz.ch <br>

Review:

Note: With focus from python to rust.

---

# What the Hack is Rust 🦀

- It's multi-paradigm language:

  - procedural like Python (functions, loops, ...)
  - functional aspects like iterators, lambdas (closures) etc.
  - object-oriented aspects but unlike Python ( :heart:)

- It's a **compiled** language unlike Python:

  - It has a strong type system ([algebraic types](TODO)).
  - The Rust compiler `rustc` will convert your code to machine-code. Python is
    an interpreter.

- It was invented in 2009 by Mozilla (Firefox) - Rust Foundation as the driver
  today.

Note: 10% of Firefox is in Rust for good reasons you will realize in the
following.

---

# Why Rust

## Benefits you get when going on the 🦀 - Journey

A few selling points for `python` programmers.

---

# Come on... show me some syntax!

The syntax\* is as easy to read as in Python.

<!-- prettier-ignore-start -->

<div class="columns">
<div class="column">

```rust
struct Apple {
  name: String
}

fn grow() -> Vec<Apple> {

  let apples = vec![Apple{"a"},
                    Apple{"b"}];

  for b in apples {
    println!("Apple: {b:?}");
  }

  return apples
}
```

</div>
<div class="column">

```python
@dataclass
class Apple:
  name: str

def grow() -> List[Apple]:

  apples = [Apple("a"),
            Apple("b")]

  for b in apples:
    print(f"Apple: {b.name}")


  return apples


```

</div>
</div>

\*: 80% you will encounter is very readable. Macros etc. get verbose and bit
harder.

---

# But Why?

<h3>
  More reasons why you should learn a <span style="color:lightgreen"><em>compiled, statically typed</em> </span>language...
</h3>

---

## 2. Memory Safety

- **Safe Memory Management**: Rust prevents common programming errors related to
  memory, such as null pointer dereferencing, buffer overflows, and data races.
  This reduces bugs and security vulnerabilities in software development.
- **Ownership Model**: Rust’s ownership model enforces strict rules on how
  memory is managed and shared, which can help Python programmers write safer
  and more robust code.

---

### Performance

- **Speed**: Rust is **fast** 🚀. Same or faster then `C`.

  _Python is slow, that's why most libraries outsource to `C` or
  [`Rust`](https://github.com/PyO3/pyo3)._

- **Concurrency**: Rust is concurrent by design, safe-guarded by the ownership
  model (later).

---

## 3. Interoperability

- **FFI (Foreign Function Interface)**: Rust can be integrated with Python
  through libraries like PyO3 and Rust-CPython, allowing Rust code to be called
  from Python. This enables Python developers to leverage Rust’s performance and
  safety in existing Python applications.

## 4. Expanding Skill Set

- **Low-Level Systems Programming**: Learning Rust provides insights into
  low-level programming concepts and systems programming. This can deepen a
  programmer’s understanding of how computers work, improving their overall
  programming proficiency.
- **Versatility**: Adding Rust to a programmer’s toolkit enhances their
  versatility, making them more valuable in the job market. They can tackle a
  wider range of problems, from web development to systems programming.

## 5. Modern Language Features

- **Error Handling**: Rust has a robust error handling mechanism with the
  `Result` and `Option` types, which encourages developers to write more
  reliable and maintainable code.
- **Pattern Matching**: Rust’s powerful pattern matching and type system can
  inspire Python programmers to adopt more expressive and clean coding
  practices.

## 6. Community and Ecosystem

- **Growing Community**: Rust has a rapidly growing community and ecosystem.
  Engaging with this community can provide learning opportunities and access to
  a wealth of libraries and tools.
- **Active Development**: Rust is under active development with strong support
  from companies like Mozilla. This ensures it will continue to evolve and
  improve, providing long-term value for those who invest time in learning it.

## 7. Complementary Strengths

- **Python for Rapid Development, Rust for Performance**: Python is excellent
  for rapid development and prototyping, while Rust excels in performance and
  safety. Combining the strengths of both languages can lead to more effective
  and efficient software development practices.

In summary, learning Rust can help Python programmers write faster, safer, and
more efficient code, while also broadening their programming expertise and
enhancing their career opportunities.

<!-- [`Reveal.js`](https://github.com/hakimel/reveal.js.git) based presentations are -->
<!-- cool: -->
<!---->
<!-- - Write with Markdown and HTML annotations. -->
<!-- - Style with SCSS (CSS). -->
<!-- - Use Code Highlighting and Animation. -->
<!-- - Versionize the presentation in Git. -->
<!-- - and much more... -->
<!---->
<!-- Note: These are speaker notes. -->
<!---->
<!-- --- -->
<!---->
<!-- # Smart Presentation -->
<!---->
<!-- ## Smart Presentation -->
<!---->
<!-- ### Smart Presentation -->
<!---->
<!-- #### Smart Presentation -->
<!---->
<!-- --- -->
<!---->
<!-- ## Code -->
<!---->
<!-- ```cpp -->
<!-- int a = 3; -->
<!-- void foo(int a){ -->
<!--     std::cout << "Hello. click!" << std::endl; -->
<!--     std::vector<int> v{1,2,4}; -->
<!-- } -->
<!-- ``` -->
<!---->
<!-- --- -->
<!---->
<!-- ### Markdown -->
<!---->
<!-- - _Carpe Diem_ -->
<!-- - **b**) This is good. -->
<!-- - Inline Code `asd` -->
<!-- - [Links](http://coliru.stacked-crooked.com/) -->
<!-- - **Code**: -->
<!--   ```cpp -->
<!--   void foo(int a) { -->
<!--       std::cout << "Hello. click!" << std::endl; -->
<!--       std::vector<int>; v{1,2,4}; -->
<!--   } -->
<!--   ``` -->
<!-- - **Editable Code:** -->
<!--   ```cpp -->
<!--   int a = 3; -->
<!--   void foo(int a) { -->
<!--       std::cout << "Hello. click!" << 1 != 3 std::endl; -->
<!--       std::vector<int>; v{1,2,4}; -->
<!--   } -->
<!--   ``` -->
<!-- - Cool. -->
<!--   <!-- .element: class="fragment" --> -->
<!---->
<!-- --- -->
<!---->
<!-- ### Code Focus -->
<!---->
<!-- <pre> -->
<!--   <code class="language-cpp stretch" -->
<!--            data-trim contenteditable=true -->
<!--            data-line-numbers="|3-4|8-10" -->
<!--            data-fragment-index="1,2"> -->
<!-- int a = 3; -->
<!-- int a; -->
<!-- enum class C {A, B, C} b; -->
<!-- std::vector&lt;int&gt; c; // asd -->
<!---->
<!-- int const * & const d; -->
<!---->
<!-- using FuncPointer  = int (*)(float); // Type: Pointer to function. -->
<!-- using FuncReferenz = int (&)(float); // Type: Reference to function. -->
<!-- using Func =             int(float); // Type: Function. -->
<!--   </code> -->
<!-- </pre> -->
<!---->
<!-- - [Link 1](#/3/0/0) -->
<!-- - This is important. -->
<!--   <!-- .element: class="fragment" data-fragment-index="1" --> -->
<!-- - This is now important. -->
<!--   <!-- .element: class="fragment" data-fragment-index="2" --> -->
<!---->
<!-- --- -->
<!---->
<!-- # Disclaimer -->
<!---->
<!-- Customized with ❤️ by Gabriel Nützi for SDSC. -->

<!-- markdownlint-restore-->
