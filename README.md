# 🧮 Educational Nix RPN Calculator

A simple math expression calculator built from scratch in pure **Nix Expression Language** for learning purposes. 

It handles operator precedence (`+`, `-`, `*`, `/`, `^`) and parentheses by transforming standard expressions into Reverse Polish Notation (RPN) via the **Shunting-yard algorithm**.

## 🚀 How to Run (Nix REPL)

The best way to play with this code is inside the interactive Nix REPL:

```nix
$ nix repl
nix-repl> calc = import ./calc.nix

nix-repl> calc "10 - 4 / 2"
8

nix-repl> calc "2 * (3 + 4)"
14
```

## 📦 Building via CLI

You can trigger the simple evaluator build using:
Bash

```bash
nix-build release.nix
```

This evaluates the pre-defined test cases and creates a ./result file containing a plain text output of the math results.
