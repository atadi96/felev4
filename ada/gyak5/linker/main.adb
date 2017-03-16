with Linker, Ada.Float_Text_IO, Ada.Integer_Text_IO, Ada.Text_IO;
use Ada.Float_Text_IO, Ada.Integer_Text_IO, Ada.Text_IO;
procedure Main is
    type Elem is new Integer;
    type Index is new Integer;
    function Is_Negative(Z: Elem) return Boolean is
    begin
        return Z < 0;
    end Is_Negative;
    type Int_Array is array (Index range <>) of Elem;
    --type Int_Array is array (Integer range 1..5) of Integer;
    procedure Negative_Linker is new Linker(Elem, Index, Int_Array, Is_Negative);
    
    Input1: Int_Array(1..5) := (1,2,4,8,5);
    Input2: Int_Array(1..5) := (1,2,4,-8,5);
    Result1: Index;
    Result2: Index;
    Found1: Boolean;
    Found2: Boolean;
begin
    Negative_Linker(Input1, Found1, Result1);
    if Found1 then
        Put(Elem'Image(Input1(Result1)));
    else
        Put(0);
    end if;
    New_Line(1);
    Negative_Linker(Input2, Found2, Result2);
    if Found2 then
        Put(Elem'Image(Input2(Result2)));
    else
        Put(0);
    end if;
end;