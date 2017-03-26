generic
    type Item is private;
    type Item_Array is array(Positive range <>) of Item;
package Tables is
    type Table(Capacity: Positive) is private;
    Table_Insert_Error: exception;
    
    function Size(T: Table) return Natural;
    function Get_Table(T: Table) return Item_Array;
    procedure Insert(T: in out Table; I: Item);
    
    generic
        with function Predicate(A: Item) return Boolean;
        procedure Where(T: Table; A: out Item_Array; N: out Natural);
        
    generic
        with function "<"(A, B: Item) return Boolean is <>;
        procedure Sort_Table(T: in out Table);
        
    private
        type Table(Capacity: Positive) is record
            Rows: Item_Array(1..Capacity);
            Size: Natural := 0;
        end record;
end Tables;
