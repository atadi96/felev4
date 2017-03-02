let rec factor x =
    match x with
    | 0 -> 1
    | 1 -> 1
    | _ -> x * (factor (x - 1))

factor 4

type A = 
    {
        mutable B: int;
    }

let tryA = { B = 5 }

tryA

tryA.B <- 6

tryA

let arr = [| 5; 6 |]
arr.[0] <- 7

let resarr = new ResizeArray<int>()

resarr.Add(5);
resarr.Add(7);
resarr.Add(6);
resarr.Add(7);
resarr.Add(7);
resarr.Remove(7);
resarr.RemoveAll((fun a -> a = 7));
resarr.RemoveAt(0);

open System.Collections.Generic

let dict = new Dictionary<string, string>();
//dict.["USA"]

let mutable value = ""
dict.TryGetValue("USA", &value)
dict.["USA"] <- "Washington"
dict.TryGetValue("USA", &value)

let ``val`` key = 
    match dict.TryGetValue(key) with
    | true, city -> city
    | false, _   -> "Key not found"

let present = ``val`` "USA"
let notPresent = ``val`` "HUNGARY"

type Dictionary<'t, 'u> with
    member this.TryGetValueOption key = 
        if this.ContainsKey(key) then
            Some (this.[key])
        else
            None

dict.TryGetValueOption "HUNGARY"
dict.TryGetValueOption "USA"

let rec fibonacchi n =
    match n with
    | 0 -> 1
    | 1 -> 1
    | n -> (fibonacchi (n - 1)) + (fibonacchi (n - 2))

let powcache = new Dictionary<(int * int), int>()

let (^*^) i1 i2 =
    let sw = System.Diagnostics.Stopwatch()
    sw.Start()
    match powcache.TryGetValueOption ((i1, i2)) with
    | Some res ->
        sw.Stop()
        (sw.ElapsedMilliseconds, res)
    | None -> 
        let res = 
            List.replicate i2 i1
            |> List.fold (fun s t -> s * t) 1
        powcache.[(i1,i2)] <- res
        sw.Stop()
        (sw.ElapsedMilliseconds, res)


2 ^*^ 10
2 ^*^ 10


