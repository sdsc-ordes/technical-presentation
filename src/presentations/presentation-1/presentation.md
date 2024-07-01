<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Rust Workshop 🦀

### Part 1: From Python to Rust & Basics

**Author:** Gabriel Nützi, gabriel.nuetzi@sdsc.ethz.ch <br>

Review:

Note: With focus from python to rust.

---

# What the Hack is Rust 🦀

#### A Multi-Paradigm Language

- procedural like Python, i.e. _functions_ 󰊕, _loops_ 󰑙, ...
- functional aspects, i.e. _iterators_ 🏃, _lambdas_ 󰡱 ...
- object-oriented aspects but unlike Python ( its better ❤️)

---

# What the Hack is Rust 🦀

#### A **Compiled** Language Unlike Python

- The Rust compiler `rustc` 🦀 will convert your code to machine-code ⚙️. Python
  is an interpreter.

- It has a **strong type system** ([algebraic types](TODO): sum types, product
  types).

- It was invented in 2009 by Mozilla (Firefox) - Rust Foundation as the driver
  today.

Note: 10% of Firefox is in Rust for good reasons you will realize in the
following.

---

# Why Rust

## Benefits you get when going on the 🦀 - Journey

A few selling points for `python` programmers.

---

## Come on 🐨 show me syntax!

The syntax\* is similar and as easy to read as in Python.

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

\*: 80% you will encounter is very readable. Macros implementation code etc. get verbose and much
harder.

---

# But Why?

<h3>
  More reasons why you should learn a <em class="emph">compiled, statically typed</em> </span>language...
</h3>

---

### What Rust Promises 🤚

<div class="center-content">

1. **Pedal to the metal**
2. **Comes with a warranty**
3. **Beautiful code**
4. **Rust is practical**

</div>


---

# Pedal to The Metal

- Compiled language, not interpreted.

- State-of-the-art machine-code generation using LLVM.

- No garbage collector (GC) getting in the way of execution.

  ```python
  def run():
    d = { "a":1, "b":2 } # Memory is allocated on the heap.

  run()
  ```
 
  **Question:** Does the memory of `d` still exist at `run()`?
  
     We don't know 🤷 <!-- .element: class="fragment"-->



- Usable in embedded devices, operating systems and demanding websites.

Note: Explain what a garbage collector does explain what the heap/stack are later.

---

## Rust Comes with a Warranty

- Strong type system helps prevent silly bugs 🐞:

  ```python
  def concat(numbers: List[str]) -> str:
    return "-".join(numbers)

  concat(["1", "2", "30", 4, "5", "7", "10"])
  ```

- Explicit errors instead of exceptions ❗([later](TODO)):

  ```python
  # Is this error handling correct?
  def main():
    file_count = get_number_of_files()
    if file_count is None:
      print("Could not determine file count.")
  ```

  <code class="python hjls language-python">get_number_of_files = lambda:
  int(sys.argv[0])</code>

  `asdf` 

---

## Rust Comes with a Warranty

- **Ownership Model**: Type system tracks lifetime of objects.

  - No more exceptions about accessing `None`.
  - You know who owns an objects (variable/memory).

- Programs don't trash your system accidentally
  - Warranty _can_ be voided (`unsafe`).

Note: Throws two exceptions: `ValueError` and `TypeError`. **Ownership Model**:
Strict rules on how memory is managed and shared  Safe Code 🦺. (<small>Note:
variables bind to memory</small>)

---

## Rust Comes with a Warranty

**Experience: <span class="emph">_"♥️ If it compiles, it is more often correct.
♥️"_</span>**

Enables
[compiler driven development](https://www.youtube.com/watch?v=Kdpfhj3VM04):

- 100% code coverage:
<!-- prettier-ignore-start -->

<div class="columns">
<div class="column" style="float: left; width:50%;">

  ```python
  def get_float(num: str | float):
    match (num):
        case str(num):
            return float(num)
  ```

  <!-- .element: style="font-size:14pt"-->

  *You trust `mypy` which is not enforced on runtime.*

</div>
<div class="column" style="float: right; width:50%;">

  ```rust
  enum StrOrFloat { 
    MyStr(String), 
    MyFloat(f64),
  }

  fn get_float(n: StrOrFloat) -> f64 {
      match n {
          StrOrFloat::MyFloat(x) => x, 
      }
  }
  ```
  <!-- .element: style="font-size:14pt"-->

</div>
</div>

<!-- prettier-ignore-end -->

- No invalid syntax.
- Guaranteed thread safety.
- Model your business logic with `struct` and `enums`.

Note: Rust allows quite a different programming experience. It's called
**compiler driven development** (e.g. guard your business logic with the
type-system at your hand, e.g. type-state pattern. I explain threads later.
Certain statements allow `rustc` to check that you covered all cases. Python:
With power comes responsibility. Python is very dynamic, but this duck-typing
and non-strictness results often in a mess.

---

## Performance

- Rust is **fast** 🚀. Comparable to C++/C, faster than `go`.

  _Python is slow, that's why most libraries outsource to C or
  [`Rust`](https://github.com/PyO3/pyo3)._

- Rust is **concurrent** ⇉ by design _(safe-guarded by the ownership model)_.
  Python has an [interpreter lock (GIL)](https://realpython.com/python-gil/) which prohibits proper threading.

---

## Why Should 🫵 Learn Rust?

- Learning a new language teaches you new tricks:

  - You will also write better Python code!

- Rust is a young, but a quickly growing platform:
  - You can help shape its future.
  - Demand for Rust programmers will increase!

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

```

```
