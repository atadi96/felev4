namespace ClientServer

open WebSharper
open WebSharper.JavaScript
open WebSharper.UI.Next
open WebSharper.UI.Next.Client
open WebSharper.UI.Next.Html

[<JavaScript>]
module Client =

    type LoginTemplate = Templating.Template<"./login.html">

    let login (uname: IRef<string>) (passwd: IRef<string>) el ev = 
        async {
            let uname = View.GetAsync uname.View
            let pw = View.GetAsync pw.View
            let li = 
                {
                    Username = uname
                    Password = pw
                } : Model.LoginInfo
            let login = Server.Login li
            match login with
            | None -> JS.Alert("Invalid login data!")
            | Some u -> JS.Window.Location.Replace("https://google.com")
            return ()
        }
        |> Async.Start

    let Main (uname: string option) =
        let rvUName = Var.Create ""
        let rvPassword = Var.Create ""
        let loggedin = defaultArg uname ""
        LoginTemplate.Login()
            .LoggedIn(loggedin)
            .UName(rvUname)
            .Password(rvPassword)
            .SignIn(login rvUname rvPassword)
            .Doc()
