{
    pkgs,
    name ? "rgv",
    help ? "Select matching line to open file in ${editor}",
    editor ? "$EDITOR",
    fzfArgs ? "",
    rgArgs ? "",
}: let
    fzf = "${pkgs.fzf}/bin/fzf";
    rg = "${pkgs.ripgrep}/bin/rg";
    sed = "${pkgs.gnused}/bin/sed";
    cat = "${pkgs.coreutils}/bin/cat";
    xargs = "${pkgs.findutils}/bin/xargs";
    mktemp = "${pkgs.mktemp}/bin/mktemp";
    rm = "${pkgs.coreutils}/bin/rm";
in
    pkgs.writeShellApplication {
        inherit name;
        text = ''
            tmp_file_for_writing=$(${mktemp})
            if ${rg} ${rgArgs} -n "$@" | ${fzf} -1 -0 --cycle --header="${help}" ${fzfArgs} > "$tmp_file_for_writing"; then
            	${cat} "$tmp_file_for_writing" | ${sed} -E "s/^([^:]+)\:([0-9]+)\:(.*)/+\2\n\1/g" | ${xargs} -d'\n' -n2 "${editor}";
            fi
            ${rm} -f "$tmp_file_for_writing"
        '';
        meta = {
            description = "Uses rg to search for a pattern and shows a menu using fzf. The file containing the selected line is then opened in $EDITOR with exactly this line focused (depending on editor)";
        };
    }
