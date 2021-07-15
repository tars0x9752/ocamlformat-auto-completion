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
  List.find p options
