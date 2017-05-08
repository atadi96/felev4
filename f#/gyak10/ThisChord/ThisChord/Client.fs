namespace ThisChord

open WebSharper
open WebSharper.JavaScript
open WebSharper.UI.Next
open WebSharper.UI.Next.Client
open WebSharper.UI.Next.Html

module WSClient =

    open WebSharper.Owin.WebSocket.Server
    open WebSharper.Owin.WebSocket.Client

    let wsclient : Var<Agent<S2C, C2S> option> = Var.Create None

    let clientAgent = null

[<JavaScript>]
module Client =

    type EP =
        | Login
        | Chat

    let Route =
        RouteMap.Create
            (function
                | Login -> ["login"]
                | Chat -> ["chat"]
            )
            (function
                | []
                | ["login"] -> Login
                | ["chat"] -> Chat
                | _ -> failwith "404"
            )
        

    let Login () =
        let rvInput = Var.Create ""
        div [
            Doc.Input [] rvInput
            Doc.Button "Login" [] (fun () ->
                //bejelentkezes
                ()
            )
        ]

    let Chat () =
        let rvInput = Var.Create ""
        div [
            Doc.Input [] rvInput
            Doc.Button "Send" [] (fun () ->
                //bejelentkezes
                ()
            )
        ]
    let Main (ws: WebSocketServer<S2C, C2S>) =
        let messages = ListModel.Create (fun (m: Message) -> m.Id) []
        let ep = Endpoint.CreateRemote("sw://localhost:1373/wsserver", JsonEncoding.Typed)

        View.Const ()
        |> View.MapAsync (fun () ->
            async {
                let! server =
                    Connect ep <| fun agent ->
                        fun wmmsg ->
                            match wsmsg with
                            | Message (C2S.Msg msg) ->
                                messages.Add msg
                            | Message.Close -> ()
                            | Message.Error -> ()
                            | Message.Open -> ()
            }
        )

