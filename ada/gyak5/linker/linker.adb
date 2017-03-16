procedure Linker(T:Tomb; Found: out Boolean; I: out Index) is
begin
    I := T'First;
    while I < T'Last and not Pred(T(I)) loop
        I := Index'Succ(I);
    end loop;
    Found := Pred(T(I));
    -- Found := False;
    -- for I in reverse T'Range loop
    --   
    -- end loop;
end;
