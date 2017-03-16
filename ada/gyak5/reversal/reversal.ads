generic
    type Index is (<>);
    type Elem is private;
    type Tomb is array(Index range<>) of Elem;
    
procedure Reversal(T: in out Tomb);