package body Queues is

    procedure Push_Back(Q: in out Queue; I: Item) is
    begin
        if Empty(Q) then 
            Q.Last := new Node'(I, null);
            Q.First :=
                Q.Last;
        else
            Q.Last.Next := new Node'(I, null);
            Q.Last := Q.Last.Next;
        end if;
            Q.Length := Q.Length + 1;
    end Push_Back;
    
    function Front(Q: Queue) return Item is
    begin
        if Empty(Q) then
            raise Queue_Empty;
        else
            return Q.First.Data;
        end if;
    end Front;
    
    procedure Pop_Front(Q: in out Queue) is
    begin
        if Empty(Q) then
            raise Queue_Empty;
        else
            Q.First := Q.First.Next;
            Q.Length := Q.Length - 1;
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
        return False;
    end Full;
end Queues;