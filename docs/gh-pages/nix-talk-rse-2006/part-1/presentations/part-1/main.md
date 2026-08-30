---
title: Why reproducibility matters
pagetitle: Why reproducibility matters - A cure for your 7 page HowTo
subtitle: |
  A cure for your 7 page HowTo  <br>

author:
  - "**Almut Lütge**,
    [almut.luetge@sdsc.ethz.ch](mailto:almut.luetge@sdsc.ethz,ch)"
  - "**Gabriel Nützi**,
    [gabriel.nuetzi@sdsc.ethz.ch](mailto:gabriel.nuetzi@sdsc.ethz.ch)"
  - "**Cyril Matthey-Doret**,
    [cyril.matthey-doret@epfl.ch](mailto:cyril.matthey-doret@epfl.ch)"

notes: |

  - Why did we prepare this presentation?

    - We have been using Nix now successfully for some time in our team for
    development workflows/CI/packaging etc,
    - Some of us even run their laptops on NixOS to drive a deterministic/reproducible workflow.
    - Others "just" use basics, but collaborative development became much more efficient and fun.

    - The Nix technology solves a lot of headaches around the phrase "it works on my machine"
    but comes with a steeper learning curve.

    - To give something back to the OSS-community and to
    maybe bring more people into the Nix ecosphere, this talk tries to target the
    basic concepts and is accompanied by a other resources, e.g. last years workshop to get hands-on experience.

lang: en

date: |
  Aug 31st, 2026, [Repository](https://github.com/sdsc-ordes/nix-workshop), [Slides](https://sdsc-ordes.github.io/technical-presentation/gh-pages/nix-presentation/part-1)

css: presentations/part-1/css/custom.css
highlightjs-theme: railscasts
highlightjs-keywords:
  bash: ["nix", "curl", "python", "jq", "tree", "ldd", "nix-store", "dot"]

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
