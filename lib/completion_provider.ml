(* open Import *)
open Options_v0_18_0

let eq = '='

let has_eq_sign line_text = String.contains line_text eq

let has_option_key line_text = has_eq_sign line_text

let get_option_key line_text =
  let raw = String.split_on_char eq line_text in
  let rawKey = List.nth raw 0 in
  String.trim rawKey |> String.lowercase_ascii

let get_suggested_values key =
  let p option = option.key = key in
  let option = List.find p options in
  option.values

let create_value_completion_item documentation value =
  Lsp.Types.CompletionItem.create ~label:value
    ~kind:Lsp.Types.CompletionItemKind.Value ~documentation ()

let create_value_completion_item_list documentation values =
  let f = create_value_completion_item documentation in
  List.map f values

let create_key_completion_item_list () =
  let f option =
    let documentation = `String option.documentation in
    Lsp.Types.CompletionItem.create ~label:option.key
      ~kind:Lsp.Types.CompletionItemKind.Property ~documentation ()
  in
  List.map f options

let auto_complete_value text_line_up_to_cursor =
  let key = get_option_key text_line_up_to_cursor in
  let suggested_values = get_suggested_values key in
  let finder option = option.key = key in
  let docs = (List.find finder options).documentation in
  create_value_completion_item_list (`String docs) suggested_values

let auto_complete_key = create_key_completion_item_list

let auto_complete text_line_up_to_cursor =
  if has_option_key text_line_up_to_cursor then
    auto_complete_value text_line_up_to_cursor
  else auto_complete_key ()

let handle_completion_request text position =
  let entire_line_text = Text.get_entire_line_text text position in
  let text_line_up_to_cursor =
    Text.get_text_line_up_to_cursor entire_line_text position
  in
  auto_complete text_line_up_to_cursor
