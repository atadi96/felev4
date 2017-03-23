function Has_Repetition(V: Vector) return Boolean is
    L: Boolean := False;
begin
    for I in V'First .. Index'Pred(V'Last) loop
        L := L or V(I) = V(Index'Succ(I));
    end loop;
    return L;
end Has_Repetition;