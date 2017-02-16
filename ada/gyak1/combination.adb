with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
procedure Combination is
   N, K : Integer;
   Choose : Positive := 1;
begin
   Get(N);
   Get(K);
   for I in 0..K-1 loop
      Choose := Choose * (N - I) / (I + 1);
   end loop;
   Put(Choose);
end Combination;
