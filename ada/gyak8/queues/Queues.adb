package body Queues is

    procedure Push_Back(Q: in out Queue; E: Elem) is
    begin
        if Full(Q) then
            raise Queue_Full;
        else
            Q.Length := Q.Length + 1;
            Q.Values(Q.Length) := E;
        end if;
    end Push_Back;
    
    function Front(Q: Queue) return Elem is
    begin
        if Empty(Q) then
            raise Queue_Empty;
        else
            return Q.Values(1);
        end if;
    end Front;
    
    procedure Pop_Front(Q: in out Queue) is
    begin
        if Empty(Q) then
            raise Queue_Empty;
        else
            Q.Length := Q.Length - 1;
            for I in 1..Q.Length loop
                Q.Values(I) := Q.Values(I + 1);
            end loop;
        end if;
    end Pop_Front;
    
    function Length(Q: Queue) return Natural is
    begin
        return Q.Length;
    end Length;
    
    function Empty(Q: Queue) return Boolean is
    begin
        return Q.Length = 0;
    end Empty;
    
    function Full(Q: Queue) return Boolean is
    begin
        return Q.Length = Q.Max;
    end Full;

end Queues;