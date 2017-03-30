function Count_Value(G: Grid) return Natural is
    Count: Natural := 0;
begin
    for I in G'Range(1) loop
        for J in G'Range(2) loop
            if Predicate(G(I,J)) then
                Count := Count + 1;
            end if;
        end loop;
    end loop;
    return Count;
end;