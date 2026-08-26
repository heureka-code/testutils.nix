{
    self,
    lib,
    ...
}: let
    enabled = {
        config,
        pkgs,
        ...
    }: let
        cfg = config.programs;
    in
        lib.lists.optionals cfg.rg-fuzzy-edit.enable [
            (self.packages.${pkgs.stdenv.hostPlatform.system}.rg-fuzzy-edit.override {
                name = cfg.rg-fuzzy-edit.name;
                help = cfg.rg-fuzzy-edit.help;
                editor = cfg.rg-fuzzy-edit.editor;
            })
        ]
        ++ lib.lists.optionals cfg.fd-fuzzy-edit.enable [
            (self.packages.${pkgs.stdenv.hostPlatform.system}.fd-fuzzy-edit.override {
                name = cfg.fd-fuzzy-edit.name;
                help = cfg.fd-fuzzy-edit.help;
                editor = cfg.fd-fuzzy-edit.editor;
            })
        ];
in {
    flake.nixosModules.fuzzy-edit = {
        pkgs,
        config,
        ...
    }: {
        environment.systemPackages = enabled {
            inherit pkgs config;
        };
    };
    flake.homeModules.fuzzy-edit = {
        pkgs,
        config,
        ...
    }: {
        home.packages = enabled {
            cfg = config.programs;
            inherit pkgs config;
        };
    };
}
