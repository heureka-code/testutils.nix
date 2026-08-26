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
            self.packages.${pkgs.stdenv.hostPlatform.system}.ripgrep-fuzzy-edit
        ];
    };
}
