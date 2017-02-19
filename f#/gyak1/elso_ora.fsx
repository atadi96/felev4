// egy soros komment

(* 
    Ez itt
    egy
    tobb soros
    komment
*)

// Interactiveban futtatashoz: Kodreszlet kijelolese, majd ALT + Enter
// Ertek bindolas
// <- ertekadas operator
// Funkcionalis nyelvek eseten jellemzo modon, egy nevesitett ertek nem valtozhat alapesetben, az alapertelmezett szintaxis
// let egy kulcsszó
// A valtozonev formaja: [a-Z][a-Z 0-9]*
// lehet kotetlen valtozonevet is definialni
// Ez az ertek nem modosithato
let a = 5
// a <- 6 forditasi hiba
let mutable x = 7
x <- 9


// lehet kotetlen valtozonevet is definialni dupla backtickek (Alt Gr + 7 magyar kiosztason) kozott
let ``(╯ຈل͜ຈ) ╯︵ ┻━┻`` = "tableflip"
// printfn fuggveny kiiras az output streamre
// hasznalhato formazasi parancsok
// %s - string
// %d - decimal
// %f - float
// %A - kiirja mint object
// pelda: "%s - %d: %f" "alma" 5 15.
printfn "%s" ``(╯ຈل͜ຈ) ╯︵ ┻━┻``
printfn "%s - %d: %f" "alma" 5 15.

// Tipusok
let i = 5 // val i: int
let f = 5. // val f: float , itt a float = double
let b = true // val b: bool
let c = '#' // val c: char
let str = "fsharp" // val str: string

// logikai operatorok
let ``or`` = true || false
let ``and`` = true && false

// elagazas
// if (condition) then ..statements.. else ..statements..
let conditional (a: int) =
    if a > 0 then
        "Positive"
    else if a < 0 then
        "Negative"
    else
        "Zero"


// Egyedi tipusok
// alias
type A = int
// record without constructor
type Person =
    {
        Name: string
        Age: int
    }

    // print fv egy instanceon
    member this.Print() =
        this.Name + " is " + string this.Age + " years old"
    
    // statikus member fv, a tipusbol erjuk el
    static member Create name age =
        {
            Name = name
            Age = age
        }

// class with constructor
type Person2(name: string, age: int) =
    member this.Name = name
    member this.Age = age
    member this.Print() =
        name + " is " + string age + " years old"
        
// record letrehozasa 
let John =
    {
        Name = "John Doe"
        Age = 21
    }
John.Print()

let Jane = Person.Create "Jane Doe" 20
Jane.Print()
let Jose = Person2("Jose", 70)
Jose.Print()
// Diszkriminalt unio
type Fruit =
    | Apple of int
    | Peach of string
    | Melon of bool

let alma = Fruit.Apple 5
let barack = Fruit.Peach "finom"
let gorogdinnye = Fruit.Melon false

// fuggveny a fuggvenyben
let increment x = 
    let inc y = y + 1 // belso fuggveny, ezen fuggveny torzsen kivul nem lathato
    inc x

// Enumeracio
type Direction =
    | North = 1
    | East = 2
    | South = 3
    | West = 4

// rendezett n-es
type Coordinate = int * int
type Coordinate' =
    {
        X: float
        Y: float
    }

let Origo = (0,0)

// fuggvenyek
// val add1: a:int -> b:int -> int
let add1 a b = a + b
// val add2: a:int * b:int -> int
let add2 (a, b) = a + b
// ugyanaz mint add1
let add1' = fun a b -> a + b
// ugyanaz mint add2
let add2' = fun (a, b) -> a + b
// A nagy kulonbseg a (|>) operator hasznalatanak a lehetosege
// Az add1 egy ket parameteres fuggveny, igy lehet reszlegesen applikalni, valahogy igy elkepzelve
// add1 5 6 = (add1 5) 6
// itt az add1'5 egy fv, ami var egy
let add1'5 = add1 5

// collection tipusok
// list: moho, az ertek azonnal kiertekelodik
let list1 = [ 5; 6 ]
let list2 = [
    5
    6
]
let list3 =
    [
        5
        6
    ]
// seq: lusta, az ertek nem ertekelodik ki azonnal 
let sequence = seq [ 5; 6 ]
// builder expression
let squarenumbers =
    [
        for i in 1..20 do
            yield i * i
    ]

// collectionre jellemzo fuggvenyek
// map: 
// param1: fuggveny ami 't -> 'u szignataju
// param2: egy lista/seq/array ami 't tipusu elemeket tartalmaz
let squarenumbersv1 = List.map (fun i -> i * i) [for i in 1..10 do yield i]
// vagy a pipe operator segitsegevel
let squarenumbersv2 =
    [for i in 1..10 do yield i]
    |> List.map (fun i -> i * i) 

// Pattern Matching - Mintaillesztes
// olyasmi szerkezet mint a switch
// szamit a kulonbozo agak sorrendje, fentrol lefele halad
// mindig az elso igaz agba fut bele
let patternmatch (i: int) =
    match i with // i ertekere matchelunk
    | 1 -> "1-es" // 1 eseten az "1-es" stringgel ter vissza az fv
    | 0 -> "0-as"
    | -1 -> "-1-es"
    | _ -> "Egyeb szam" // _ karakterrel matchelhetunk minden masra, azaz, ha korabban nem allt meg egyik igaz agnal sem, akkor ez az ag fog lefutni

let func = fun (x, y) ->
    match x, y with
    | x1, y1 when x1 = 0. && y1 = 0. -> "Origo"
    | x1, y1 when x1 >= 0. && y1 >= 0. -> "Elso siknegyed"
    | x1, y1 when x1 < 0. && y1 >= 0. -> "Masodik siknegyed"
    | x1, y1 when x1 < 0. && y1 < 0. -> "Harmadik siknegyed"
    | x1, y1 when x1 >= 0. && y1 < 0. -> "Negyedik siknegyed"
    | _ -> failwith "Ervenytelen koordinata" // failwith hasznalhato errorkezelesre

// ugyanaz mint a func
let func' = function
    | x1, y1 when x1 = 0. && y1 = 0. -> "Origo"
    | x1, y1 when x1 >= 0. && y1 >= 0. -> "Elso siknegyed"
    | x1, y1 when x1 < 0. && y1 >= 0. -> "Masodik siknegyed"
    | x1, y1 when x1 < 0. && y1 < 0. -> "Harmadik siknegyed"
    | x1, y1 when x1 >= 0. && y1 < 0. -> "Negyedik siknegyed"
    | _ -> failwith "Ervenytelen koordinata" // failwith hasznalhato errorkezelesre

type Coord =
    {
        X: float
        Y: float
    }
    // visszadja az instance koordinatait egy 
    member this.toCoord() =
        this.X, this.Y

let coords =
    [
        {
            X = 0.
            Y = 0.
        }
        {
            X = 1.5
            Y = 1.2
        }
        {
            X = -10.
            Y = -1.2
        }
        {
            X = 1.5
            Y = -0.5
        }
        {
            X = -7.
            Y = 129.
        }
    ]

let pos =
    coords
    |> List.map (fun c -> func (c.toCoord()))