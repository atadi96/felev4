generic
    type A is private;
    type B is private;
    type Index is (<>);
    type TA is array ( Index range <> ) of A;
    type TB is array ( Index range <> ) of B;
    with function Op(X: A) return B;

function Map ( T: TA ) return TB;