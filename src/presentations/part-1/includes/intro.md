<!-- markdownlint-disable-file MD034 MD033 MD001 MD024 MD026-->

# Introduction

## Why Nix

### [Learn Nix the Fun Way](https://fzakaria.github.io/learn-nix-the-fun-way)

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

- Nix is a _domain-specific_ **functional** language.

- Structurally similar to JSON but with
  [_function_](https://nixos.org/guides/nix-pills/05-functions-and-imports.html).

- Supports fundamental data types such as `string`, `integer`, `path`, `list`,
  and `attribute set`. See
  [Nix Language Basics](https://nixos.org/guides/nix-pills/04-basics-of-language.html#basics-of-language).

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

```nix
mult = width: height: width * height;
res = mult 4 2;    # 8

mult10 = mult 10   # Bind an argument.

res = mult10 8     # 80
```

```nix
args: {
  a = args.banana + "-nice";
  b = args.orange + "-sour";
}
```

:::

:::{.column width="50%"}

```nix {.fragment data-fragment="1"}
mult = width: height: width * height;
res = mult 4 2;    # 8

mult10 = mult 10   # Bind an argument.

res = mult10 8     # 80
```

```nix
{ banana, orange, ...}: {
  a = args.banana + "-nice";
  b = args.orange + "-sour";
}
```

:::

::::::
