function Most_Frequent(V: Vector) return Item is
    Max_Num: Natural := 0;
    Max_Ind: Index := V'First;
    Curr_Num: Natural;
    function Multiplicity(Pattern: Item) return Natural is
        N: Natural := 0;
    begin
        for I in V'Range loop
            if V(I) = Pattern then
                N := N + 1;
            end if;
        end loop;
        return N;
    end Multiplicity;
begin
    for I in V'Range loop
        Curr_Num := Multiplicity(V(I));
        if(Curr_Num > Max_Num) then
            Max_Num := Curr_Num;
            Max_Ind := I;
        end if;
    end loop;
    return V(Max_Ind);
end Most_Frequent;