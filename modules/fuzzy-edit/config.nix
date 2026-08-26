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
        environment.systemPackages = lib.mkIf cfg.rgv.enable [
            (self.packages.${pkgs.stdenv.hostPlatform.system}.ripgrep-fuzzy-edit.override {
                name = cfg.rgv.name;
                help = cfg.rgv.help;
                editor = cfg.rgv.editor;
            })
        ];
    };
}
