with Ada.Text_IO, Count, Less_Than, Count_Value;
use Ada.Text_IO;
procedure Main is
    type Index is new Integer;
    type Grid is array (Index range<>, Index range<>) of Natural;
    G: Grid := (
        (1,0,0,0,0,0,0,0,0,1),
        (0,0,0,0,5,0,0,0,0,0),
        (0,0,0,0,0,0,0,3,0,0),
        (0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,6,0,0,0),
        (0,0,5,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0),
        (0,0,9,0,0,0,0,0,0,0),
        (1,0,0,0,0,0,0,0,0,1)
    );
    function Nest_Pred(Count: Natural) return Boolean is
    begin
        return Count > 3;
    end Nest_Pred;
    function Nest_Count is new Count(Index, Grid);
    function Nest_Less_Than is new Less_Than(Index, Grid);
    function Nest_Count_Value is new Count_Value(Natural, Index, Grid, Nest_Pred);
    generic
        type Item is private;
        with function Image(I: Item) return String;
    procedure Assert(Desc: String; Actual, Expected: Item);
    procedure Assert(Desc: String; Actual, Expected: Item) is
    begin
        Put(Desc);
        if Actual = Expected then
            Put(" -- PASSED.");
        else
            Put(" -- FAILED!"); New_Line(1);
            Put(" -- "); Put("Expected: "); Put(Image(Expected)); New_Line(1);
            Put(" -- "); Put("Actual: "); Put(Image(Actual)); 
        end if;
        New_Line(1);
    end;
    procedure Natural_Assert is new Assert(Natural, Natural'Image);
    procedure Boolean_Assert is new Assert(Boolean, Boolean'Image);
begin
    Natural_Assert("Nest_Count test", Nest_Count(G), 32);
    Boolean_Assert("Nest_Less_Than - less", Nest_Less_Than(G, 40), False);
    Boolean_Assert("Nest_Less_Than - edge", Nest_Less_Than(G, 32), False);
    Boolean_Assert("Nest_Less_Than - more", Nest_Less_Than(G, 31), True);
    Natural_Assert("Nest_Count_Value test", Nest_Count_Value(G), 4);
end;