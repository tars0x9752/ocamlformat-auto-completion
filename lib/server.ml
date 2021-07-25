class lsp_server =
  object
    inherit Linol_lwt.Jsonrpc2.server

    val content_table : (Lsp.Types.DocumentUri.t, string) Hashtbl.t =
      Hashtbl.create 32

    method on_notif_doc_did_open ~notify_back:_ d ~content : unit Linol_lwt.t =
      Hashtbl.add content_table d.uri content;
      Linol_lwt.return ()

    method on_notif_doc_did_change ~notify_back:_ d _c ~old_content:_old
        ~new_content =
      Hashtbl.replace content_table d.uri new_content;
      Linol_lwt.return ()

    method on_notif_doc_did_close ~notify_back:_ d : unit Linol_lwt.t =
      Hashtbl.remove content_table d.uri;
      Linol_lwt.return ()

    method! on_req_completion ~notify_back:_ ~id:_ ~uri ~pos ~ctx:_ _ =
      let content = Hashtbl.find content_table uri in
      let res = Completion_provider.handle_completion_request content pos in
      Linol_lwt.return (Some (`List res))
  end

let run () =
  let s = new lsp_server in
  let server = Linol_lwt.Jsonrpc2.create_stdio s in
  let task = Linol_lwt.Jsonrpc2.run server in
  match Linol_lwt.run task with
  | () -> ()
  | exception e ->
    let e = Printexc.to_string e in
    Printf.eprintf "error: %s\n%!" e;
    exit 1
