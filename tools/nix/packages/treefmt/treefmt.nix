{ pkgs, ... }:
{
  # Used to find the project root
  # We use `LICENSE` instead of `.git/config`
  # because that does not work with Git worktree.
  projectRootFile = "LICENSE.md";

  settings.global.excludes = [
    "external/**"
    "**/fonts/**"
    "**/mixin/plugin/**"
  ];

  # Markdown, JSON, YAML, etc.
  programs.prettier.enable = true;

  # Shell.
  programs.shfmt = {
    enable = true;
    indent_size = 4;
  };

  programs.shellcheck.enable = true;
  settings.formatter.shellcheck = {
    options = [
      "-e"
      "SC1091"
    ];
  };

  # Lua.
  programs.stylua.enable = true;

  # Nix.
  programs.nixfmt.enable = true;

  # Typos.
  programs.typos.enable = false;
}
