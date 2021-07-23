# ocamlformat_auto_completion

Auto completion provider for OCamlFormat config file. (`.ocamlformat`)

VSCode Extension version: [ocamlformat-auto-completion-vscode](https://github.com/tars0x9752/ocamlformat-auto-completion-vscode)

## development

### bootstrap

```sh
opam switch create . 4.12.0 --no-install
opam install . --deps-only
```

> don't forget to eval `opam env` to switch compiler.

### build

```sh
dune build
```

### run

```sh
dune exec bin/main.exe
```
