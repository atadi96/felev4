function Count(G: Grid) return Natural is
    Sum: Natural := 0;
begin
    for I in G'Range(1) loop
        for J in G'Range(2) loop
            Sum := Sum + G(I,J);
        end loop;
    end loop;
    return Sum;
end Count;