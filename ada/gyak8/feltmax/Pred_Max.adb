procedure Pred_Max(A: in Elem_Array; Found: out Boolean; E: Elem) is
begin
    Found := False;
    for I in A'Range loop
        if Predicate(A(I)) then
            if Found then
                if A(I) > E then
                    E := A(I);
                end if;
            else
                Found := True;
                E := A(I);
            end if;
        end if;
    end loop;
end Pred_Max;