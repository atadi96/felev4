procedure Sort(A: in out Item_Array) is
    procedure Swap(A, B: in out Item) is
        Temp: Item := A;
    begin
        A := B;
        B := Temp;
    end Swap;
    Temp: Item;
begin
    for I in reverse Index'Succ(A'First) .. A'Last loop
        for J in A'First .. Index'Pred(I) loop
            if A(Index'Succ(J)) < A(J) then
                --Swap(A(J), A(Index'Succ(J)));
                Temp := A(J);
                A(J) := A(Index'Succ(J));
                A(Index'Succ(J)) := Temp;
            end if;
        end loop;
    end loop;
end Sort;
