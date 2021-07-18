open Ocamlformat_auto_completion

let response = Completion_provider.auto_complete "profile="

let print_label (v: Lsp.Types.CompletionItem.t) = print_endline v.label  

let () = List.iter print_label response
