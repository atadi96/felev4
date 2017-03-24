with Sort, Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
procedure Sort_Test is
	type Item is new Integer;
	type Index is new Integer;
	type Integer_Array is array(Integer range <>) of Integer;
	Not_Ordered: Integer_Array := (7,6,3,5,-12);
	Ordered: Integer_Array := (-2, 0, 1, 3, 4, 5);
	procedure Sort_Asc is new Sort(Integer, Integer, Integer_Array);
	procedure Print_Array(A: Integer_Array) is
	begin
		for I in A'Range loop
			Put(A(I));
		end loop;
		New_Line(1);
	end;
begin
	Print_Array(Ordered);
	Sort_Asc(Ordered);
	Print_Array(Ordered);
	Print_Array(Not_Ordered);
	Sort_Asc(Not_Ordered);
	Print_Array(Not_Ordered);
end Sort_Test;
