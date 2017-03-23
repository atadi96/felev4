with Has_Repetition, Most_Frequent, Ada.Text_IO;
use Ada.Text_IO;
--use Has_Repetition;
procedure Main is
    function Has_Double_Letters is new Has_Repetition(Character, Positive, String);
    function Most_Frequent_Letter is new Most_Frequent(Character, Positive, String);
    S_Van: String := "Van benne ismetles";
    S_Nincs: String := "Nincs ismetles";
    generic
        type Value is private;
    procedure Assert(Actual, Expected: Value);
    procedure Assert(Actual, Expected: Value) is
    begin
        if Actual = Expected then
            Put("Passed.");
        else
            Put("Failed! --");
            --Put("Failed. Expected '" +
            --    Value'Image(Expected) +
            --    "', found '" +
            --    Value'Image(Actual) + "'");
        end if;
        New_Line(1);
    end Assert;
    procedure Bool_Assert is new Assert(Boolean);
    procedure Character_Assert is new Assert(Character);
begin
    Bool_Assert(Has_Double_Letters("Van benne ismetles"), True);
    Bool_Assert(Has_Double_Letters("Nincs ismetles"), False);
    Bool_Assert(Has_Double_Letters(""), False);
    Bool_Assert(Has_Double_Letters("EEleje"), True);
    Bool_Assert(Has_Double_Letters("Vegee"), True);
    Bool_Assert(Has_Double_Letters("Sehol"), False);
    
    Character_Assert(Most_Frequent_Letter("Elmegyek ebedelni"), 'e');
    Character_Assert(Most_Frequent_Letter("Hyperdimension Neptunia"), 'e');
    Character_Assert(Most_Frequent_Letter("ADA pls"), 'A');
    Character_Assert(Most_Frequent_Letter("lol"), 'l');
    
    
end Main;    