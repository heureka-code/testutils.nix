{lib, ...}: {
    perSystem = {pkgs, ...}: {
        # Allows definition of system-specific attributes
        # without needing to declare the system explicitly!
        #
        # Quick rundown of the provided arguments:
        # - config is a reference to the full configuration, lazily evaluated
        # - self' is the outputs as provided here, without system. (self'.packages.default)
        # - inputs' is the input without needing to specify system (inputs'.foo.packages.bar)
        # - pkgs is an instance of nixpkgs for your specific system
        # - system is the system this configuration is for

        packages.touch-in-order = let
            tio = lib.readFile ./touch-in-order.py;
        in
            pkgs.writers.writePython3Bin "touch-in-order" {} tio;
    };
}
