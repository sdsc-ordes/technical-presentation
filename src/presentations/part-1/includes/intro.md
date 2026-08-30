<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Resources

Slides and the original workshop can be found here:

::::::{.columns}

:::{.column width="50%" style="text-align:center;"}

[Slides](https://sdsc-ordes.github.io/technical-presentation/gh-pages/nix-workshop/part-1)<br>
![](${meta:include-base-dir}/assets/images/qr-tag-slides.svg){height="8em"}

:::

:::{.column width="50%" style="text-align:center;"}

[Workshop Repository](https://github.com/sdsc-ordes/nix-workshop)<br>
![](${meta:include-base-dir}/assets/images/qr-tag-repo.svg){height="8em"}

:::

::::::

# Motivation

## Install Dependecies = Good Luck 🤞🏼

<iframe src="presentations/part-1/assets/pytorch-site/index.html" width="100%" height="500" style="border:1px solid #ccc; border-radius:5pt"></iframe>

---

##  Why Nix?

You start `python` and you get this:

```bash
>>> import numpy
Segmentation fault (core dumped)
```

:::notes

Importing a package like `numpy` in python is not a trivial task as you might
expect. `Numpy` heavily depends on build shared object files on your system,
such as `LAPACK`, `BLAS`, which it tries to load when you import `python`.

The error above is hard to identify, it might be due to misalignment of system
libraries with your python environment etc.

This will not happen with Nix, never!.

But you might ask, what is with `conda` or `devcontainers` or `mamba`? They
resolve these issues right?

:::

---

### 💣 It Works on My Machine

[![](${meta:include-base-dir}/assets/images/it-works-on-my-machine.jpg){width="30%"}]{.center-content}

::: notes

Developer environments have become increasingly more complicated and the least
what we want is to be stuck in the land of `it works on my machine`.

Lets look at some technology which claim to setup reproducible developer
environments.

:::

---

### Sure, but it is useful ...

[![](${meta:include-base-dir}/assets/images/docker.jpg){width="50%"}]{.center-content}

::: notes

I used to think that the whole "docker is not reproducible" debate is something rather academic, because docker was/is the defacto standard in the community and very useful.

Nix does not challenge the use of container, but prevents you from "misusing" them. Contraily nix can help to make container reproducibile AND let's you work locally in the same environment as you ship inside the container.

It is not about nix vs. docker, but about the best tool for each task.

:::

---

### 🧪 Development Setups

<br>

:::{style=""}

| Feature          | Local Development | [Mamba](https://mamba.readthedocs.io) | [Devcontainer](https://containers.dev/implementors/spec/) | [Nix/DevShell](https://www.youtube.com/watch?v=yQwW8dkuHqw) |
| ---------------- | ----------------- | ------------------------------------- | --------------------------------------------------------- | ----------------------------------------------------------- |
| Maintenance      | ⚠️ **High**       | ⚠️ Medium                             | ⚠️ Medium                                                 | ⚠️ Medium                                                   |
| Reproducibility  | ❌ Low            | ⚠️ Medium                             | ⚠️ Medium                                                 | ✅ **Very high**                                            |
| Ease of Use      | ❌ Low            | ✅ Easy                               | ✅ Ok                                                     | ❌ Low                                                      |
| Dep. Mgmt.       | ❌                | ✅                                    | ⚠️                                                        | ✅                                                          |
| Portability      | 💣                | ⚠️                                    | ✅                                                        | ✅                                                          |
| **CI Stability** | 💣                | ⚠️                                    | ⚠️                                                        | ✅ **Almost Perfect**                                       |

:::

[Full Table](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/dev-env)

:::notes

This table shows the comparison between different technologies for setting up
development environment. There exists many more of course. This chart is maybe
more for people using python setups.

The main I want to highlight here is that with a local development you obviously
dont get any benefit. You cannot reproduce anything and you are stuck in the
land of `it works on my machine`.

Also they are sometimes used together and mixed back and forth. So people might
use the `brew` package manager on macOS to install some stuff, then at the same
time use `mamba` or `conda` to install some better managed python environments,
and might interleave that with a `.devcontainer` etc. This is even more complex
and you can get rid of all this complexity once you have understood what Nix can
give you, which a lot of package managers try to solve but they don't or cannot
do it proper from the start.

:::

#  What is **Nix**?

---

## Nix started 2006 ...

:::::::::{.columns}

:::{.column width="50%" }

![[Eelco Dolstra's PhD Thesis](https://edolstra.github.io/pubs/phd-thesis.pdf)](${meta:include-base-dir}/assets/images/phd-thesis.png){.border-light
width="70%"}

:::

:::{.column width="50%" .fragment}

![](${meta:include-base-dir}/assets/images/nix-explanation-meme.jpg){.border-light
height="70%"}

:::

::::::

::: notes

Starting the Nix journey from 2006 with Eelco Dolstra's Phd might not be the
best idea, not because of the thesis. But immediately jumping into academic and
dense vocabulary about the ideas and technology that powers Nix might
immediately turn off potential new Nix-enthusiasts.

:::

---

##  The **Nix** Ecosystem

Main projects related to **Nix**:

::: incremental

- 🎁 **Nix(Package Manager)**: Turns a configuration into a software application.

- 💬 **Nix(Programming Language)**: Functional programming language to write a software/system configuration.

- 📦 **Nixpkgs**: Standard library for Nix + build functions for >130k packages.

- 💻 **NixOS**: Declarative Linux distribution.

:::

::: notes
One of the confusions derives from the same name being used for different parts of the nix ecosystem:
There is the Nix package manager, that similar to other package manager install software packages and handles different versions. It comes with a cli (similar to e.g. uv, but will mostly be handled in your workflows directly).

In addition there is Nix the programming language - a functional programming language made for declarative software design. It has a steep learning curve, but provides a lot of power to use nix packages and its concepts beyond the usual depenendcy management.

:::

---

## Nix Basics

### Same, same, but different! 🧙‍♀️

::: notes

Some of the concepts will probably sound familiar to you (e.g. lock files for dependency pinning), but nix goes beyond that scope, resulting in something that feels very different.

:::

---

## Example: A Simple Shell Script.

I am building a script to find my IP:

```bash {.fragment}
#! /usr/bin/env bash
curl -s http://ipinfo.io | jq --raw-output .ip
```

```shell {.fragment data-id="code-animation"}
12.24.14.88
```

::: {.fragment}

**What guarantees that `jq` or `curl` is available?**

:::

:::notes

We have all written such innocuous tooling scripts like that for example to
accomplish some tasks in a software repository or even for CI.

- click

The problem with this script comes first when you need to guarantee that the
tools you use in the script are available and that they work.

Lets have a look at how Nix would do that if you want to build a reproducible
version of that script.

:::

---

## Package It with Nix (1)

```nix {line-numbers="2-11|13-15" style="font-size:14pt"}
let
  system = builtins.currentSystem; # e.g. `x86_64-linux`

  # Download something into the `/nix/store/...-source`
  src = builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/9684b53175fc6c09581e94cc85f05ab77464c7e3.tar.gz";

  # Import the `default.nix` in the `/nix/store/...-source`
  f = import src;

  pkgs = f { inherit system; }; # This is the package attribute set of `nixpkgs`.
in
pkgs.writeShellScriptBin "what-is-my-ip" ''
  ${pkgs.curl}/bin/curl -s http://ipinfo.io | \
    ${pkgs.jq}/bin/jq --raw-output .ip
''
```

:::notes

Before we go through what each line here does in detail, let's check the output of what it generates.

:::

---

## Package It with Nix (2)

Building this Nix code gives you a store path:

```bash
nix build -f ./examples/what-is-my-ip.nix --print-out-paths

> "/nix/store/7x9hf9g95d4wjjvq853x25jhakki63bz-what-is-my-ip"
```

::: {.fragment}

which contains the script and all needed dependencies

```bash {line-numbers="|1,3,5" }
#!/nix/store/mc4485g4apaqzjx59dsmqscls1zc3p2w-bash-5.2p37/bin/bash

/nix/store/zl7h70n70g5m57iw5pa8gqkxz6y0zfcf-curl-8.12.1-bin/bin/curl \
  -s "http://ipinfo.io" | \
  /nix/store/y50rkdixqzgdgnps2vrc8g0f0kyvpb9w-jq-1.7.1-bin/bin/jq \
    --raw-output ".ip"
```

:::

[Nix has encoded the used executables with **store paths**
(`/nix/store`).]{.fragment}

:::notes

Do not think you can now simply share this script by giving the contents of
directory `/nix/store/7x9hf9g95d4wjjvq853x25jhakki63bz-what-is-my-ip` to
somebody else and it will work. This is not sufficient as we need the other
derivations as well. This is done differently namely over Nix itself, because
Nix has all information (`nix copy`).

You might ask now Jeah, ok these paths are just in the `/nix/store`, what is it
any good? Its just how other package manager would store the binaries somewhere
for a tool like `jq`.

But thats only the partial story what Nix does differently. Lets look into it.

:::

---

## What Is This Hash ?

::::::{.columns}

:::{.column width="70%" style="align-content:center"}

```bash
/nix/store/7x9hf9g95d4wjjvq853x25jhakki63bz-what-is-my-ip
```

::: {.fragment}

The hash `7x9hf9g95d4wjjvq853x25jhakki63bz` of your built package **depends
on**:

::: incremental

- source code of the package (the bash script)
- dependencies down to the commit level (`curl`, `jq`)
- all build instructions (`nix` code, including dependencies)

:::

:::

[**⛓️ Deterministic software packaging.**]{.fragment}

:::

:::{.column width="30%" .fragment}

![](${meta:include-base-dir}/assets/images/fractal.gif){width="100%"
.border-light}

:::

::::::

:::notes

We see that Nix does some hashing here for the stuff it puts in the
`/nix/store`.

Seeing such a hash in Nix is an extremely strong guarantee of the software graph
down to the commit and build instructions.

- click

Nix accomplishes that with the Nix language.

:::

---

## Package It with Nix (3)

Getting back to: [`whats-is-my-ip.nix`](https://github.com/sdsc-ordes/nix-workshop/blob/main/examples/what-is-my-ip.nix):

```nix {line-numbers="2|4-6|8-9|11|13-16" style="font-size:14pt"}
let
  system = builtins.currentSystem; # e.g. `x86_64-linux`

  # Download something into the `/nix/store/...-source`
  src = builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/9684b53175fc6c09581e94cc85f05ab77464c7e3.tar.gz";

  # Import the `default.nix` in the `/nix/store/...-source`
  f = import src;

  pkgs = f { inherit system; }; # This is the package attribute set of `nixpkgs`.
in
pkgs.writeShellScriptBin "what-is-my-ip" ''
  ${pkgs.curl}/bin/curl -s http://ipinfo.io | \
    ${pkgs.jq}/bin/jq --raw-output .ip
''
```

:::notes

- `system`: a string mostly `x86_64-linux` and defaulted to your current system)

- The `builtins.fetchTarball` returns the downloaded content of an URL in the
  `/nix/store/...` Above it returns the content of `nixpkgs` repository at
  commit `9684b53175fc6c09581e94cc85f05ab77464c7e3`. Try it out in the
  `nix repl`.

- `pkgs`: an attribute set and defaulted to the main function of the
  [`nixpkgs`](https://nixos.org/manual/nixpkgs/stable/#preface) repository. The
  repository [`nixpkgs`](https://nixos.org/manual/nixpkgs/stable/#preface) is
  the central package mono-repository which maintains packages (_derivations_)
  for Nix.

:::

---

### Wait! What is [`github.com/NixOS/nixpkgs`](https://nixos.org/manual/nixpkgs/stable/#preface) ?

󰳏 [`nixpgkgs`](https://github.com/NixOS/nixpkgs) is a mono-repository with Nix
code to build software packages (> 130k).

::::::{.columns}

:::{.column width="50%"}

```mermaid
flowchart TD
  nixpkgs((nixpkgs))
  nixpkgs --- BuildTools[Build Tools]
  BuildTools --- compilers[Compilers]
  BuildTools --- libraries[Libraries]
  nixpkgs --- systemPackages[System Packages]
  systemPackages --- firefox[Firefox]
  systemPackages --- signal[Signal]
```

:::

:::{.column width="50%" style="align-content:center"}

 A commit in `nixpkgs` represents the **version** of **all** packages at that
**commit** (a big tree).

:::

::::::

---

### What is [`github.com/NixOS/nixpkgs`](https://nixos.org/manual/nixpkgs/stable/#preface) ?

::: incremental

- Statement [`f = import src;`](#building-package) imports
  [`default.nix`](https://github.com/NixOS/nixpkgs/blob/master/default.nix) from
  `nixpkgs`
  [[1](https://github.com/NixOS/nixpkgs/blob/374e6bcc403e02a35e07b650463c01a52b13a7c8/pkgs/top-level/default.nix#L21)]
  - Returns a **function `f`**.
  - When called returns attribute set **`pkgs`** for your `system` (e.g
    `"x86_64-linux"`).

- Package Search:
  - [https://search.nixos.org/packages](https://search.nixos.org/packages)
  - [https://www.nixhub.io](https://www.nixhub.io).

- Function Search: [https://noogle.dev](https://noogle.dev).

:::

---

## Package It with Nix (4)

```nix {line-numbers="1"}
pkgs.writeShellScriptBin "what-is-my-ip" ''
  ${pkgs.curl}/bin/curl -s http://ipinfo.io | \
    ${pkgs.jq}/bin/jq --raw-output .ip
''
```

- `pkgs.writeShellScriptBin` is a **trivial builder function** around the
  [`derivation`](#appendix-the-builtin-function-derviation) command
  ([see appendix](#appendix-the-builtin-function-derviation)).

::: notes
The question is how does Nix know all this?

Nix builds in a sandbox where only `/nix/store` (and some others, +no internet)
is available. Any build tool which is used during the build will only pick up
libraries from the `/nix/store` (any linker will link to these files). For
`pkgs.writeShellScriptBin` it will also analyze the output script for store
paths and include these in the runtime dependencies.

Show the output of `ldd curl` etc.

:::

# What Is a Flake?

A [`flake.nix`](./flake.nix)
\[[1](https://nix.dev/manual/nix/2.30/command-ref/new-cli/nix3-flake),
[2](https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/outputs)\]

:::incremental

- provides a **deterministic** way to manage dependencies and configurations
  \[[1](https://www.youtube.com/live/yhfDtRRTmY8?si=xTjOKKIWIZPIwoU3&t=18317)\].

- comes with a `flake.lock` file which locks dependencies.

:::

:::{.fragment}

Remember
[`fetchTarball ".../NixOS/nixpkgs/..."` in `what-is-my-ip.nix`](#building-package).<br>
🌻 A `flake.nix` is a better method for locked inputs.

:::

## What Is a Flake? (2)

A flake `flake.nix`:

::::::{.columns}

:::{.column width="50%"}

:::incremental

- References external Nix code - called
  [**`inputs`**](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained#_1-flake-inputs).
  - Other repositories, local files, or URLs with a `flake.nix`.

- Defines structured
  [**`outputs`**](https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/outputs)
  (a function).
  - Specifies what the flake provides.

:::

:::

:::{.column width="50%"}

```nix {line-numbers="3,5"}
# flake.nix
{
  inputs = { /* ... */ };

  outputs = inputs: {
    packages = /* implementation */

    # ... other output attributes ...
  }
}
```

:::

::::::

:::notes

- **Inputs**: An attribute set `inputs`, listing dependencies the flake relies
  on.
- **Outputs**: A function that takes all `inputs` and returns an
  [](https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/outputs),
  specifying what the flake provides (e.g., packages, modules, or NixOS
  configurations)
  [\[doc\]](https://nix.dev/manual/nix/2.30/command-ref/new-cli/nix3-flake#flake-format).

:::

---

## Flake outputs

| Output                                                     | What it does                                        | Invoked with                                   |
| ---------------------------------------------------------- | --------------------------------------------------- | ---------------------------------------------- |
| `packages.<system>.<name>`                                 | Buildable derivation — the installable package      | `nix build .#name`                             |
| `devShells.<system>.<name>`                                | Reproducible shell with dev dependencies in `$PATH` | `nix develop`                                  |
| `apps.<system>.<name>`                                     | Executable entry point for the flake                | `nix run .#name`                               |
| `nixosConfigurations.<host>` / `homeConfigurations.<name>` | Full system or user-level declarative config        | `nixos-rebuild switch` / `home-manager switch` |

:::notes

Flakes are a great example of the power of nix. Through the language and cli you can define and build packages, but also development environment (devShells), executable path (apps) and
configurations.

Other tools e.g. uv do something similar within the scope of one language, but nix gives you full flexibility here. You can specify multiple environment for different use cases, e.g. `frontend` `backend`, `full-stack` or different packages each of them treated independent and much more.

:::

# Nix Development Shells

## What Is a Nix DevShell?

Its a Nix **derivation** in the output attribute set `devShells` of the
`flake.nix`:

```nix { line-numbers="7-9" }
{
  inputs = { /* ... */ };
  outputs = inputs: {
    packages.x86_64-linux = {
      mytool = /* derivation */
    };
    devShells.x86_64-linux = {
      banana-shell = /* derivation */
    };
    # ... other outputs ...
  }
}
```

The `banana-shell` derivation is meant to be consumed by `nix develop`.

---

## Questions ?

[![](${meta:include-base-dir}/assets/images/questions.png){style="width:30%"}]{.center-content}

# Outlook

- 🦸[Devenv Nix Shell](https://devenv.sh) is **deterministic/reproducible** and
  with lots of power.
  - Foundation of a `flake.nix` and integration of a Nix shell. Simpler approach
    with [`devenv.nix`](https://devenv.sh/basics).

  - Nix community is flourishing -
    [contribute or support it](https://opencollective.com/nixos):
    - [Discourse Forum](https://discourse.nixos.org)
    - [Matrix Community](https://matrix.to/#/#space:nixos.org)

  - Other commercial ( ‼️lock-in ) projects:
    [`devbox`](https://www.jetify.com/devbox), [flox](https://flox.dev).

---

## Goodies 🍬 from SDSC

We maintain _well-structured_, _state-of-the-art_, _`nix`-enabled_
[**repository templates**](https://github.com/sdsc-ordes/repository-templates)
for toolchains like:

- [Rust](https://github.com/sdsc-ordes/repository-template#rust-template)
- [Go](https://github.com/sdsc-ordes/repository-template#go-template)
- [Python](https://github.com/sdsc-ordes/repository-template#python-template)
- [Generic](https://github.com/sdsc-ordes/repository-template#generic-template)
- etc.

**The templates provide CI out of the box and are ready to use!**

---

## Your Nix Journey

:::incremental

- 🌍 Tackling non-reproducible software distribution is **hard** — but
  **essential**

- 🚀 Embrace **Nix** to gain
  - reproducibility
  - consistency
  - healthy local development
  - CI for free (when you fix something with  its fixed!)

- 🤝 The **Nix community** is welcoming and supportive — don't hesitate to ask!

- ✅ Check the references/resources provided (🤷‍♀️ sometimes its a mess, but gets
  better).

:::

# References

## Links

::::::{.columns}

:::{.column width="50%"}

#### Nix & Nixpkgs

- [Official Wiki](https://wiki.nixos.org/wiki/NixOS_Wiki)
- [Official Manual](https://nix.dev/manual/nix/2.30/introduction.html)
- [Official Package Search](https://search.nixos.org/packages?)
- [Function Search](https://noogle.dev/)
- [Packages Search for Version Pinning](https://nixhub.io)
- [Pull Request Tracker](https://nixpk.gs/pr-tracker.html)

:::

:::{.column width="50%"}

#### NixOS Related

- [Manual](https://nixos.org/manual/nixos/stable/)
- [Options Search](https://search.nixos.org/options?)
- [With Flakes](https://nixos-and-flakes.thiscute.world/nixos-with-flakes)
- [Status](https://status.nixos.org/)

:::

::::::

# Appendix

##  The Nix Language

:::incremental

- _Domain-specific_ **functional** language (**no side-effects**).

- Structurally similar to JSON but with
  [functions](https://nixos.org/guides/nix-pills/05-functions-and-imports.html).

- [Fundamental data types](https://nixos.org/guides/nix-pills/04-basics-of-language.html#basics-of-language)
  such as `string`, `integer`, `path`, `list`, and `attribute set`.

- **Lazy Evaluated**: _expression evaluation delayed until needed_.

- ⚠️**Specifically designed** for **deterministic/reproducible** software
  deployment.

:::

:::notes

The Nix language is specifically designed for deterministic software building
and distribution. Due to its narrow scope, it lacks certain features, such as
floating-point types, which are unnecessary in this context.

:::

## What Is a Nix Derivation?

A [derivation](https://nix.dev/manual/nix/2.24/glossary#gloss-derivation) is a

- **specialized attribute set**, describes how to **build** a Nix package.

  ```nix
  { type = "derivation"; ... }
  ```

  Check `nix repl -f <nixpkgs>` and type `pkgs.curl.type`.

::: notes

A [derivation](https://nix.dev/manual/nix/2.24/glossary#gloss-derivation) is a
**specialized attribute set** that describes how to build a Nix package. In raw
form, it looks like `{ type = "derivation"; ... }` and carries a well-defined
structure with built-in meaning.

:::

---

## Whats a Derivation?

> **A [derivation](https://zero-to-nix.com/concepts/derivations)** is a **build
> instruction** to realize a **package in the `/nix/store`** using a
> [special `derivation` function](https://noogle.dev/f/builtins/derivation).
>
> - Can depend on multiple other
>   [derivations](https://zero-to-nix.com/concepts/derivations).
> - Produce one or more outputs.
>
> The complete set of dependencies required to build a derivation—including its
> transitive dependencies—is called a **closure**.
> [[Ref]](https://zero-to-nix.com/concepts/derivations)

---

## Evaluate & Build a Derivation

```mermaid
flowchart LR
    A["<strong>Flake</strong><br><code>flake.nix</code>"] -->|"contains output attributes"| B["<strong><code>packages.x86_64-linux.mypackage</code></strong><br>Nix Derivation"]
    B -->|"evaluate"| C["<strong>Store Derivation</strong><br><code>/nix/store/*.drv</code>"]
    C -->|"realize/build"| D["<strong>Outputs</strong><br>in<code>/nix/store/*</code>"]
```

::: incremental

- **Evaluating**: Store build instructions in the `/nix/store`<br> (a store
  derivation `*.drv`,
  [more details](https://nix.dev/manual/nix/2.24/glossary#gloss-store-derivation)).

- **Building**: Realizing outputs of the derivation in the `/nix/store`. _This
  can literally be anything!_

:::

---

## Use [`devenv.sh`](https://devenv.sh) for Nix DevShells

:::incremental

- 🚧 Nix DevShells from `nixpkgs` (`pkgs.mkShell`) are **raw** and **too
  simplistic**.

- 🌻Nix DevShells from [`devenv.sh`](https://devenv.sh) provides more concise
  configuration.
  - ❤️‍🔥Configuration based on mechanics which drive `NixOS` (NixOS Modules).

:::

---

## Fixed Point Combinator 🤯

In maths a fix point `x` of a function `F` is defined as:

$$
x = F(x).
$$

:::{.fragment}

In functional programming a fix-point **combinator** `fix` is a _higher-order_
function.<br> It returns the fix point of a function `F`:

:::

:::{.fragment}

```nix
fix = F: let x = F x in x
```

:::

---

## Fixed-Point Combinator 🤯

That is how recursive self-referential sets can be defined.

```nix {line-numbers="2|5|7|9"}
let
  fix = F: let x = F x in x;

  # Define the constructor of the set.
  newSet = self: { path = "/bin"; full = self.path + "/my-app"; };

  mySet = fix newSet; # fulfills: mySet == fix mySet;
in
  mySet.full
```

Seems recursive in `let x = F x` but **but isn't 🤯**, because its lazy
evaluated.
[What you need to know about laziness.](https://nixcademy.com/de/posts/what-you-need-to-know-about-laziness).

Used in `pkgs.callPackage` in `nixpkgs`.

---

## Why Nix is Lazy Evaluated?

:::{style="font-size:14pt"}

> The choice for lazy evaluation allows us to write Nix expressions in a
> convenient and elegant style: Packages are described by Nix expressions and
> these Nix expressions can freely be passed around in a Nix program – as long
> as we do not access the contents of the package, no evaluation and thus no
> build will occur. […] At the call site of a function, we can supply all
> potential dependencies without having to worry that unneeded dependencies
> might be evaluated. For instance, the whole of the Nix packages collection is
> essentially one attribute set where each attribute maps to one package
> contained in the collection. It is very convenient that at this point, we do
> not have to deal with the administration of what exactly will be needed where.
> Another benefit is that we can easily store meta information with packages,
> such as name, version number, homepage, license, description and maintainer.
> Without any extra effort, we can access such meta-information without having
> to build the whole package.
> [[Paper](https://edolstra.github.io/pubs/nixos-jfp-final.pdf)]

:::

---

### The builtin function `derivation`

This is what `pkgs.writeShellScriptBin` would expand to: (see
[./examples/what-is-my-ip-orig.nix](https://github.com/sdsc-ordes/nix-workshop/blob/main/examples/what-is-my-ip-orig.nix)):

```nix {line-numbers="1|2|4|5|7-20|10|12-16|22,10" style="font-size:12pt;"}
derivation {
  inherit system;

  name = "what-is-my-ip";
  builder = "/bin/sh";

  args = [
    "-c"
    ''
      ${pkgs.coreutils}/bin/mkdir -p $out/bin

      {
        echo '#!/bin/sh'
        echo '${pkgs.curl}/bin/curl -s http://ipinfo.io | \
        ${pkgs.jq}/bin/jq --raw-output .ip'
      } > $out/bin/what-is-my-ip

      ${pkgs.coreutils}/bin/chmod +x $out/bin/what-is-my-ip
    ''
  ];

  outputs = [ "out" ];
}
```

---

## Store Derivation

> A store **derivation** (`*.drv`) contains only **build instructions** for Nix
> to **realize/build** it. This can be literally anything, e.g. a software
> package, a wrapper shell script or only source files.

---

## Evaluate & Build a Derivation

```bash
# Evaluate it.
drvPath=$(nix eval "./examples/flake-simple#packages.x86_64-linux.mytool" --raw)
# Realize it.
nix build -L "$drvPath" --print-out-paths --out-link ./mytool
```

---

## Inspect a Derivation

```bash
nix eval "./examples/flake-simple#packages.x86_64-linux.mytool"

> «derivation /nix/store/l8pma77py04gd5819zkk3h7jx0bgxqgm-mytool.drv»
```

`./examples/flake-simple#packages.x86_64-linux.mytool` is an _installable_. More
later!

:::{.fragment}

```bash
# Inspect the store derivation.
cat /nix/store/l8pma77py04gd5819zkk3h7jx0bgxqgm-mytool.drv
```

:::

:::notes

Realize that even when you are on macOS `aarch64-darwin`, that we can evaluate
the derivation for another architecture.

:::

---

## Inspect a Derivation (2)

```bash
> Derive([("out","/nix/store/5rvqlxk2vx0hx1yk8qdll2l8l62pfn8n-treefmt","","")],
[("/nix/store/1fmb3b4cmr1bl1v6vgr8plw15rqw5jhf-treefmt.toml.drv",["out"]),
("/nix/store/3avbfsh9rjq8psqbbplv2da6dr679cib-treefmt-2.1.0.drv",["out"]),
("/nix/store/61fjldjpjn6n8b037xkvvrgjv4q8myhl-bash-5.2p37.drv",["out"]),
("/nix/store/gp6gh2jn0x7y7shdvvwxlza4r5bmh211-stdenv-linux.drv",["out"])]
,["/nix/store/v6x3cs394jgqfbi0a42pam708flxaphh-default-builder.sh"]
,"x86_64-linux","/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash",
["-e","/nix/store/v6x3cs394jgqfbi0a42pam708flxaphh-default-builder.sh"],
[ ("__structuredAttrs",""),("allowSubstitutes",""),
("buildCommand","target=$out/bin/treefmt\nmkdir -p \"$(dirname \"$target\")\"\n\nif [ -e \"$textPath\" ]; then\n  mv \"$textPath\" \"$target\"\nelse\n  echo -n \"$text\" > \"$target\"\nfi\n\nif [ -n \"$executable\" ]; then\n  chmod +x \"$target\"\nfi\n\neval \"$checkPhase\"\n"),("buildInputs",""),("builder","/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash"),("checkPhase","/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash -n -O extglob \"$target\"\n"),("cmakeFlags",""),("configureFlags",""),("depsBuildBuild",""),("depsBuildBuildPropagated",""),("depsBuildTarget",""),("depsBuildTargetPropagated",""),("depsHostHost",""),("depsHostHostPropagated",""),("depsTargetTarget",""),("depsTargetTargetPropagated",""),("doCheck",""),("doInstallCheck",""),("enableParallelBuilding","1"),("enableParallelChecking","1"),("enableParallelInstalling","1"),("executable","1"),("mesonFlags",""),("name","treefmt"),("nativeBuildInputs",""),("out","/nix/store/5rvqlxk2vx0hx1yk8qdll2l8l62pfn8n-treefmt"),("outputs","out"),("passAsFile","buildCommand text"),("patches",""),("preferLocalBuild","1"),("propagatedBuildInputs",""),("propagatedNativeBuildInputs",""),("stdenv","/nix/store/hsxp8g7zdr6wxk1mp812g8nbzvajzn4w-stdenv-linux"),("strictDeps",""),("system","x86_64-linux"),("text","#!/nix/store/8vpg72ik2kgxfj05lc56hkqrdrfl8xi9-bash-5.2p37/bin/bash\nset -euo pipefail\nunset PRJ_ROOT\nexec /nix/store/0jcp33pgf85arjv3nbghws34mrmy7qq5-treefmt-2.1.0/bin/treefmt \\\n  --config-file=/nix/store/qk8rqccch6slk037dhnprryqwi8mv0xs-treefmt.toml \\\n  --tree-root-file=.git/config \\\n  \"$@\"\n\n")])
```

:::{.fragment}

JSON output of the above:

```bash
nix derivation show /nix/store/l8pma77py04gd5819zkk3h7jx0bgxqgm-mytool.drv
```

:::

:::notes

The output of `/nix/store/l8pma77py04gd5819zkk3h7jx0bgxqgm-mytool.drv` above is
the internal serialization of the formatter's derivation which **when built**
can be used to format all files in this repository.

:::

---

## Inspect a Derivation (3)

```json {style="font-size:12pt"}
{
  "/nix/store/l8pma77py04gd5819zkk3h7jx0bgxqgm-mytool.drv": {
    "args": [
      "-e",
      "/nix/store/vj1c3wf9c11a0qs6p3ymfvrnsdgsdcbq-source-stdenv.sh",
      "/nix/store/shkw4qm9qcw5sc5n1k5jznc83ny02r39-default-builder.sh"
    ],
    "builder": "/nix/store/9nw8b61s8lfdn8fkabxhbz0s775gjhbr-bash-5.2p37/bin/bash",
    "env": {
      "__structuredAttrs": "",
      "allowSubstitutes": "",
      "buildCommand": "target=$out/bin/mytool\nmkdir -p \"$(dirname \"$target\")\"\n\nif [ -e \"$textPath\" ]; then\n  mv \"$textPath\" \"$target\"\nelse\n  echo -n \"$text\" > \"$target\"\nfi\n\nif [ -n \"$executable\" ]; then\n  chmod +x \"$target\"\nfi\n\neval \"$checkPhase\"\n",
      "buildInputs": "",
      "builder": "/nix/store/9nw8b61s8lfdn8fkabxhbz0s775gjhbr-bash-5.2p37/bin/bash",
      "checkPhase": "/nix/store/9nw8b61s8lfdn8fkabxhbz0s775gjhbr-bash-5.2p37/bin/bash -n -O extglob \"$target\"\n",
      "cmakeFlags": "",
      "configureFlags": "",
      "depsBuildBuild": "",
      "depsBuildBuildPropagated": "",
      "depsBuildTarget": "",
      "depsBuildTargetPropagated": "",
      "depsHostHost": "",
      "depsHostHostPropagated": "",
      "depsTargetTarget": "",
      "depsTargetTargetPropagated": "",
      "doCheck": "",
      "doInstallCheck": "",
      "enableParallelBuilding": "1",
      "enableParallelChecking": "1",
      "enableParallelInstalling": "1",
      "executable": "1",
      "mesonFlags": "",
      "name": "mytool",
      "nativeBuildInputs": "",
      "out": "/nix/store/blm702jzcwfppwrrj9925ivd9gxp4c9n-mytool",
      "outputs": "out",
      "passAsFile": "buildCommand text",
      "patches": "",
      "preferLocalBuild": "1",
      "propagatedBuildInputs": "",
      "propagatedNativeBuildInputs": "",
      "stdenv": "/nix/store/npp9k9062ny7w0k1i03ij6xvqb7vhvjh-stdenv-linux",
      "strictDeps": "",
      "system": "x86_64-linux",
      "text": "#!/nix/store/9nw8b61s8lfdn8fkabxhbz0s775gjhbr-bash-5.2p37/bin/bash\n\"/nix/store/xkk1gr9bw2dbdjna8391rj1zl1l3dmhq-cowsay-3.8.4/bin/cowsay\" \"Hello there ;)\"\necho \"-------------------------------------\"\n\"/nix/store/4ydiim4lfk6nyab4pdkjj9s33pgbigfd-figlet-2.2.5/bin/figlet\" \"Do you expect\"\n\"/nix/store/4ydiim4lfk6nyab4pdkjj9s33pgbigfd-figlet-2.2.5/bin/figlet\" \"something \"\n\"/nix/store/4ydiim4lfk6nyab4pdkjj9s33pgbigfd-figlet-2.2.5/bin/figlet\" \"useful ? \"\n\n"
    },
    "inputDrvs": {
      "/nix/store/1fsd2cb5ab7ci01ks4j0gbbq254jw6sk-stdenv-linux.drv": {
        "dynamicOutputs": {},
        "outputs": ["out"]
      },
      "/nix/store/lrf9kbhlaf5mkvnlf3zr9wzvk7c2z72l-bash-5.2p37.drv": {
        "dynamicOutputs": {},
        "outputs": ["out"]
      },
      "/nix/store/phq4wh4490manblg905xixpc3gvwr149-figlet-2.2.5.drv": {
        "dynamicOutputs": {},
        "outputs": ["out"]
      },
      "/nix/store/wdpicivrj0bmzh935rr1hm1vlk18j0mp-cowsay-3.8.4.drv": {
        "dynamicOutputs": {},
        "outputs": ["out"]
      }
    },
    "inputSrcs": [
      "/nix/store/shkw4qm9qcw5sc5n1k5jznc83ny02r39-default-builder.sh",
      "/nix/store/vj1c3wf9c11a0qs6p3ymfvrnsdgsdcbq-source-stdenv.sh"
    ],
    "name": "mytool",
    "outputs": {
      "out": {
        "path": "/nix/store/blm702jzcwfppwrrj9925ivd9gxp4c9n-mytool"
      }
    },
    "system": "x86_64-linux"
  }
}
```

---

## What Is an Installable

:::{.fragment}

The path `./examples/flake-simple#packages.x86_64-linux.mytool` is referred to
as a
[Flake output attribute installable](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix#flake-output-attribute),
or simply an
[_installable_](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix#installables).

:::

:::{.fragment}

An **installable** is a Flake output that can be realized in the Nix store.

:::

::: incremental

- `./examples/flake-simple` refers to this repository’s
  [`flake.nix`](./flake.nix) directory.
- `packages.x86_64-linux.mytool` following `#` is an output attribute defined
  within the flake.

:::

::: {.fragment}

Most
[modern Nix commands](https://nix.dev/manual/nix/2.24/command-ref/experimental-commands)
accept **installables** as input, making them a fundamental concept in working
with Flakes. **You should only use the modern commands, e.g.
`nix <subcommand>`**. Stay away from the command `nix-env`.

:::

---

## More on Strings

Nix distinguishes between

- normal `string`s: just text,
- and _`string`s with context_ : text + **set of references to store paths**.

Strings _with context_ are always created when derivations are involved:

```nix
{pkgs, ...}: {
  mytool = pkgs.writeShellScriptBin "tool"
    # String with context, due to referencing `pkgs.coreutils`:
    ''
      echo "hello" | "${pkgs.coreutils}/bin/tee" -a test.log
    '';
}
```

**Note:** Use `builtins.getContext` to inspect a string with context.
