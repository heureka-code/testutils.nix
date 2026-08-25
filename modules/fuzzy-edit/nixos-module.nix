{
    config,
    lib,
    ...
}: {
    config = {
        environment.systemPackages = lib.mkIf config.programs.rgv.enable [
            config.packages.ripgrep-fuzzy-edit
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
