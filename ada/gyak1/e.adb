with Ada.Integer_Text_IO, Ada.Float_Text_IO; use Ada.Integer_Text_IO;
procedure Pi is
   Steps : Positive;
   E : Float := 1.0;
   T : Float := 1.0;
begin
   Get(Steps);
   for I in 1..Steps loop
      E := E + T;
	  T := T / I
   end loop;
   Pi := Pi * 2.0;
   Ada.Float_Text_IO.Put(Pi);
end Pi;
