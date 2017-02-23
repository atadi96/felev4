with Ada.Integer_Text_IO;
package body Mat is

    function Lnko ( A, B : Positive ) return Positive is
        X: Positive := A;
        Y: Positive := B;
    begin
        while X /= Y loop
            if X > Y then
                X := X - Y;
            else
                Y := Y - X;
            end if;
        end loop;
        return X;
    end Lnko;

    function Faktorialis( N: Natural ) return Positive is
        Fakt : Positive := 1;
    begin
        for I in 1..N loop
            Fakt := Fakt * I;
        end loop;
        return Fakt;
    end Faktorialis;

    function SumDigits(N: Natural) return Natural is
        Sum: Natural := 0;
        Temp: Natural := N;
    begin
        while Temp > 0 loop
            Sum := Sum + Temp mod 10;
            Temp := Temp / 10;
        end loop;
        return Sum;
    end SumDigits;
    
    function DivideableBy9(N: Natural) return Boolean is
    begin
        return SumDigits(N) mod 9 = 0;
    end DivideableBy9;
    
    procedure PrintPerfectNumbers is --FIXME
        Sum: Natural := 0;
    begin
        for I in 1..10000 loop
            if SumDigits(I) = I then
                Ada.Integer_Text_IO.Put(I);
            end if;
        end loop;
    end PrintPerfectNumbers;
    
    function Sinus(X: Float) return Float is
        Sinus    : Float := 0.0;
        T        : Float;
        I        : Float := 1.0;
    begin
        T := X;
        for J in Integer range 1..2000000 loop
            Sinus := Sinus + T;
            T := (T * (-1.0)) / (I + 2.0) / (I + 1.0) * X * X;
            I := I + 2.0;
        end loop;
        return Sinus;
    end Sinus;
    
    function Palindrom(N: Positive) return Boolean is
        Right : Integer := 0;
        Left : Integer := N;
    begin
        while Left > Right loop
            Right := 10 * Right + (Left mod 10);
            if (Right = Left) or (Right = Left / 10) then
                return true;
            end if;
            Left := Left / 10;
        end loop;
        return false;
    end Palindrom;
    
    function Power(A, N: Positive) return Positive is
    begin
        if N = 1 then
            return A;
        else
            return A * Power(A, N-1);
        end if;
    end Power;
    
    function Factorial(N: Natural) return Positive is
    begin
        if N = 0 then
            return 1;
        else
            return N * Factorial(N - 1);
        end if;
    end Factorial;

end Mat;

