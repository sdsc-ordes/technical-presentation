# Technical Presentation

[`Reveal.js`](https://github.com/hakimel/reveal.js.git) based presentations are
cool:

- Write with Markdown and HTML annotations.
- Style with SCSS (CSS).
- Use Code Highlighting and Animation.
- Versionize the presentation in Git.
- Use a `pandoc` first tooling approach which gives you lots of powers.
- and much more...

Note: These are speaker notes.

---

## Smart Presentation

### Smart Presentation

#### Smart Presentation

##### Smart Presentation

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

::: incremental

- _Carpe Diem_
- **b**) This is good.
- Inline Code `asd`
- [Links](http://coliru.stacked-crooked.com/)

:::

<br>

#### Code {.fragment}

::::::{.columns}

:::{.column width="50%" .fragment}

Normal:

```cpp
void foo(int a) {
  std::cout << "Hello. click!" << std::endl;
  std::vector<int>; v{1,2,4};
}
```

:::

:::{.column width="50%" .fragment}

Editable:

```cpp {contenteditable="true" line-numbers="|3-4|8-10" fragment-index="1,2"}
int a = 3;
void foo(int a) {
  std::cout << "Hello. click!" << 1 != 3 std::endl;
  std::vector<int>; v{1,2,4};
}
```

:::

::::::

---

### Code Focus

```cpp {line-numbers="1,2|3-8|all"}
int a = 3;
int a;
enum class C {A, B, C} b;
std::vector&lt;int&gt; c; // asd

int const * & const d;

using FuncPointer  = int (*)(float); // Type: Pointer to function.
using FuncReferenz = int (&)(float); // Type: Reference to function.
using Func =             int(float); // Type: Function.
```

::: incremental

- [Link 1](#/3/0/0)
- This is [important.]{.fragment}
- This is now important.

:::

---

### Long Code

```rust {line-numbers="14-22|39-45"}
use std::fs::File;
use std::io::{self, Read, Write};
use std::thread;
use std::sync::{Arc, Mutex};
use std::collections::HashMap;

// 1. Defining Structs and Methods
#[derive(Debug)]
struct Person {
    name: String,
    age: u32,
}

impl Person {
    fn new(name: String, age: u32) -> Self {
        Person { name, age }
    }

    fn greet(&self) {
        println!("Hello, my name is {} and I am {} years old.", self.name, self.age);
    }
}

// 2. Enum Example
#[derive(Debug)]
enum Status {
    Active,
    Inactive,
    Pending,
}

impl Status {
    fn describe(&self) -> &'static str {
        match *self {
            Status::Active => "Active",
            Status::Inactive => "Inactive",
            Status::Pending => "Pending",
        }
    }
}

// 3. Implementing Traits
trait Describable {
    fn describe(&self) -> String;
}

impl Describable for Person {
    fn describe(&self) -> String {
        format!("{} is {} years old", self.name, self.age)
    }
}

impl Describable for Status {
    fn describe(&self) -> String {
        format!("Status: {}", self.describe())
    }
}

// 4. Working with Result for Error Handling
fn read_file_content(file_path: &str) -> Result<String, io::Error> {
    let mut file = File::open(file_path)?;
    let mut content = String::new();
    file.read_to_string(&mut content)?;
    Ok(content)
}

// 5. Using HashMap and Collections
fn create_person_map() -> HashMap<String, Person> {
    let mut map = HashMap::new();
    map.insert("John".to_string(), Person::new("John".to_string(), 30));
    map.insert("Jane".to_string(), Person::new("Jane".to_string(), 25));
    map
}

// 6. Thread Example with Mutex and Arc
fn thread_example() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let h
```

---

## Funny Lua Filter

![](${meta:include-base-dir}/assets/images/diagram.svgbob){.svgbob}

---

## []{.emoji} Emoji Support

Emoji: <span></span>

---

## Disclaimer

Customized with ❤️ by Gabriel Nützi for SDSC.
