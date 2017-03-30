generic
    type Element is private;
    type Index is (<>);
    type Grid is array (Index range <>, Index range <>) of Element;
    with function Predicate(E: Element) return Boolean;
function Count_Value(G: Grid) return Natural;
