{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "nix-calc";
  version = "1.0.0";

  # Point to the current repository directory as the source
  src = ./.;

  # Educational project override: 
  # We do not need to unpack or build raw source files, we just copy them.
  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    # Create the target standard Linux directory paths inside the Nix store
    mkdir -p $out/bin
    mkdir -p $out/lib

    # 1. Copy your core calculator logic to the library directory
    cp $src/calc.nix $out/lib/calc.nix

    # 2. Generate a small executable bash wrapper script inside bin/calc
    cat <<EOF > $out/bin/calc
#!/bin/sh
if [ \$# -eq 0 ]; then
    echo "Usage: calc \"mathematical_expression\""
    exit 1
fi

# Evaluate the user expression (\$1) instantly through nix-instantiate
${pkgs.nix}/bin/nix-instantiate --eval --expr "(import $out/lib/calc.nix) \"\$1\""
EOF

    # Make the wrapper script executable
    chmod +x $out/bin/calc
  '';
}
