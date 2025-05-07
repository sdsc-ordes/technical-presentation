<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Introduction

## Why Nix

We will see in a minute!

---

## Requirements

## Requirements

Ensure that you have installed
[`Nix`](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/nix-and-nixos#installing-nix)
and
[`direnv`](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/nix-and-nixos#installing-direnv).

The basic requirements for working with this repository are:

- `just`
- `nix`

See
[instructions](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/nix-and-nixos).

🪟 Windows Users: kindly asked to leave this presentation (since Nix is for Unix
system) **or** use **WSL Ubuntu**.

---

## What is Nix

:::incremental

- A _domain-specific_ **functional** language (**no side-effects**).

- Structurally similar to JSON but with
  [_functions_](https://nixos.org/guides/nix-pills/05-functions-and-imports.html).

- Supports fundamental data types such as `string`, `integer`, `path`, `list`,
  and `attribute set`. See
  [Nix Language Basics](https://nixos.org/guides/nix-pills/04-basics-of-language.html#basics-of-language).

- **Lazy evaluated**, _expression evaluation delayed until needed_.

- ⚠️The Nix language is **specifically designed** for
  **deterministic/reproducible** software deployment.

:::

:::notes

The Nix language is specifically designed for deterministic software building
and distribution. Due to its narrow scope, it lacks certain features, such as
floating-point types, which are unnecessary in this context.

:::

---

## Nix Language

::: incremental

- Nix files have suffix `.nix` and contain mostly 1
  [_function_](https://nixos.org/guides/nix-pills/05-functions-and-imports.html).

- The function `args: ...` in file `myfunction.nix` takes one argument `args`
  and

  ```nix {line-numbers="2|3|4|5|6|7|8|9"}
  # myfunction.nix
  args:
  let
    aNumber = 1;  # A number.
    aList = [ 1 2 3 "help"];  # A list with 4 elements.
    anAttrSet = { a = 1; b.c.d = [1]; };  # A nested attribute set.
    result = args.myFunc { val1 = aNumber; };  # Calls another function `args.myFunc`.
  in
  { val1 = aNumber; val2 = anAttrSet.b.c.d; val3 = result; }
  ```

  returns an attribute set `{ val1 = ... }`.

:::

- Watch this [short introduction](https://www.youtube.com/watch?v=HiTgbsFlPzs)
  for the basic building block.

---

## Examples

::::::{.columns}

:::{.column width="50%"}

```nix {line-numbers="2|3|5|6" .fragment}
let # start for "procedural" statements
 mult = a: b: a * b;
 x10 = mult 10; # Bind the first arg.
in
x10 (mult 8 2)
# -> 160
```

```nix {line-numbers="2|2-4|7|8" .fragment}
let
f = args: {
  a = args.banana + "-nice";
  b = args.orange + "-sour";
};
in
f { banana = "1"; orange = "2" };
# -> { a = "1-nice"; b = "2-sour"; }
```

:::

:::{.column width="50%"}

```nix {line-numbers="2|2-4|7|8" .fragment}
let
f = { ban, ora, ...}: { # Destructuring
  a = ban + "-nice";
  b = ora + "-sour";
};
in
f { ban = "1"; ora = "2"; berry ="3"; };
# -> { a = "1-nice"; b = "2-sour"; }
```

```nix {line-numbers="2|3|5|6" .fragment}
let
f = list: {
  a = builtins.map (x: x*x) list;
};
in f [ 1 3 9 ];
# -> [ 1 9 81 ]
```

:::

::::::

---

### More Examples

::::::{.columns}

:::{.column width="50%"}

```nix {line-numbers="2|3" .fragment}
# Concat lists.
[ 1 2 3 ] ++ [ 1 2 3 ]
# [ 1 2 3 1 2 3 ];
```

```nix {line-numbers="2|3" .fragment}
# Merge attribute sets.
{ a = 1; b = 2; } // { a = 2; c = 3; }
# -> { a = 2; b = 2; c = 3; }
```

```nix {line-numbers="1-5|2|3|4|6" .fragment}
a = rec {
  b = 2;
  c = b + d:
  d = 10;
}
# -> { b = 2; c = 12; d = 10; }
```

:::

:::{.column width="50%"}

```nix {line-numbers="3|5|6" .fragment}
# Lazy evaluation.
let
  x = abort "fail";
in
if false then x else 42
# -> 42
```

```nix {line-numbers="3|4" .fragment}
# Import files.
let
  myfunc = import ./myfunction.nix;
in myfunc 1 + (import ./other.nix 3)
```

:::

::::::

---

## Attribute Set Building: `inherit`

```nix {line-numbers="3|4|5|8|9" .fragment}
# Inherit 'key = value'.
let
  width = 100;
  color = "blue";
  set = { b = 1; };
in
{
  inherit color;   # color = color;
  inherit (set) b; # b     = set.b;
}
```

---

## Caution With `let` Statements

Do not reassign in `let` blocks:

```nix {line-numbers="2|3|3,6"}
let
  a = "hello";
  a = a + "world";
  #   ^
  #   |
  #  🆘 Endless recursion, this is not reassigning.
in a
```

:::{.fragment}

✅ Configure [ `nixd` ](https://github.com/nix-community/nixd) (Nix Language
Server) in your IDE to see "Go to definitions".

:::

## Fixed Point Combinator 🤯

In maths a fix point `x` of a function `f` is defined as:

$$
x = f(x).
$$

:::{.fragment}

In functional programming a fix-point **combinator** `fix` is a _higher-order_
function.<br> It returns the fix point of a function `g`:

:::

:::{.fragment}

```nix
 fix = g: g (fix g)
```

:::

:::{.fragment}

Really?

Apply `fix` to a function `f` and see what it returns:

$$
\underbrace{\text{fix}(f)}_{x} = f( \underbrace{\text{fix}(f)}_{x} )
$$

:::

---

## Fixed-Point Combinator 🤯

That is how recursive self-referential sets can be defined.

```nix {line-numbers="2|5|7|9"}
let
  fix = g: g (fix g); # Fix-point combinator.

  # Define the constructor.
  newSet = self: { path = "/bin"; full = self.path + "/my-app"; };

  mySet = fix newEnv;               # fulfills: myEnv == fix myEnv;
in
  mySet.full
```

Seems recursive: `fix` calls `fix` again **but isn't 🤯**, because its lazy
evaluated. More explanations here.

Used in `pkgs.callPackage` in `nixpkgs`.

---

## Learn Nix the Fun Way

### [Learn Nix the Fun Way](https://fzakaria.github.io/learn-nix-the-fun-way)

---

# Workshop

## Building Our First Package (1)

Put the following in a script
[`whats-is-my-ip.nix`](https://github.com/sdsc-ordes/nix-workshop/blob/main/examples/what-is-my-ip.nix):

```nix {line-numbers="2|3|4-7"}
{
system ? builtins.currentSystem, # Mostly: x86_64-linux
pkgs ?
  import (builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/9684b53175fc6c09581e94cc85f05ab77464c7e3.tar.gz") {
    inherit system;
  },
}:
pkgs.writeShellScriptBin "what-is-my-ip" ''
  ${pkgs.curl}/bin/curl -s http://httpbin.org/get | \
    ${pkgs.jq}/bin/jq --raw-output .origin
''
```

::: {.fragment .quiz}

_**Quiz:** What returns `builtins.fetchTarball "..."`?_

:::

:::notes

This function takes two parameters:

- `system`: a string mostly `x86_64-linux` and defaulted to your current system)
  and
- `pkgs`: an attribute set and defaulted to the main function of the `nixpkgs`
  repository. The repository `nixpkgs` is the central package mono-repository
  which maintains packages (_derivations_) for Nix.

:::

---

## Building Our First Package (2)

```bash
nix build -f ./examples/what-is-my-ip.nix --print-out-paths

> "/nix/store/7x9hf9g95d4wjjvq853x25jhakki63bz-what-is-my-ip"
```

::: {.fragment}

Explore whats in this file
`/nix/store/7x9hf9g95d4wjjvq853x25jhakki63bz-what-is-my-ip/bin/what-is-my-ip`:

```bash
#!/nix/store/mc4485g4apaqzjx59dsmqscls1zc3p2w-bash-5.2p37/bin/bash
/nix/store/zl7h70n70g5m57iw5pa8gqkxz6y0zfcf-curl-8.12.1-bin/bin/curl \
  -s "http://httpbin.org/get" | \
  /nix/store/y50rkdixqzgdgnps2vrc8g0f0kyvpb9w-jq-1.7.1-bin/bin/jq \
    --raw-output ".origin"
```

Nix has encoded the executables used by **store paths** (`/nix/store`).

:::

:::{.fragment .quiz}

_**Quiz:** Can you share this script with your colleague?_

:::

:::notes

Do not think you can now simply share this script by giving the contents of
directory `/nix/store/7x9hf9g95d4wjjvq853x25jhakki63bz-what-is-my-ip` to
somebody else and it will work. This is not sufficient as we need the other
derivations as well. This is done differently namely over Nix itself, because
Nix has all information (`nix copy`).

:::

## Building Our First Package (3)

```nix
pkgs.writeShellScriptBin "what-is-my-ip" ''
  ${pkgs.curl}/bin/curl -s http://httpbin.org/get | \
    ${pkgs.jq}/bin/jq --raw-output .origin
''
```

The `pkgs.writeShellScriptBin` is a **trivial builder** function around the
fundamental `derivation` command (see
[./examples/what-is-my-ip-orig.nix](https://github.com/sdsc-ordes/nix-workshop/blob/main/examples/what-is-my-ip-orig.nix)):

---

```nix {line-numbers="1|2|4|5|7-20|22,10"}
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
        echo '${pkgs.curl}/bin/curl -s http://httpbin.org/get | \
        ${pkgs.jq}/bin/jq --raw-output .origin'
      } > $out/bin/what-is-my-ip

      ${pkgs.coreutils}/bin/chmod +x $out/bin/what-is-my-ip
    ''
  ];

  outputs = [ "out" ];
}
```

---

## Inspect the Dependency Graph

Run

```bash
nix run github:craigmbooth/nix-visualize -- \
  -c tools/configs/nix-visualize/config.ini
  -s nix
  "$(nix build -f ./examples/what-is-my-ip.nix --print-out-paths)"
```

and inspect `frame.png`.

:::{.center-content}

![](https://media.githubusercontent.com/media/sdsc-ordes/nix-workshop/refs/heads/main/docs/assets/dependency-graph.png){width="50%"
.border-light .center-content}

:::

---
