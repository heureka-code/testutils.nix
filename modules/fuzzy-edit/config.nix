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
        cfg.rgv = config.programs.rg-fuzzy-edit;
        cfg.fdv = config.programs.fd-fuzzy-edit;
    in {
        environment.systemPackages = lib.mkIf cfg.rgv.enable [
            (self.packages.${pkgs.stdenv.hostPlatform.system}.rg-fuzzy-edit.override {
                name = cfg.rgv.name;
                help = cfg.rgv.help;
                editor = cfg.rgv.editor;
            })
            (self.packages.${pkgs.stdenv.hostPlatform.system}.fd-fuzzy-edit.override {
                name = cfg.fdv.name;
                help = cfg.fdv.help;
                editor = cfg.fdv.editor;
            })
        ];
    };
}
