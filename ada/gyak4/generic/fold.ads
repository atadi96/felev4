generic
    type Elem is private;
    type Index is (<>);
    type T�mb is array ( Index range <> ) of Elem;
    --type T�mb is array ( Index ) of Elem;
    with function Op( A, B: Elem ) return Elem;
    Start: in Elem;

function Fold ( T: T�mb ) return Elem;

