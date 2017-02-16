with Ada.Integer_Text_IO, Ada.Float_Text_IO; use Ada.Integer_Text_IO;
procedure Pi is
   Steps : Positive;
   K : Float := 2.0;
   Pi : Float := 1.0;
begin
   Get(Steps);
   for I in 1..Steps loop
      Pi := Pi * K * K / (K - 1.0) / (K + 1.0);
      K := K + 2.0;
   end loop;
   Pi := Pi * 2.0;
   Ada.Float_Text_IO.Put(Pi);
end Pi;
