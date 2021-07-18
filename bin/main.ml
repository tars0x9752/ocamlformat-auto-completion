open Ocamlformat_auto_completion

let response = Completion_provider.auto_complete "profile="

let print_label (v: Lsp.Types.CompletionItem.t) = print_endline v.label  

let () = List.iter print_label response

let text_line_up_to_cursor = Text.get_text_line_up_to_cursor "profile=default
profile=default
profile=default
prof" (Lsp.Types.Position.create ~line:3 ~character:3)

let () = print_endline text_line_up_to_cursor
