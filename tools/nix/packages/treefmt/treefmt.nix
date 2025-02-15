{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "LICENSE.md";

  settings.global.excludes = [
    "external/**"
    "**/pandoc-diagram.lua"
    "src/mixin/plugin/**"
    "src/mixin/dist/**"
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
