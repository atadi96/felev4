(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(* * * F# - 1. heti beadandó - Abonyi-Tóth Ádám - DKC31P * * *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)

type Subject(名前: string, kredit: int, 先生: string, マーク: int) =
    member this.名前 = 名前
    member this.kredit = kredit
    member this.先生 = 先生
    member this.マーク = マーク
    override this.ToString() =  "Tantárgy neve: " + this.名前 + 
                                ", Oktató: " + this.先生 + 
                                ", Kreditérték: " + string this.kredit + 
                                ", Érdemjegy: " + string this.マーク

type 学生(subjects: seq<Subject>)  =
    member this.Subjects = subjects 
    member this.atlag() = (fun (sum, num) -> float(sum)/float(num)) (this.genericOsszeg this.sima)
    member this.kreditindex() = (fun (sum, _) -> float(sum)/float(30)) (this.genericOsszeg this.kredites)
    member private this.sima(s:Subject) = s.マーク
    member private this.kredites(s:Subject) = s.マーク * s.kredit
    member private this.genericOsszeg(sulyozas) = (Seq.fold (fun (左, num) 右 -> (左 + 右, num + 1)) (0,0) (Seq.map sulyozas this.Subjects))

let student = 学生([ Subject("Fordprog", 2, "Dévai", 5)
                  ; Subject("F#", 2, "Uri", 5)
                  ; Subject("Analízis 3", 2, "Szili", 2)]
)

let atlag = student.atlag()
let kreditindex = student.kreditindex()
let targyStringek = (student.Subjects |> Seq.map (fun (s:Subject) -> s.ToString()))
