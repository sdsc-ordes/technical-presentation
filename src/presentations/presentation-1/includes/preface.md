<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026 -->

# Preface

> The Rust programming language absolutely positively sucks
> <sub>[Reedit](https://www.reddit.com/r/rust/comments/12b7p2p/the_rust_programming_language_absolutely)</sub>

::::::{.columns}

:::{.column width="50%" style="align-content:center"}

:::incremental

- **Python**: Runtime Mess 🐞 💣

- **Rust**: Compile-Time Mess 🔧 (deps. on your level of experience)

:::

:::

:::{.column width="50%"}

<p class="center-content">
![](${meta:include-base-dir}/assets/images/rust-muscle-crab.jpg){style="width:400px"
.border-dark}
</p>

:::

::::::

::: notes

Hello everyone, and a warm welcome to this Rust workshop! I'm thrilled to see
that Rust has sparked such interest within our team, and that you're eager to
dive into this language. I’ve designed the first part of this presentation with
a focus on the Python ecosystem, since Python is widely used here at SDSC and is
likely your go-to language.

My goal is that by the end of this workshop, you'll not only have a new
perspective on Python but also develop a genuine appreciation for Rust. I've put
together a self-contained learning course with now 200 slides and about 10
exercises for the core concepts to build a strong foundation. While it might
seem like a lot, I believe it's important to thoroughly understand the core
concepts rather than just picking them up on the fly, which can be more
challenging—especially if you're primarily experienced with Python, where many
computer-science related things are hidden under the hood.

We'll start with the basics and gradually move on to more advanced topics. Where
we finish will depend on your interests, and I can tell you now, we definitely
won't wrap up in just two days!

A disclaimer before we start: I hope and expect that your perspective on Python
will shift towards the negative end =). There is to say that Rust is not a
silver-bullet. Its a complicated language with a steep learning curve and also
has its quirks and dark spots. We can abbreviate Python more or less like
"Run-Time Mess" and Rust with "Compile-Time Mess".

Rusts mascot by the way is called Ferris the Crab because some Rust developers
call themself Rustoceans. I let AI generate Ferris with super powers, thats what
it spit out =)

OK, its a bit intimidating.

:::

---

## How I Learned?

::: {.center-content}

<iframe width="840" height="472" src="https://www.youtube.com/embed/qZvKNIiBiw4?si=L6Hqc-9qke9qTOKX" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

:::

::: notes

I learned Rust the hard-way by just raw-dogging a 'simple' fluid simulation. I
had experience from C++, but even with that it was not a quite smooth learning
curve as I just pumped into all sorts of concepts which I had to read up on and
was not so familiar with, such as "how the heck move semantics work in Rust
compared to C++". Nowadays I feel, especially with targeting Python, it makes
more sense to learn first the basics and concepts. And that's what I like to
target in this a workshop.

Without further ado: Lets dive into the Rustocean.

:::
