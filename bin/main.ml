open Ocamlformat_auto_completion

let profile = Completion_provider.get_suggested_values "profile"

let print_value v = print_endline v

let () = List.iter print_value profile.values
