let add1 a b = a + b
(*let squares = seq {
    for i in 1..100 do
        yield i*i
}*)
let arr = 
    [|
    5
    6
    7
    |]

type Field = 
    | Trap of int
    | Monster of string * int
    | Heal of int
    | Empty

let applyField = fun f ->
    match f with
    | Trap damage -> "You have stepped into a trap and taken " + string damage + " damage!"
    | Monster (name,damage) -> "The monster " + name + " hit you with " + string damage + " damage!"
    | Heal amount -> "You have been healed for " + string amount + " health point!"
    | Empty -> "You advance in the dungeon slowly..."

let dungeon =
    [ 
    Field.Empty
    Field.Empty
    Field.Trap 10
    Field.Empty
    Field.Monster ("Cthulu",500)
    Field.Empty
    Field.Heal 4
    Field.Empty
    Field.Monster ("Numanal Tanszék",9999)
    ]

let story = List.map applyField dungeon

