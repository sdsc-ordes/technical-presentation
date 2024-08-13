---
title: Rust Workshop 🦀
subtitle: "Part 1: From Python to Rust & Basics"

author:
  "**Gabriel Nützi**,
  [gabriel.nuetzi@sdsc.ethz.ch](mailto:gabriel.nuetzi@sdsc.ethz.ch)"

lang: en

date: July 15, 2024

css: presentations/presentation-1/css/custom.css
highlightjs-theme: railscasts
highlightjs-keywords:
  bash: ["cargo", "rustc"]

# Filter: pandoc-crossref
figureTitle: |
  Fig.

# Filter: pandoc-svgbob
svgbob:
  font-size: 20
  scale: 1.5

# Filter: `pandoc-include-files` filter
# The base include dir inside the `build` dir.
include-base-dir: presentations/presentation-1

# Output Writer Settings: RevealJS
controls: true
navigationMode: linear
progress: true
history: true
center: true
fragmentInURL: true
mouseWheel: false
slideNumber: \'c/t\'
transition: fade
width: 1200
height: 700
margin: 0.05
minScale: 0.1
maxScale: 2
pdfSeparateFragments: false
hideInactiveMouse: true
hideMouseTime: 1000
hash: true
---

<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026 -->

> The Rust programming language absolutely positively sucks
> <sub>[Reedit](https://www.reddit.com/r/rust/comments/12b7p2p/the_rust_programming_language_absolutely)</sub>

:::incremental

- **Python**: Runtime Mess
- **Rust**: Compile-Time Mess (depending on your level of experience)

:::

<p class="center-content">
![](${meta:include-base-dir}/assets/images/rust-muscle-crab.jpg){style="width:400px"
.border-dark}
</p>

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

Without further ado, lets dive in.

:::

```{.include}
${meta:include-base-dir}/includes/help.md
${meta:include-base-dir}/includes/acknowledgement.md
${meta:include-base-dir}/includes/links.md
${meta:include-base-dir}/includes/intro.md
${meta:include-base-dir}/includes/1-foundation/main.md
```
