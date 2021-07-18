open Ocamlformat_auto_completion

let profile_values = Completion_provider.get_suggested_values "profile"

let print_value v = print_endline v

let () = List.iter print_value profile_values
