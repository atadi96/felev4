with Setq, Ada.Integer_Text_IO, Ada.Text_IO;
use Setq, Ada.Integer_Text_IO, Ada.Text_IO;

procedure Main is

    R: Rational := 4/8;
    -- X: Rational := 3/4/5;
    procedure PrintRat(R : Rational) is
    begin
        Put( Numerator(R) );
        Put( '/' );
        Put( Denominator(R) );
        New_Line(1);
    end;
begin

    R := R / (R/2);
    R := R / 3;
    PrintRat(R);
    R := R + 3;
    PrintRat(R);
    R := R + R;
    PrintRat(R);

end Main;
