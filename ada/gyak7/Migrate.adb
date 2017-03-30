procedure Migrate(G: in out Grid; Max: Natural) is
    type Point is record
        X, Y: Index;
    end record;
    
    type Neigh_Type is array(1..9) of Point
    
    function Neighbours(
        X, Y: Index;
        G: Grid;
        Length: out Natural := 0;
    ) return Neigh_Type is
        Values: Neigh_Type
        P: Point;
        procedure Add_Point(X, Y: Index) is
        begin
            if X >= Grid'Range(1)'First and
               X <= Grid'Range(1)'Last and
               Y >= Grid'Range(2)'First and
               Y <= Grid'Range(2)'Last
            then
                Count := Count + 1;
                P.X := X;
                P.Y := Y;
                Values(Count) := P;
            end if;
        end;
    begin
        Add_Point(Index'Pred(X), Index'Pred(Y));
        Add_Point(Index'Pred(X), Y);
        Add_Point(Index'Pred(X), Index'Succ(Y));
        Add_Point(X, Index'Pred(Y));
        Add_Point(X, Index'Succ(Y));
        Add_Point(Index'Succ(X), Index'Pred(Y));
        Add_Point(Index'Succ(X), Y);
        Add_Point(Index'Succ(X), Index'Succ(Y));
        return Values;
    end Neighbours;
    
    Actual_Neighs: Neigh_Type;
    Actual_Length: Natural;
    I: Integer;
    Overflow: Natural;
begin
    for I in G'Range(1) loop
        for J in G'Range(2) loop
            if G(I,J) > Max then
                Overflow := G(I,J) - Max;
                G(I,J) := Max;
                Actual_Neighs := Neighbours(I, J, G, Actual_Length);
                I := 1;
                while I < Actual_Length and Overflow > 0 loop
                    if G(Actual_Neighs(I).X, Actual_Neighs(I).Y) < Max then
                        -- megnézzük, hogy a szomszéd gapje legalább annyi, mint
                        -- a felesleg. ha igen, berakjuk az egész felesleget.
                        -- ha nem, belerakunk annyit, amennyi befér.
                        -- a felesleget csökkentjük a berakott mennyiséggel.
                    end if;
                    I := I + 1;
                end loop;
            end if;
        end loop;
    end loop;
end Migrate;