{
    self,
    lib,
    ...
}: {
    flake.nixosModules.fuzzy-edit = {
        pkgs,
        config,
        ...
    }: let
        cfg = config.programs;
    in {
        environment.systemPackages = lib.mkIf cfg.rg-fuzzy-edit.enable [
            (self.packages.${pkgs.stdenv.hostPlatform.system}.rg-fuzzy-edit.override {
                name = cfg.rg-fuzzy-edit.name;
                help = cfg.rg-fuzzy-edit.help;
                editor = cfg.rg-fuzzy-edit.editor;
            })
            (self.packages.${pkgs.stdenv.hostPlatform.system}.fd-fuzzy-edit.override {
                name = cfg.fd-fuzzy-edit.name;
                help = cfg.fd-fuzzy-edit.help;
                editor = cfg.fd-fuzzy-edit.editor;
            })
        ];
    };
}
