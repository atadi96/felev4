with Mat; use Mat;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
procedure Main is
    N: Natural;
begin
    --Put(Boolean'Image(Palindrom(5)));         New_Line(1); --true
    --Put(Boolean'Image(Palindrom(12)));        New_Line(1); --false
    --Put(Boolean'Image(Palindrom(121)));       New_Line(1); --true
    --Put(Boolean'Image(Palindrom(1221)));      New_Line(1); --true
    --Put(Boolean'Image(Palindrom(19591)));     New_Line(1); --true
    --Put(Boolean'Image(Palindrom(352653)));    New_Line(1); --false
    --Put(Boolean'Image(Palindrom(456321168))); New_Line(1); --false
    
    Put("Sum of digits of the number: ");
    Ada.Integer_Text_IO.Get(N);
    Put(Integer'Image(SumDigits(N))); New_Line(1);
    
    Put("Is the number divideable by 9");
    Ada.Integer_Text_IO.Get(N);
    Put(Boolean'Image(DivideableBy9(N))); New_Line(1);
    
    Put("Printing perfect numbers up to 10000");
    Ada.Integer_Text_IO.Get(N);
    PrintPerfectNumbers; New_Line(1);
    
    Put("Is the number palindrom: ");
    Ada.Integer_Text_IO.Get(N);
    Put(Boolean'Image(Palindrom(N))); New_Line(1);
    
    Put("N factorial: ");
    Ada.Integer_Text_IO.Get(N);
    Put(Integer'Image(Factorial(N)));    
    
end Main;