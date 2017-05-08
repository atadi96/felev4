namespace ThisChord

open WebSharper

[<JavaScript>]
[<AutoOpen>]
module Model =

    type Message = {
        Id: int
        Username: string
        Message: string
    }

    type S2C = //server to client
        | Msg of Message

    type C2S = //client to server
        | Login of username: string
        | Msg of message: string