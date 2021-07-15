# ocamlformat_auto_completion

Translation by OCaml for core part of [ocamlformat-auto-completion-vscode](https://github.com/tars0x9752/ocamlformat-auto-completion-vscode).

## bootstrap

```sh
opam switch create . 4.12.0 --no-install
opam install . --deps-only
```

> don't forget to eval `opam env` to switch compiler.

## build

```sh
dune build
```

## run

```sh
dune exec bin/main.exe
```
