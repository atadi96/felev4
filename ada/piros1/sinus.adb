with Ada.Float_Text_IO, Ada.Text_IO;
procedure Sinus is
   Accuracy : Float := 0.0000001;
   X        : Float;
   Sinus    : Float := 0.0;
   T        : Float;
   I        : Float := 1.0;
begin
   Ada.Text_IO.Put("Sinus of: ");
   Ada.Float_Text_IO.Get(X);
   Sinus := 0.0;
   T := X;
   for J in Integer range 1..2000000 loop
      Sinus := Sinus + T;
      T := (T * (-1.0)) / (I + 2.0) / (I + 1.0) * X * X;
      I := I + 2.0;
   end loop;
   Ada.Float_Text_IO.Put(Sinus);
end Sinus;
