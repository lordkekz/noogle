{ inputs, ... }: {
  perSystem = { self', inputs', pkgs, lib, system, ... }:
    let
      inherit (inputs'.nix.packages) nix;

      port = "8013";
      dist = self'.packages.ui;

      caddyfile = pkgs.writeText "noogle-Caddyfile" ''
          :${port} {
            root * ${dist}/lib/node_modules/noogle/out/
            try_files {path}.html
            encode gzip
            file_server
          }
        '';
    in
    {
      packages = {
        run-with-caddy = pkgs.writeShellApplication {
          name = "run-with-caddy";
          runtimeInputs = [pkgs.caddy];
          text = ''
            caddy --version
            caddy run --adapter caddyfile --config ${caddyfile}
          '';
        };
      };
    };
}
