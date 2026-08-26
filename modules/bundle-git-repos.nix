{
    perSystem = {pkgs, ...}: {
        packages.bundle-git-repos = pkgs.stdenv.mkDerivation {
            pname = "bundle-git-repos";
            version = "0.1.0";

            src = ./bundle-git-repos.py;
            unpackPhase = ''
                mkdir -p $out/bin
                cp $src $out/bundle-git-repos.py
            '';

            nativeBuildInputs = [
                pkgs.makeWrapper
            ];

            installPhase = ''
                makeWrapper ${pkgs.python3}/bin/python $out/bin/bundle-git-repos \
                  --add-flags $out/bundle-git-repos.py \
                  --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.git]}
            '';
        };
    };
}
