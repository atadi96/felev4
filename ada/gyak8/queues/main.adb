with Ada.Text_IO, Queues;
use Ada.Text_IO;
procedure Main is
    package Integer_Queue is new Queues(Integer); use Integer_Queue;
    Q: Queue(5);
    
    generic
        type Item is private;
        with function Image(I: Item) return String;
    procedure Assert(Desc: String; Actual, Expected: Item);
    procedure Assert(Desc: String; Actual, Expected: Item) is
    begin
        if Actual = Expected then
            Put("PASSED -- "); Put(Desc);
        else
            Put("FAILED! -- "); Put(Desc); New_Line(1);
            Put(" -- "); Put("Expected: "); Put(Image(Expected)); New_Line(1);
            Put(" -- "); Put("Actual: "); Put(Image(Actual)); 
        end if;
        New_Line(1);
    end;
    procedure Integer_Assert is new Assert(Integer, Integer'Image);
    procedure Boolean_Assert is new Assert(Boolean, Boolean'Image);
begin
    Boolean_Assert("Start empty", Empty(Q), True);
    Push_Back(Q, 1);
    Push_Back(Q, 1);
    Push_Back(Q, 2);
    Push_Back(Q, 3);
    Push_Back(Q, 5);
    Boolean_Assert("Full", Full(Q), True);
    begin
        Push_Back(Q, 8);
    exception
        when Queue_Full
            => Boolean_Assert("Catch exception when Push_Back on full Queue", True, True);
    end;
    Integer_Assert("1 = Front(Q); Pop_Front(Q)", Front(Q), 1); Pop_Front(Q);
    Integer_Assert("1 = Front(Q); Pop_Front(Q)", Front(Q), 1); Pop_Front(Q);
    Integer_Assert("2 = Front(Q); Pop_Front(Q)", Front(Q), 2); Pop_Front(Q);
    Integer_Assert("3 = Front(Q); Pop_Front(Q)", Front(Q), 3); Pop_Front(Q);
    Integer_Assert("5 = Front(Q); Pop_Front(Q)", Front(Q), 5); Pop_Front(Q);
    declare
        Dummy: Integer;
    begin
        Dummy := Front(Q);
    exception
        when Queue_Empty
            => Boolean_Assert("Catch exception when Front on empty Queue", True, True);
    end;
    begin
        Pop_Front(Q);
    exception
        when Queue_Empty
            => Boolean_Assert("Catch exception when Pop_Front on empty Queue", True, True);
    end;
end Main;