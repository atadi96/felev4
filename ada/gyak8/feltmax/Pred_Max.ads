generic
    type Index is (<>);
    type Elem is private;
    type Elem_Array is array (Index range <>) of Elem;
    with function Predicate(E: Elem) return Boolean;
    with function "<"(L, R: Elem) return Boolean is <>;

procedure Pred_Max(A: in Elem_Array; Found: out Boolean; E: Elem); 
    