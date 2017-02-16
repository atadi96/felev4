with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
procedure MaxOfThree is
   A, B, C : Integer;
begin
   Get(A);
   Get(B);
   Get(C);
   if A > B then
      if C > A then
         Put(C);
      else
         Put(A);
      end if;
   elsif C > B then
         Put(C);
      else
         Put(B);
      end if;
end MaxOfThree;
