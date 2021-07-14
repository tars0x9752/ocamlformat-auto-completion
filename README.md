# ocamlformat_auto_completion

## bootstrap

```sh
opam switch create . 4.12.0 --no-install
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
