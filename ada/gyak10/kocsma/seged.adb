with Ada.Text_IO, Ada.Numerics.Float_Random;
use Ada.Text_IO, Ada.Numerics.Float_Random;

package body Seged is

  task Ki�r� is
    entry Ki�r( S: in String );
  end Ki�r�;

  task body Ki�r� is
  begin
     loop
         select
            accept Ki�r( S: in String ) do Ada.Text_IO.Put_Line(S); end;
         or terminate;
         end select;
     end loop;
  end Ki�r�;
	
  procedure Put_Line( S: in String ) is begin Ki�r�.Ki�r(S); end;

  task V�letlen_Gy�rt� is
     entry V�letlen ( F: out Float );
  end V�letlen_Gy�rt�;

  task body V�letlen_Gy�rt� is
     G: Generator;
  begin
     Reset(G);
     loop
         select
            accept V�letlen( F: out Float ) do F := Random(G); end;
         or terminate;
         end select;
     end loop;
  end V�letlen_Gy�rt�;

  function V�letlen return Float is
     F: Float;
  begin
     V�letlen_Gy�rt�.V�letlen(F);
     return F;
  end V�letlen;

  task body Szemafor is
     Bent: Natural := 0;
  begin
     loop
        select
           when Bent < Max => accept P; Bent := Bent + 1;
        or accept V; Bent := Bent - 1;
        or terminate;
        end select;
     end loop;
  end Szemafor;

end Seged;

