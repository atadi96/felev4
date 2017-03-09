// Learn more about F# at http://fsharp.org
// See the 'F# Tutorial' project for more help.

open HelloWorld

[<EntryPoint>]
let main argv = 
    printfn "%A" (TP.ReadFiles "")
    0 // return an integer exit code
