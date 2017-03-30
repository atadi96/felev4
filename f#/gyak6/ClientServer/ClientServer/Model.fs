namespace ClientServer

open WebSharper
open WebSharper.UI.Next

module Model =

    type LoginInfo = 
        {
            Username: string
            Password: string
        }

    [<Javascript>]
    let LoggedIn : Var<dolgok ¯\_(ツ)_/¯>