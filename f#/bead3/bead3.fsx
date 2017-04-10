
type Expression<'T> =
    | Number of 'T
    | Add of Expression<'T> * Expression<'T> // +
    | Sub of Expression<'T> * Expression<'T> // -
    | Mul of Expression<'T> * Expression<'T> // *
    | Div of Expression<'T> * Expression<'T> // /
    | Pow of Expression<'T> * Expression<'T> // 2^3 = 8
    | Rem of Expression<'T> * Expression<'T> // 16%5 = 1

// az operátorok
type Ops<'T> = { 
    Add : 'T -> 'T -> 'T;
    Substract: 'T -> 'T -> 'T;
    Divide : 'T -> 'T -> 'T;
    Multiply: 'T -> 'T -> 'T;
    Remainder: 'T -> 'T -> 'T;
    Pow: 'T -> 'T -> 'T
    }

let rec eval (e: Expression<'T>) (ops: Ops<'T>): 'T = 
    match e with
    | Number t -> t
    | Add (l,r) -> ops.Add (eval l ops) (eval r ops)
    | Sub (l,r) -> ops.Substract (eval l ops) (eval r ops)
    | Div (l,r) -> ops.Divide (eval l ops) (eval r ops)
    | Mul (l,r) -> ops.Multiply (eval l ops) (eval r ops)
    | Pow (l,r) -> ops.Pow (eval l ops) (eval r ops)
    | Rem (l,r) -> ops.Remainder (eval l ops) (eval r ops)


let myOps: Ops<int> = {
    Add = (+);
    Substract = (-);
    Divide = (/);
    Multiply = (*);
    Remainder = (%);
    Pow = pown
    }

let testExpr: Expression<int> = Add (Mul (Number 2, Number 3), Number 5)

let lul = eval testExpr myOps

sprintf "%i" lul