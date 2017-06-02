namespace Bead5

open WebSharper
open WebSharper.JavaScript
open WebSharper.JQuery
open WebSharper.UI.Next
open WebSharper.UI.Next.Client
open WebSharper.UI.Next.Templating
open WebSharper.UI.Next.Html

[<JavaScript>]
module Client =

    let mutable number = 0 //TODO: ezt még egyszer megbosszulom valakin

    type EndPoint = Home | Details

    let routeMap = 
        RouteMap.Create
        <| function
            | Home -> []
            | Details -> ["details"]
        <| function
            | [] -> Home
            | ["details"] -> Details
            | _ -> failwith "404"

    let HomePage setSite =
        let rv = Var.Create <| string number
        Doc.Concat [
            h1 [text "Főoldal"]
            Doc.Input [] rv ; br []
            Doc.Button
                <| "Mentés"
                <| []
                <| fun _ ->
                    try
                        let i = System.Int32.Parse rv.Value
                        number <- i
                        ()
                    with _ -> ()
            br []
            Doc.Link "Adatok a számról" [Attr.Create "href" "details"] <| fun _ -> setSite Details
        ]

    type NumberDetails = 
        {
            even: bool
            prime: bool
            log: option<float>
            modulo: int
        }


    let numberDetails number =
        let safeLog number =
            if number <= 0 then
                None
            else
                Math.Log2 <| float number
                |> Some
        let isPrime n =
            let rec mods what =
                if what = n / 2 + 1 then
                    true
                else
                    if n % what = 0 then
                        false
                    else
                        mods <| what + 1 
            if n <= 1 then
                false
            else
                mods 2
        {
            even = number % 2 = 0
            prime = isPrime number
            log = safeLog number
            modulo = number % 100
        }

    let DetailsPage setSite = 
        let details = numberDetails number
        Doc.Concat [
            h1 [text "Részletek"]
            br []
            text "A szám:"; text (string number); br []
            table [
                tr [
                    th [text "Tulajdonság"]; th [text "Érték"]
                ]
                tr [
                    td [text "Páros"]; td [text <| if details.even then "Igen" else "Nem"]
                ]
                tr [
                    td [text "Prím"]; td [text <| if details.prime then "Igen" else "Nem"]
                ]
                tr [
                    td [text "Kettes alapú logaritmus"]; td [text <| match details.log with | Some f -> string f | None -> "Nincs" ]
                ]
                tr [
                    td [text "Százzal vett maradék"]; td [text (string details.modulo)]
                ]
            ]
            Doc.Link "Főoldal" [] <| fun _ -> setSite Home
        ]
        


    [<SPAEntryPoint>]
    let Main () =
        let router = RouteMap.Install routeMap
        let page (site : EndPoint) =
            let setSite = Var.Set router
            match site with
            | Home -> HomePage setSite
            | Details -> DetailsPage setSite
        let updateableDoc route = 
            View.FromVar route
            |> View.Map page
            |> Doc.EmbedView 
        
        Doc.RunById "main" (updateableDoc router)
