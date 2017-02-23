with Ada.Float_Text_IO, Ada.Text_IO;
procedure Sinus is
   Accuracy : Float := 0.0000001;
   X        : Float;
   Sinus    : Float := 0.0;
   T        : Float := 1.0;
   I        : Float := 1.0;
begin
   Ada.Text_IO.Put("Sinus of: ");
   Ada.Float_Text_IO.Get(X);
   while T >= Accuracy do
      Sinus := Sinus + T;
	  T := T * X * X / Float(I);
   end loop;
   Ada.Float_Text_IO.Put(Sinus);
end Sinus;
