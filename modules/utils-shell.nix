{...}: {
    perSystem = {
        self',
        pkgs,
        ...
    }: {
        devShells = rec {
            default = utils;
            utils = pkgs.mkShell {
                nativeBuildInputs = [
                    self'.packages.rg-fuzzy-edit
                    self'.packages.fd-fuzzy-edit
                    self'.packages.bundle-git-repos
                    self'.packages.touch-in-order
                ];
            };
        };
    };
}
