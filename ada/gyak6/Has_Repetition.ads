generic
    type Item is private;
    type Index is (<>);
    type Vector is array(Index range <>) of Item;
    
function Has_Repetition(V: Vector) return Boolean;