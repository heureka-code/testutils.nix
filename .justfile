# here for neovim code formatting of nix files, the format command is set to just _format-files
# and just is used so that alejandra is called from the repository root so that it is aware of alejandra.toml
# other nix repos should provide this recipe if used with this setup
_format-files *Files:
    alejandra {{ Files }}


