with Sort;
package body Tables is
    function Size(T: Table) return Natural is
    begin
        return T.Size;
    end Size;
    
    function Get_Table(T: Table) return Item_Array is
    begin
        return T.Rows;
    end Get_Table;
    
    procedure Insert(T: in out Table; I: Item) is
    begin
        if Size(T) >= T.Capacity then
            raise Table_Insert_Error;
        else
            T.Size := T.Size + 1;
            T.Rows(T.Size) := I;
        end if;
    end Insert;
    
    procedure Where(T: Table; A: out Item_Array; N: out Natural) is
    begin
        N := 0;
        for I in T.Rows'Range loop
            if Predicate(T.Rows(I)) then
                N := N + 1;
                if not (N > A'Last) then
					A(N) := T.Rows(I);
				end if;
            end if;
        end loop;
    end Where;
    
    procedure Sort_Table(T: in out Table) is
        procedure Item_Sort is new Sort(Item, Positive, Item_Array, "<");
    begin
        Item_Sort(T.Rows);
    end Sort_Table;
end Tables;
