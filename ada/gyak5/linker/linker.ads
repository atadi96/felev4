generic
    type Elem is private;
    type Index is (<>);
    type Tomb is array(Index range<>) of Elem;
    with function Pred(E: Elem) return Boolean;
    
procedure Linker(T:Tomb; Found: out Boolean; I: out Index);
    
