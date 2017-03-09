namespace HelloWorld

module File1 =

    let F (x: int) =
        x + 1

module TP = //as in TypeProvider

    open FSharp.Data

    [<Literal>]
    let samplepath = __SOURCE_DIRECTORY__ + "\\bin\\Debug\\samplepath.csv"
    [<Literal>]
    let path = __SOURCE_DIRECTORY__ + "\\load.csv"

    type CSV = CsvProvider<samplepath>

    let ReadFiles (path: string) =
        let load = CSV.Load(path)
        let rows = load.Rows
        [
            for i in rows ->
                i.Name + "'s age" + string i.Age
        ]
        |> String.concat "\n"
