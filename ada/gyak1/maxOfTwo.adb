with Ada.Integer_Text_IO;
procedure MaxOfTwo is
   A, B : Integer;
begin
   Ada.Integer_Text_IO.Get(A);
   Ada.Integer_Text_IO.Get(B);
   if A > B then
      Ada.Integer_Text_IO.Put(A);
   else
      Ada.Integer_Text_IO.Put(B);
   end if;
end MaxOfTwo;
