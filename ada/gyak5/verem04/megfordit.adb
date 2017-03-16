with Vermek, Ada.Command_Line, Ada.Integer_Text_IO; use Vermek;
procedure Megfordit is
    N: Integer;
    V: Verem(Ada.Command_Line.Argument_Count);
begin
    for I in 1..Ada.Command_Line.Argument_Count loop
       N := Integer'Value(Ada.Command_Line.Argument(I));
       Push( V, N );
    end loop;
    while not Is_Empty(V) loop 
        Pop( V, N );
        Ada.Integer_Text_IO.Put(N);
    end loop;
end Megfordit;

