let inc x = x + 1
let inc2 f x =
    x
    |> f
    |> f

let inc2' f x =
    f (f x)

inc2 inc 5

let (|>) x f = f x
let mul2 x = x * 2

let f x =
    x
    |> (inc >> mul2) //pipe operátor

f 5

let outa (str: string) = 
    str.ToCharArray()
    |> Array.filter (fun c -> c <> 'a') //<> not equals
    |> Array.map (fun x -> string x)
    |> String.concat ""
(*
type Option<'t> =
    | Some of 't
    | None
*)
let outa' (str: string) = 
    str.ToCharArray()
    |> Array.choose (fun c->
        if c <> 'a' then
            Some (string c)
        else
            None
        )
    |> String.concat ""

let sumList l =
    l
    |> List.fold (fun s t -> s + t) 0

sumList [3;5;5]

let rec sumList' l =
    match l with
    | [] -> 0
    | x::[] -> x
    | x::xs -> x + sumList' xs

let r1 = sumList [3;5;5]
let r2 = sumList' [3;5;5]

type Result<'t> = 
    | Ok of 't
    | Err of string
    static member Map (f: 't -> 'u) res =
        match res with
        | Ok t -> Ok (f t)
        | Err r -> Err r
    static member OrElse (def: 't) (res: Result<'t>) = 
        match res with
        | Ok k  -> k
        | Err _ -> def


let divideBy (t: float) (d: float) :float =
    match d with
    | 0.0 -> failwith "Divide by zero"
    | d   -> t / d

let i : int = 5

let divideBy' (t: float) (d: float) : Result<float> =
    match d with
    | 0.0 -> Err "Divide by zero"
    | d   -> Ok (t / d)

let result = 
    divideBy' 5.0 2.5
    |> Result.Map (fun x -> x + 1.0)
    |> Result.OrElse -1.

let result2 = 
    divideBy' 5.0 0.0
    |> Result.Map (fun x -> x + 1.0)
    |> Result.OrElse -1.

let unit = ()
(*
printf "%A" [
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
    "asdfasdfasdfasdfasdfasdfasdf"
] *)
let x = 
    [
        "asd"
        "qwe"
        "yxc"
    ]
    |> List.map (printf "%A")
    |> ignore
    5

let x' = 
    [
        "asd"
        "qwe"
        "yxc"
    ]
    |> List.iter (printf "%A")

List.collect id [[5;6]; [8;9]]
List.collect (fun x -> List.replicate 5 x) [5;6]