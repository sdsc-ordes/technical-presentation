# Technical Presentation

[`Reveal.js`](https://github.com/hakimel/reveal.js.git) based presentations are
cool:

- Write with Markdown and HTML annotations.
- Style with SCSS (CSS).
- Use Code Highlighting and Animation.
- Versionize the presentation in Git.
- and much more...

Note: These are speaker notes.

---

# Smart Presentation

## Smart Presentation

### Smart Presentation

#### Smart Presentation

---

## Code

```cpp
int a = 3;
void foo(int a){
    std::cout << "Hello. click!" << std::endl;
    std::vector<int> v{1,2,4};
}
```

---

### Markdown

- _Carpe Diem_
- **b**) This is good.
- Inline Code `asd`
- [Links](http://coliru.stacked-crooked.com/)
- **Code**:
  ```cpp
  void foo(int a) {
      std::cout << "Hello. click!" << std::endl;
      std::vector<int>; v{1,2,4};
  }
  ```
- **Editable Code:**
  ```cpp
  int a = 3;
  void foo(int a) {
      std::cout << "Hello. click!" << 1 != 3 std::endl;
      std::vector<int>; v{1,2,4};
  }
  ```
- Cool.
  <!-- .element: class="fragment" -->

---

### Code Focus

<pre>
  <code class="language-cpp stretch"
           data-trim contenteditable=true
           data-line-numbers="|3-4|8-10"
           data-fragment-index="1,2">
int a = 3;
int a;
enum class C {A, B, C} b;
std::vector&lt;int&gt; c; // asd

int const * & const d;

using FuncPointer  = int (*)(float); // Type: Pointer to function.
using FuncReferenz = int (&)(float); // Type: Reference to function.
using Func =             int(float); // Type: Function.
  </code>
</pre>

- [Link 1](#/3/0/0)
- This is important.
  <!-- .element: class="fragment" data-fragment-index="1" -->
- This is now important.
  <!-- .element: class="fragment" data-fragment-index="2" -->

---

# Disclaimer

Customized with ❤️ by Gabriel Nützi for SDSC.
