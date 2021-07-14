# ocamlformat_auto_completion

## bootstrap

```sh
opam switch create . 4.11.1 --no-install
eval (opam env) # depends on your shell
opam install . --deps-only
```

## build

```sh
dune build @all
```

## run

```sh
dune exec bin/main.exe
```
