---
title: Rust Workshop 🦀
subtitle: |
  Part 2: Crate Engineering<br>

author:
  "**Gabriel Nützi**,
  [gabriel.nuetzi@sdsc.ethz.ch](mailto:gabriel.nuetzi@sdsc.ethz.ch)"

lang: en

date: |
  February 16, 2025, (updated June 11, 25)
  [Part 1](https://sdsc-ordes.github.io/technical-presentation/gh-pages/rust-workshop/part-1)

css: presentations/part-2/css/custom.css
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
include-base-dir: presentations/part-2

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
${meta:include-base-dir}/includes/2-create-engineering/main.md
```
