generic
    type Item is private;
    type Index is (<>);
    type Item_Array is array(Index range <>) of Item;
    with function "<"(A, B: Item) return Boolean is <>;
    
procedure Sort(A: in out Item_Array);