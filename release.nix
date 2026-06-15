{ pkgs ? import <nixpkgs> {} }:

let
  calc = import ./calc.nix;
in
  pkgs.writeText "calculator-results.txt" ''
    Nix RPN Calculator Test Results:
    
    Test 1: "10 - 4 / 2"     -> Result: ${toString (calc "10 - 4 / 2")}
    Test 2: "2 * (3 + 4)"    -> Result: ${toString (calc "2 * (3 + 4)")}
    Test 3: "5 + 6 / 2"      -> Result: ${toString (calc "5 + 6 / 2")}
  ''
