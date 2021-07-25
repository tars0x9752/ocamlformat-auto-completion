class lsp_server =
  object
    inherit Linol_lwt.Jsonrpc2.server

    val content_table : (Lsp.Types.DocumentUri.t, string) Hashtbl.t =
      Hashtbl.create 32

    method on_notif_doc_did_open ~notify_back d ~content : unit Linol_lwt.t =
      Hashtbl.add content_table d.uri content;
      notify_back#send_log_msg ~type_:Linol_lwt.MessageType.Info
        "did open received"

    method on_notif_doc_did_change ~notify_back d _c ~old_content:_old
        ~new_content =
      Hashtbl.replace content_table d.uri new_content;
      notify_back#send_log_msg ~type_:Linol_lwt.MessageType.Info
        "did change received"

    method on_notif_doc_did_close ~notify_back:_ d : unit Linol_lwt.t =
      Hashtbl.remove content_table d.uri;
      Linol_lwt.return ()

    method! on_req_completion ~notify_back:_ ~id:_ ~uri ~pos ~ctx:_ _ =
      let content = Hashtbl.find content_table uri in
      let res = Completion_provider.handle_completion_request content pos in
      Linol_lwt.IO_lwt.return (Some (`List res))

    method! config_sync_opts =
      Linol_lwt.TextDocumentSyncOptions.create ~openClose:true
        ~change:Linol_lwt.TextDocumentSyncKind.Incremental ~willSave:false ()

    method! config_modify_capabilities (c : Linol_lwt.ServerCapabilities.t)
        : Linol_lwt.ServerCapabilities.t =
        let completionProvider = Linol_lwt.CompletionOptions.create ~resolveProvider:false () in 
        {c with completionProvider = Some completionProvider}
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
