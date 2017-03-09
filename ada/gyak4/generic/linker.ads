generic
    type Elem is private;
    type Index is private;
    type Tomb is array(Index range<>) of Elem;
    with function Pred(E: Elem) return Boolean;
    
