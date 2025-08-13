# We rely on a devenv  module to setup golang.
# This keeps the config simple, while setting up all the required tooling for vscode etc.
{pkgs}: [
  {
    packages = with pkgs; [
      curl
      eza
      fd
      wget
    ];

    languages.go = {
      enable = true;
      package = pkgs.go;
    };

    env = {
      EXAMPLE_ENV_VAR = "MY_VALUE";
    };

    enterShell = ''
      echo "🐹 Running: $(go version) 🐹"
    '';
  }
]
