(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(* * * F# - 2. heti beadandó - Abonyi-Tóth Ádám - DKC31P * * *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)

let rec factorial n = 
    match n with
    | 0 -> 1
    | 1 -> 1
    | n -> n * factorial (n-1)

let rec fibonacci n =
    match n with
    | 0 -> 1
    | 1 -> 1
    | n -> fibonacci (n-1) + fibonacci (n-2)

let repeat n = Seq.concat [for i in 1..n -> [for j in 1..i -> i]]
