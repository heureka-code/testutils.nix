{
    self,
    lib,
    ...
}: let
    optionDefinitions = config: {
        programs.rg-fuzzy-edit = {
            enable = lib.mkEnableOption "rgv";
            name = lib.mkOption {
                type = lib.types.str;
                default = "rgv";
                description = "The name of the command to run";
            };
            help = lib.mkOption {
                type = lib.types.str;
                description = "The help text fzf should show during selection";
                default = "Select matching line to open file in ${config.programs.rg-fuzzy-edit.editor}";
            };
            editor = lib.mkOption {
                type = lib.types.str;
                description = "The command to run as editor";
                default = "$EDITOR";
            };

            # fzfArgs ? "",
            # rgArgs ? "",
        };
        programs.fd-fuzzy-edit = {
            enable = lib.mkEnableOption "fdv";
            name = lib.mkOption {
                type = lib.types.str;
                default = "fdv";
                description = "The name of the command to run";
            };
            help = lib.mkOption {
                type = lib.types.str;
                description = "The help text fzf should show during selection";
                default = "Select matching file to open in ${config.programs.fd-fuzzy-edit.editor}";
            };
            editor = lib.mkOption {
                type = lib.types.str;
                description = "The command to run as editor";
                default = "$EDITOR";
            };
            excludeGlobs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                description = "A list of globs that should be used for '-E ???' flags to fd";
                default = [
                    # media
                    "*.[mM][pP]4"
                    "*.[mM][pP]3"
                    "*.[mM][kK][vV]"
                    "*.[wW][aA][vV]"
                    # images
                    "*.[jJ][pP][eE]?[gG]"
                    "*.[pP][nN][gG]"
                    # documents
                    "*.[pP][dD][fF]"
                    "*.[oO][dD][tT]"
                    "*.[oO][dD][sS]"
                    "*.[dD][oO][cC][xX]?"
                    "*.[xX][lL][sS][xX]?"
                ];
            };
            #package = lib.mkOption {
            #defaultText = lib.literalMD "`packages.default` from the foo flake";
            #};
        };
    };

    enabledPackages = config: pkgs: let
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
    flake.homeModules.fuzzy-edit = {
        config,
        pkgs,
        ...
    }: {
        config = {
            home.packages = enabledPackages config pkgs;
        };
        options = optionDefinitions config;
    };
}
