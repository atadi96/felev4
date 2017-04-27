namespace ThisChord

open WebSharper
open WebSharper.Sitelets
open WebSharper.UI.Next
open WebSharper.UI.Next.Server

type EndPoint =
    | [<EndPoint "/login">] Login
    | [<EndPoint "/chat">] Chat

module Templating =
    open WebSharper.UI.Next.Html

    type MainTemplate = Templating.Template<"Main.html">
    let Main ctx (title: string) (body: Doc) =
        Content.Page(
            MainTemplate()
                .Title(title)
                .MenuBar(Doc.Empty)
                .Body(body)
                .Doc()
        )

module Site =
    open WebSharper.UI.Next.Html

    let LoginPage ctx =
        Templating.Main ctx "Login" (client <@ Client.Login () @>)

    let ChatPage ctx =
        Templating.Main ctx "Chat" (client <@ Client.Chat () @>)

    [<Website>]
    let Main =
        Application.MultiPage (fun ctx endpoint ->
            match endpoint with
            | EndPoint.Login -> LoginPage ctx
            | EndPoint.Chat -> ChatPage ctx
        )
