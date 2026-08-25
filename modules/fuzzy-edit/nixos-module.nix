{
    lib,
    config,
    self',
    ...
}: {
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
    config = lib.mkIf config.programs.rgv.enable {
        environment.systemPackages = [
            self'.packages.ripgrep-fuzzy-edit
        ];
    };
}
