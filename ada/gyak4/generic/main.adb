with Map, Ada.Float_Text_IO, Ada.Integer_Text_IO, Ada.Text_IO;
use Ada.Float_Text_IO, Ada.Integer_Text_IO, Ada.Text_IO;
procedure Main is
    function Half(Z: Integer) return Float is
    begin
        return Float(Z)/2.0;
    end Half;
    function Times_Two(Z: Integer) return Integer is
    begin
        return Z * 2;
    end;
    type Int_Array is array (Integer range <>) of Integer;
    type Float_Array is array (Integer range<>) of Float;
    function Half_Map is new Map(Integer, Float, Integer, Int_Array, Float_Array, Half);
    function Double_Map is new Map(Integer, Integer, Integer, Int_Array, Int_Array, Times_Two);
    
    Input: Int_Array(1..5) := (1,2,4,8,5);
    Result1: Float_Array(Input'Range);
    Result2: Int_Array(Input'Range);
begin
    Result1 := Half_Map(Input);
    for I in Result1'Range loop
        Put(Result1(I));
    end loop;
    New_Line(2);
    Result2 := Double_Map(Input);
    for I in Result2'Range loop
        Put(Result2(I));
    end loop;
end;