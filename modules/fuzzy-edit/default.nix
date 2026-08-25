{
    lib,
    moduleWithSystem,
    ...
}: {
    perSystem = {
        self',
        pkgs,
        ...
    }: {
        # Allows definition of system-specific attributes
        # without needing to declare the system explicitly!
        #
        # Quick rundown of the provided arguments:
        # - config is a reference to the full configuration, lazily evaluated
        # - self' is the outputs as provided here, without system. (self'.packages.default)
        # - inputs' is the input without needing to specify system (inputs'.foo.packages.bar)
        # - pkgs is an instance of nixpkgs for your specific system
        # - system is the system this configuration is for

        devShells = {
            fuzzy-edit = pkgs.mkShell {
                nativeBuildInputs = [
                    self'.packages.ripgrep-fuzzy-edit
                    self'.packages.fd-fuzzy-edit
                ];
            };
        };

        packages = {
            ripgrep-fuzzy-edit = pkgs.callPackage ./rgv.nix {};
            fd-fuzzy-edit = pkgs.callPackage ./fdv.nix {};
        };
    };

    flake = {
        nixosModules.fuzzy-edit = moduleWithSystem (
            perSystem @ {
                config,
                pkgs,
                ...
            }: nixos @ {...}:
                # let cfg = perSystem.config.nixosModules.fuzzy-edit; in
            {
                # services.foo.package = perSystem.config.packages.foo;

                config = {
                    environment.systemPackages = [ #lib.mkIf cfg.programs.rgv.enable [
                        perSystem.config.packages.ripgrep-fuzzy-edit
                    ];
                };

                options = {
                    programs.rgv = {
                        enable = lib.mkEnableOption "rgv";
                        name = lib.mkOption {
                            type = lib.types.string;
                            default = "rgv";
                            description = "The name of the command to run";
                        };
                    };
                    programs.fdv = {
                        enable = lib.mkEnableOption "fdv";
                        name = lib.mkOption {
                            type = lib.types.string;
                            default = "fdv";
                            description = "The name of the command to run";
                        };
                        #package = lib.mkOption {
                        #defaultText = lib.literalMD "`packages.default` from the foo flake";
                        #};
                    };
                };
            }
        );
    };
}
