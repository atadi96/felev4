generic
    type Item is private;
    type Index is (<>);
    type Vector is array(Index range <>) of Item;
function Most_Frequent(V: Vector) return Item;