-- (f = undefined) <= szokták, ha per pillanat csak fv deklaráció kell, de fordulni kell

-- típuskonstruktor vs adatkonstruktor
-- data Bool = True|False|undefined  -- adatkonstruktor
-- data [a] = []|a:[a] -- típuskonstruktor
-- Bool::* (kind-nak hívják a típus típusát) -- nulladrendő típus
-- []::*->* -- elsőrendű típus
-- [] Int => [Int]
-- Either::*->*->*
-- (,)::*->*->*
-- ghci: "kind" parancs

-- esettanulmány: JSON parser
-- konkrét szintaxis ==parse==> absztrakt szintaxis (JValue <- Haskell) ====> (Doc ==kétféle=formázási=eljárás==> String)
-- formázások: pretty-print vagy machine-friendly
-- AST: abstract syntax tree == ADT algebraic data type
-- a jól megtervezett ADT fontos!
