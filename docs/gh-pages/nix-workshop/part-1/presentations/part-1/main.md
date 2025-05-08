---
title: Nix Workshop 
subtitle: |
  Part 1: Nix, Flakes & Nix DevShell<br>

author:
  - "**Gabriel Nützi**,
    [gabriel.nuetzi@sdsc.ethz.ch](mailto:gabriel.nuetzi@sdsc.ethz.ch)"
  - "**Cyril Matthey-Doret**,
    [cyril.matthey-doret@epfl.ch](mailto:cyril.matthey-doret@epfl.ch)"

notes: |
  - Welcome ...

  - As we have been using Nix for quite a while now, in quite some repositories
    (I would say to a successful extent), I have been deploying a Gitlab Runner VM
    with Nix etc, I thought its now a good time to give you some more terminology
    and explanations what Nix is, what a flake is and what the hack a DevShell is.

  - This will be structured possibly in two parts 1, since when I prepared the slides
    from the Markdown write-up I figured out it needs some more examples/explanations.
    So we do the first part today, or at least try which should give you
    some better understanding of what Nix does for you.

  - So I hope after this presentation you will be a bit more prepped towards working with
    this tool. Not to say its rather a methodology than a tool!

  - It's good to keep this slides open next to you during the presentation, as
    I will give you some time to checkout the examples your-self,
    so you can directly copy paste.

lang: en

date: |
  May 8, 2025, [Repository](https://github.com/sdsc-ordes/nix-workshop), [Slides](https://sdsc-ordes.github.io/technical-presentation/gh-pages/nix-workshop/part-1)

css: presentations/part-1/css/custom.css
highlightjs-theme: railscasts
highlightjs-keywords:
  bash: ["nix", "curl"]

# Filter: pandoc-crossref
fgureTitle: |
  Fig.

# Filter: pandoc-svgbob
svgbob:
  font-size: 20
  scale: 1.5

# Filter: `pandoc-include-files` filter
# The base include dir inside the `build` dir.
include-base-dir: presentations/part-1

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

```{.include}
${meta:include-base-dir}/includes/help.md
${meta:include-base-dir}/includes/acknowledgement.md
${meta:include-base-dir}/includes/intro.md
```
