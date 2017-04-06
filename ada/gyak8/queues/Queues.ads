generic
    type Elem is private;
package Queues is
    type Queue(Max: Positive) is limited private;
    
    Queue_Full, Queue_Empty: exception;
    
    procedure Push_Back(Q: in out Queue; E: Elem);
    
    function Front(Q: Queue) return Elem;
    
    procedure Pop_Front(Q: in out Queue);
    
    function Length(Q: Queue) return Natural;
    
    function Empty(Q: Queue) return Boolean;
    
    function Full(Q: Queue) return Boolean;
    
private
    type Value_Array is array(Positive range <>) of Elem;
    type Queue(Max: Positive) is record
        Values: Value_Array(1..Max);
        Length: Natural := 0;
    end record;
end Queues;