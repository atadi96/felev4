function Most_Frequent(V: Vector) return Item is
    Multiplicity: array V'Range of Natural;
    Max_Num: Natural := 0;
    Max_Ind: Index := V'First;
    Curr_Num: Natural;
    
begin
    for I in Multiplicity'Range loop
        --J := I;
        --while J /= V'First and not V(J) = V(I) loop
        Curr_Num = 1;
        for J in reverse range Vector'First .. Index'Pred(I) loop
            if V(I) = V(J) and Multiplicity(J) > Curr_Num then
                Curr_Num = Multiplicity(J);
        end loop;
        Multiplicity(I) := Curr_Num;
        if(Curr_Num > Max_Num) then
            Max_Num := Curr_Num;
            Max_Ind := I;
        end if;
    end loop;
    return V(Max_Ind);
end Most_Frequent;