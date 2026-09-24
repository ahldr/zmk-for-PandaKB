{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    zmk-nix = {
      url = "github:lilyinstarlight/zmk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, zmk-nix }: let
    forAllSystems = nixpkgs.lib.genAttrs (nixpkgs.lib.attrNames zmk-nix.packages);
  in {
    packages = forAllSystems (system: rec {
      default = firmware;

      firmware_L = zmk-nix.legacyPackages.${system}.buildKeyboard {
        name = "firmware-L";

        src = nixpkgs.lib.sourceFilesBySuffices self [ ".board" ".c" ".h" ".cmake" ".conf" ".defconfig" ".dts" ".dtsi" ".json" ".keymap" ".overlay" ".shield" ".yml" "_defconfig" "CMakeLists.txt" ];

        board = "nice_nano";
        shield = "Lily58_L Nice_view_config nice_view_hammerbeam";

        zephyrDepsHash = "sha256-uuHPDJvU1btF5a6nIfiWEADAlrAHYbg3MBaVOlPciLM=";
      };

      firmware_R = zmk-nix.legacyPackages.${system}.buildKeyboard {
        name = "firmware-R";

        src = nixpkgs.lib.sourceFilesBySuffices self [ ".board" ".c" ".h" ".cmake" ".conf" ".defconfig" ".dts" ".dtsi" ".json" ".keymap" ".overlay" ".shield" ".yml" "_defconfig" "CMakeLists.txt" ];

        board = "nice_nano";
        shield = "Lily58_R Nice_view_config nice_view_hammerbeam";

        zephyrDepsHash = "sha256-uuHPDJvU1btF5a6nIfiWEADAlrAHYbg3MBaVOlPciLM=";
        inherit (firmware_L) westDeps;
      };

      firmware = nixpkgs.legacyPackages.${system}.runCommand "firmware" {
        parts = [ "L" "R" ];
        inherit firmware_L firmware_R;
        passthru = {
          inherit firmware_L firmware_R;
          parts = [ "L" "R" ];
        };
        meta = {
          description = "ZMK firmware";
          license = nixpkgs.lib.licenses.mit;
          platforms = nixpkgs.lib.platforms.all;
        };
      } ''
        mkdir $out
        ln -s $firmware_L/zmk.uf2 $out/zmk_L.uf2
        ln -s $firmware_R/zmk.uf2 $out/zmk_R.uf2
      '';

      flash = zmk-nix.packages.${system}.flash.override { inherit firmware; };
      update = zmk-nix.packages.${system}.update;
    });

    devShells = forAllSystems (system: {
      default = zmk-nix.devShells.${system}.default;
    });
  };
}
