---
title: Rust Workshop 🦀
subtitle: "Part 1: From Python to Rust & Basics"

author:
  "**Gabriel Nützi**,
  [gabriel.nuetzi@sdsc.ethz.ch](mailto:gabriel.nuetzi@sdsc.ethz.ch)"

lang: en

date: August 14, 2024

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

```{.include}
${meta:include-base-dir}/includes/preface.md
${meta:include-base-dir}/includes/help.md
${meta:include-base-dir}/includes/acknowledgement.md
${meta:include-base-dir}/includes/links.md
${meta:include-base-dir}/includes/intro.md
${meta:include-base-dir}/includes/1-foundation/main.md
```
