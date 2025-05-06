<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Introduction

## Why Nix

We will see in a minute!

---

## Requirements

Ensure that you have installed
[`Nix`](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/nix-and-nixos#installing-nix)
and
[`direnv`](https://swissdatasciencecenter.github.io/best-practice-documentation/docs/dev-enablement/nix-and-nixos#installing-direnv).

The basic requirements for working with this repository are:

- `just`
- `nix`

---

## What is Nix

:::incremental

- A _domain-specific_ **functional** language (**no side-effects**).

- Structurally similar to JSON but with
  [_function_](https://nixos.org/guides/nix-pills/05-functions-and-imports.html).

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

  ```nix
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

```nix {line-numbers="2" .fragment}
let # start for "procedural" statements
 mult = a: b: a * b;
 x10 = mult 10; # Bind the first arg.
in
x10 (mult 8 2)
# -> 160
```

```nix {line-numbers="2" .fragment}
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

```nix {line-numbers="2" .fragment}
let
f = { ban, ora, ...}: { # Destructuring
  a = args.ban + "-nice";
  b = args.ora + "-sour";
};
in
f { ban = "1"; ora = "2"; berry ="3"; }
# -> { a = "1-nice"; b = "2-sour"; }
```

```nix {line-numbers="2" .fragment}
let
f = list: {
  a = builtins.map (x: x*x) list;
};
in
f [ 1 3 9 ];
# -> [ 1 9 81 ]
```

:::

::::::

---

### More Examples

::::::{.columns}

:::{.column width="50%"}

```nix {line-numbers="2" .fragment}
# Concat lists.
[ 1 2 3 ] ++ [ 1 2 3 ];
```

```nix {line-numbers="2" .fragment}
# Merge attribute sets.
{ a = 1; b = 2; } // { a = 2; c = 3; }
```

```nix {line-numbers="2" .fragment}
a = rec {
  b = 2;
  c = b + d:
  d = 10;
}
```

:::

:::{.column width="50%"}

```nix {line-numbers="2" .fragment}
# Lazy evaluation.
let
  x = abort "fail";
in
if false then x else 42
# -> 42
```

```nix {line-numbers="2" .fragment}

```

:::

::::::

---

## Learn Nix the Fun Way

### [Learn Nix the Fun Way](https://fzakaria.github.io/learn-nix-the-fun-way)

---

## Fixed Point Combinator 🤯

In maths a fix point `x` of a function `f` is defined as:

$$
x = f(x).
$$

In functional programming a fix-point **combinator** `fix` is a _higher-order_
function which returns the fix point of another function `g`:

```nix
 fix = g: g (fix g)
```

Really?

:::{.fragment}

Apply `fix` to a function `f` and see what it returns:

$$
\underbrace{\text{fix}(f)}_{x} = f( \underbrace{\text{fix}(f)}_{x} )
$$

:::

---

## Fixed-Point Combinator 🤯

That is how recursive self-referential sets can be defined.

```nix
let
  fix = g: g (fix g); # Fix-point combinator.

  # Define the constructor.
  newSet = self: { path = "/bin"; full = self.path + "/my-app"; };

  mySet = fix newEnv;               # fulfills: myEnv == fix myEnv;
in
  mySet.full
```

Seems recursive: `fix` calls `fix` again -> but isn't 🤯.

Used in `pkgs.callPackage`:

---
