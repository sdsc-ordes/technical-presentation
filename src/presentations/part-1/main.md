---
title: Nix Workshop 
subtitle: |
  Part 1: Nix, Flakes & Nix DevShell<br>

author:
  - "**Gabriel Nützi**,
    [gabriel.nuetzi@sdsc.ethz.ch](mailto:gabriel.nuetzi@sdsc.ethz.ch)"
  - "**Cyril Matthey-Doret**,
    [cyril.matthey-doret@epfl.ch](mailto:cyril.matthey-doret@epfl.ch)"

lang: en

date: |
  May 8, 2025, [Repository](https://github.com/sdsc-ordes/nix-workshop)

css: presentations/part-1/css/custom.css
highlightjs-theme: railscasts
highlightjs-keywords:
  bash: ["nix", "cat", "jq"]

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
${meta:include-base-dir}/includes/2-create-engineering/main.md
```
