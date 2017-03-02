with Ada.Integer_Text_IO;
with Ada.Text_IO;
use Ada.Text_IO;
procedure Main is
    type Index is new Integer;
    type Elem is new Integer;
    type Tomb is array(Index range <>) of Elem;
    type Matrix is array(Index range <>, Index range <>) of Elem;

    function Sum_Recursive(T: in Tomb) return Elem is 
        function Sum_Recursive_Inner(T: in Tomb; I: in Index ) return Elem is
        begin
            if I in T'Range then
                return T(I) + Sum_Recursive_Inner(T, Index'Succ(I));
            else
                return 0;
            end if;
        end Sum_Recursive_Inner;
    begin
        return Sum_Recursive_Inner(T, T'First);
    end Sum_Recursive;
    
    procedure Bubble_Sort(T: in out Tomb) is
        Temp: Elem;
    begin
        for I in reverse T'First..Index'Pred(T'Last) loop
            for J in T'First..I loop
                if T(J) > T(Index'Succ(J)) then
                    Temp := T(J);
                    T(J) := T(Index'Succ(J));
                    T(Index'Succ(J)) := Temp;
                end if;
            end loop;
        end loop;
    end Bubble_Sort;
    
    function Sum_Of_Main_Diagonal(M: Matrix) return Elem is
        Sum: Elem := 0;
    begin
        for I in M'Range loop
           Sum := Sum + M(I,I); 
        end loop;
        return Sum;
    end Sum_Of_Main_Diagonal;
    
    procedure Print_Local_Maximums(T: Matrix) is
        function Get_Column_Minimum(T: Matrix; Column: Index) return Elem is
            Min: Elem := T(T'First(1), Column);
        begin
            for I in Index'Succ(T'First(1))..T'Last(1) loop
                if T(I,Column) < Min then
                    Min := T(I,Column);
                end if;
            end loop;
            return Min;
        end Get_Column_Minimum;
        function Get_Row_Maximum(T: Matrix; Row: Index) return Elem is
            Max: Elem := T(Row, T'First(2));
        begin
            for I in Index'Succ(T'First(2))..T'Last(2) loop
                if T(Row,I) < Max then
                    Max := T(Row,I);
                end if;
            end loop;
            return Max;
        end Get_Row_Maximum;
    begin
        
    end Print_Local_Maximums;
    
    My_Array: Tomb := (-1,5,4,0,-2);
    My_Matrix: Matrix := ((0,1,2),(-6,-4,3),(4,6,8));
begin
    Put("A pelda tomb: (-1,5,4,0,-2)"); New_Line(1);
    Put("Elemek rekurziv osszege: ");
    Put(Sum_Recursive(My_Array)'Image); New_Line(2);
    Put("Bubble Sort"); New_Line(1);
    Bubble_Sort(My_Array);
    for I in My_Array'Range loop
        Put(My_Array(I)'Image);
    end loop;
    New_Line(2);
    Put("Matrix foatlojanak elemeinek osszege:");
    Put(Elem'Image(Sum_Of_Main_Diagonal(My_Matrix))); New_Line(1);
end Main;
