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
    packages = {
      inherit python;
    };

    devShells.default = pkgs.mkShell rec {
      packages = [
        python
      ];

      shellHook = ''
        ${config.pre-commit.installationScript}
      '';

      TK_LIBRARY = "${pkgs.tk}/lib/${pkgs.tk.libPrefix}";
    };
  };
}
