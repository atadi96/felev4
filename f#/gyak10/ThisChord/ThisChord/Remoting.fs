namespace ThisChord

open System.Threading
open WebSharper
open WebSharper.Web
open System.Collections.Generic

module Server =

    open WebSharper.Owin.WebSocket
    open WebSharper.Owin.WebSocket.Server

    let idgen = 
        let x = ref 0
        fun () -> 
            Interlocked.Increment x

    type Users = Dictionary<WebSocketClient<S2C, C2S>, string>

    let Run () : Agent<S2C, C2S> =
        let users = new Users()
        fun client ->
            async {
                return
                    (fun msg ->
                        match msg with
                        | Message (C2S.Login uname) ->
                            users.Add(client, uname)
                        | Message (C2S.Msg message) ->
                            match users.TryGetValue(client) with
                            | (true,u) ->
                                users
                                |> Seq.iter (fun kv ->
                                    let smsg = 
                                        {
                                            Id = idgen ()
                                            Username = u
                                            Message = message
                                        }
                                    kv.Key.Post(S2C.Msg smsg)
                                )
                            | _ -> ()
                        | Message.Close ->
                            users.Remove client |> ignore
                        | Message.Error e -> ()
                    )
            }
            