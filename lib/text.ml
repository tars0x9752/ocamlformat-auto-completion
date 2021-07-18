let eol = '\n'

let get_text_line_list text = String.split_on_char eol text

let get_entire_line_text text (position : Lsp.Types.Position.t) =
  let text_line_list = get_text_line_list text in
  List.nth text_line_list position.line

let get_text_line_up_to_cursor text (position : Lsp.Types.Position.t) =
  let entire_text = get_entire_line_text text position in
  String.sub entire_text 0 position.character
