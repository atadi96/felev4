generic
    type Item is private;
    type Index is (<>);
    type My_Array is array(Index range <>) of Item;
    with function "<"(I, J: Item) return Boolean is <>;
procedure Sort(A: in out My_Array);