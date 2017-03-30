namespace ClientServer

open WebSharper

module Server =

    let username = "poi"
    let password = "987"

    [<Rpc>]
    let Login (logindata: Model.LoginInfo) =
        async {
            let ctx = Web.Remoting.GetContext()
            if logindata.Username = username && logindata.Password = password then
                do! ctx.UserSession.LoginUser (username, true)
                return Some ()
            else
                return None
        }
