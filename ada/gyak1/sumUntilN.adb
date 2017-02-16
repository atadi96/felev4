with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
procedure SumUntilN is
   N : Integer;
   SUM : Integer := 0;
begin
   Get(N);
   for I in 1..N loop
      SUM := SUM + I;
   end loop;
   Put(SUM);
end SumUntilN;
