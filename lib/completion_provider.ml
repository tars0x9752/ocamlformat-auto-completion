open Import
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
  CompletionItem.create ~label:value ~kind:CompletionItemKind.Value
    ~documentation

let create_value_completion_item_list documentation values =
  let f = create_value_completion_item documentation in
  List.map f values

let create_key_completion_item_list () =
  let f option =
    CompletionItem.create ~label:option.key ~kind:CompletionItemKind.Property
  in
  List.map f options

let auto_complete_option_values text_of_line_up_to_cursor =
  let key = get_option_key text_of_line_up_to_cursor in
  let suggested_values = get_suggested_values key in
  let finder option = option.key = key in
  let docs = (List.find finder options).documentation in
  create_value_completion_item_list (`String docs) suggested_values

let handle_completion_request
    (current_text_document : DidOpenTextDocumentParams.t)
    (params : CompletionParams.t) =
  let is_request_same_as_current_text_document =
    Uri.equal current_text_document.textDocument.uri params.textDocument.uri
  in
  if is_request_same_as_current_text_document then
    auto_complete_option_values current_text_document.textDocument.text
  else []
