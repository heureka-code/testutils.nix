{
    pkgs,
    lib,
    name ? "fdv",
    help ? "Select matching file to open in ${editor}",
    editor ? "$EDITOR",
    fzfArgs ? "",
    fdArgs ? "",
    excludeGlobs ? ["*.pdf" "*.PDF" "*.mp4" "*.mp3" "*.odt" "*.docx"],
}: let
    fd = "${pkgs.fd}/bin/fd";
    fzf = "${pkgs.fzf}/bin/fzf";
    cat = "${pkgs.coreutils}/bin/cat";
    xargs = "${pkgs.findutils}/bin/xargs";
    mktemp = "${pkgs.mktemp}/bin/mktemp";
    rm = "${pkgs.coreutils}/bin/rm";
    exclude = lib.map (n: "-E \"${n}\"") excludeGlobs;
in
    pkgs.writeShellApplication {
        inherit name;
        text = ''
            tmp_file_for_writing=$(${mktemp})
            if ${fd} -F ${exclude} ${fdArgs} "$@" | ${fzf} --cycle -1 -0 --header="${help}" ${fzfArgs} > "$tmp_file_for_writing"; then
            	${cat} "$tmp_file_for_writing" | ${xargs} -d'\n' -n1 "${editor}";
            fi
            ${rm} -f "$tmp_file_for_writing"
        '';
        meta = {
            description = "Uses fd to search for a pattern and shows a menu using fzf. The choice is then opened in $EDITOR";
        };
    }
