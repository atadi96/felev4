generic
    type Item is private;
package Queues is
    type Queue is private;
    
    Queue_Full, Queue_Empty: exception;
    
    procedure Push_Back(Q: in out Queue; I: Item);
    
    function Front(Q: Queue) return Item;
    
    procedure Pop_Front(Q: in out Queue);
    
    function Length(Q: Queue) return Natural;
    
    function Empty(Q: Queue) return Boolean;
    
    function Full(Q: Queue) return Boolean;
    
private
    type Node;
    type Queue_Node is access Node;
    type Node is record
        Data: Item;
        Next: Queue_Node;
    end record;
    type Queue is record
        Length: Natural := 0;
        First: Queue_Node := null;
        Last: Queue_Node := null;
    end record;
    
end Queues;