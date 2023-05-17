{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    system,
    inputs',
    self',
    ...
  }: let
    python-packages = (
      ps:
        with ps; [
          requests
          tkinter
          configparser
        ]
    );
    python = pkgs.python3.withPackages python-packages;
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    packages = {
      inherit python;
    };

    devShells.default = pkgs.mkShell rec {
      packages = [
        python
        pkgs.steamcmd
      ];

      shellHook = ''
        ${config.pre-commit.installationScript}
      '';

      TK_LIBRARY = "${pkgs.tk}/lib/${pkgs.tk.libPrefix}";
    };
  };
}
