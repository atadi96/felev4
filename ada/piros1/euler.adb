with Ada.Float_Text_IO, Ada.Integer_Text_IO;
procedure Euler is
   Steps : Positive;
   E : Float := 0.0;
   T : Float := 1.0;
begin
   Ada.Integer_Text_IO.Get(Steps);
   for I in 1..Steps loop
      E := E + T;
	  T := T / Float(I);
   end loop;
   Ada.Float_Text_IO.Put(E);
end Euler;
