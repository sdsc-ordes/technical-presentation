<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Why Rust

---

## What the Heck is Rust 🦀

### A Multi-Paradigm Language

- procedural like Python, i.e. _functions_ 󰊕, _loops_ 󰑙, ...
- functional aspects, i.e. _iterators_ 🏃, _lambdas_ 󰡱 ...
- object-oriented aspects but unlike Python ( its better ❤️)

---

## What the Heck is Rust 🦀

#### A **Compiled** Language Unlike Python

- The Rust compiler `rustc` 🦀 will convert your code to machine-code ⚙️. <br>
  Python is an interpreter.

- It has a **strong type system** ([algebraic types](TODO): sum types, product
  types).

- It was invented in 2009 by Mozilla (Firefox) - Rust Foundation as the driver
  today.

Note: 10% of Firefox is in Rust for good reasons you will realize in the
following.

---

## Benefits You Get on the 🦀 Journey

A few selling points for `python` programmers.

---

## Come on 🐨 show me syntax!

The syntax\* is similar and as easy to read as in Python.

<!-- prettier-ignore-start -->

:::::: {.columns}
::: {.column width="50%"}

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

:::
::: {.column width="50%"}

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

:::
::::::
<!-- prettier-ignore-end -->

\*: 80% you will encounter is very readable (except macros etc.).

---

## But Why?

<h3>
  More reasons why you should learn a <em class="emph">compiled, statically typed</em> </span>language...
</h3>

---

### What Rust Promises 🤚

::: incremental

:::{.center-content}

1. **Pedal to the metal**
2. **Comes with a warranty**
3. **Beautiful code**
4. **Rust is practical**

:::

:::

---

## Pedal to The Metal

::: incremental

- Compiled language, not interpreted.

- State-of-the-art machine-code generation using LLVM.

- No garbage collector (GC) getting in the way of execution.

  ```python {line-numbers=}
  def run():
    d = { "a":1, "b":2 } # Memory is allocated on the heap.

  run()
  ```

  **Question:** Does the memory of `d` still exist after `run()`?

  [ We don't know 🤷]{.fragment}

- Usable in embedded devices, operating systems and demanding websites.

:::

::: notes

Explain what a garbage collector does explain what the heap/stack are later.

:::

---

## Rust Comes with a Warranty

::: incremental

- Strong type system helps prevent silly bugs 🐞:

  ```python
  def concat(numbers: List[str]) -> str:
    return "-".join(numbers)

  concat(["1", "2", "30", 4, "5", "7", "10"])
  ```

- Explicit errors instead of exceptions ❗([later](TODO)):

  ```python
  def main():
    file_count = get_number_of_files()
    if file_count is None:
      print("Could not determine file count.")
  ```

  [**Question:** Is this error handling correct if: <br>
  `get_number_of_files = lambda: int(sys.argv[0])`{.python}]{.fragment}

:::

---

## Rust Comes with a Warranty

::: incremental

- **Ownership Model**: Type system tracks lifetime of objects.

  - No more exceptions about accessing `None`.
  - You know who owns an objects (variable/memory).

- Programs don't trash your system accidentally
  - Warranty _can_ be voided (`unsafe`).

:::

::: notes

Throws two exceptions: `ValueError` and `TypeError`. **Ownership Model**: Strict
rules on how memory is managed and shared  Safe Code 🦺. (<small>Note:
variables bind to memory</small>)

:::

---

## Rust Comes with a Warranty

**Experience: <span class="emph">_"♥️ If it compiles, it is more often correct.
♥️"_</span>**

::: incremental

- Enables
  [compiler driven development](https://www.youtube.com/watch?v=Kdpfhj3VM04).

- 100% code coverage:

  :::::: {.columns}

  ::: {.column width="50%" .fragment}

  Python:

  ```python {.smaller-code}
  def get_float(num: str | float) -> float:
    match (num):
        case str(num):
            return float(num)
  ```

  _You trust `mypy` which is not enforced on runtime._

  :::

  ::: {.column width="50%" .fragment}

  Rust:

  ```rust {.smaller-code}
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

  :::

  ::::::

:::

::: notes

Rust allows quite a different programming experience. It's called **compiler
driven development** (e.g. guard your business logic with the type-system at
your hand, e.g. type-state pattern. I explain threads later. Certain statements
allow `rustc` to check that you covered all cases. Python: With power comes
responsibility. Python is very dynamic, but this duck-typing and non-strictness
results often in a mess.

:::

---

## Rust Comes with a Warranty

**Experience: <span class="emph">_"♥️ If it compiles, it is more often correct.
♥️"_</span>**

- No invalid syntax.
- Guaranteed thread safety.
- Model your business logic with `struct` and `enums`.

---

## Performance

::: incremental

- Rust is **fast** 🚀. Comparable to C++/C, faster than `go`.

  - _Python is slow, that's why most libraries outsource to C or
    [`Rust`](https://github.com/PyO3/pyo3)._

- Rust is **concurrent** ⇉ by design _(safe-guarded by the ownership model)_.

  - Python has an [interpreter lock (GIL)](https://realpython.com/python-gil/)
    which prohibits proper threading
    ([it gets removed](https://www.lesinskis.com/python-GIL-removal.html)).

:::

---

## Why Should 🫵 Learn Rust?

::: incremental

- Learning a new language teaches you new tricks:

  - You will also write better code (also in Python)!

- Rust is a young, but a quickly growing platform:
  - You can help shape its future.
  - Demand for Rust programmers will increase!

:::
