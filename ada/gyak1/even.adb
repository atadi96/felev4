with Ada.Integer_Text_IO, Ada.Text_IO; use Ada.Integer_Text_IO;
procedure Even is
   X : Integer;
begin
   Get(X);
   if X mod 2 = 0 then
      Ada.Text_IO.Put("even");
   else
      Ada.Text_IO.Put("odd");
   end if;
end Even;
