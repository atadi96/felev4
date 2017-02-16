with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
procedure Sign is
   X : Integer;
begin
   Get(X);
   if X > 0 then
      Put(1);
   elsif X < 0 then
      Put(-1);
   else
      Put(0);
   end if;
end Sign;
