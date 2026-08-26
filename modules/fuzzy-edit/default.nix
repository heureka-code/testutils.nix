{moduleWithSystem, ...}: {
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
                    self'.packages.rg-fuzzy-edit
                    self'.packages.fd-fuzzy-edit
                ];
            };
        };

        packages = {
            rg-fuzzy-edit = pkgs.callPackage ./rgv.nix {};
            fd-fuzzy-edit = pkgs.callPackage ./fdv.nix {};
        };
    };
    imports = [./config.nix ./options.nix];

    # flake = {
    #     nixosModules.fuzzy-edit = moduleWithSystem (
    #         perSystem @ {
    #             config,
    #             pkgs,
    #             self',
    #             ...
    #         }: nixos @ {...}: let
    #         in {
    #         }
    #     );
    # };
}
