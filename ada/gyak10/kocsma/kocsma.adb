with Seged, Ada.Calendar; use Seged, Ada.Calendar;

procedure Kocsma is

    Ajt�: Szemafor(5);
          -- Bel�p�s: P
          -- Kil�p�s: V

    type Ital is (S�r, Bor, P�linka);

    task Kocsm�ros is
        entry T�lt( Mit: in Ital );
        entry Borraval�;
    end Kocsm�ros;

    task body Kocsm�ros is
        Munkaid�_V�ge: Time := Clock + 10.0;
        -- Lej�rt_A_Munkaid�: Boolean := False;
        Borraval�k_Sz�ma: Natural := 0;
    begin
        -- while not Lej�rt_A_Munkaid� loop
        while Clock < Munkaid�_V�ge loop       -- r�videbb t�l�ra
            select
               accept T�lt ( Mit: in Ital ) do
                  Put_Line("T�lt�k " & Ital'Image(Mit) & 't');
                  case Mit is
                       when S�r => delay 1.0;
                       when Bor => delay 0.2;
                       when P�linka => delay 0.3;
                  end case;
               end T�lt;
               select
                  accept Borraval�; Borraval�k_Sz�ma := Borraval�k_Sz�ma + 1;
               or delay 0.2;
               end select;
            or delay until Munkaid�_V�ge;
               -- Lej�rt_A_Munkaid� := True;
            end select;
        end loop;
        Put_Line( "Na, �n hazamegyek. �sszeszedtem " &
                  Natural'Image(Borraval�k_Sz�ma) & " borraval�t.");
    end Kocsm�ros;

    task type R�szeg;
    task body R�szeg is
        S�riv�s_Ideje: Duration := 1.0;
    begin
        loop
           select
              Ajt�.P;  -- Bel�p
              Kocsm�ros.T�lt(P�linka);
              Put_Line("Benyomok egy felest.");
              delay 0.1;
              Kocsm�ros.T�lt(Bor);
              Put_Line("Benyomok egy poh�r bort.");
              delay 0.3;
              loop
                  Kocsm�ros.T�lt(S�r);
                  Put_Line("Benyomok egy kors� s�rt.");
                  delay S�riv�s_Ideje;
                  S�riv�s_Ideje := 2 * S�riv�s_Ideje;
              end loop;
           else
              Put_Line("Elmegyek a parkba szuny�lni.");
              delay 1.0;
           end select;
        end loop;
    exception
        when Tasking_Error => Put_Line("Keresek egy m�sik helyet.");
                              Ajt�.V;  -- Kil�p
    end R�szeg;
    type R�szeg_Access is access R�szeg;
    R: R�szeg_Access;

    type PString is access String;
    task type Egyetemista ( N�v: PString );
    task body Egyetemista is
    begin
        select
            Ajt�.P;
            Kocsm�ros.T�lt(Bor);
            select
                 Kocsm�ros.Borraval�;
            or delay 0.05;
               Put_Line("Ha nem kell, h�t nem kell.");
            end select;
            Put_Line(N�v.all & " borozik.");
            delay 1.5;
            Ajt�.V;
         or delay 1.0;
            Put_Line("Ink�bb elmegyek Ada el�ad�sra.");
         end select;
    exception
        when Tasking_Error => Put_Line("Keresek egy m�sik helyet.");
                              Ajt�.V;  -- Kil�p
    end Egyetemista;
    type Egyetemista_Access is access Egyetemista;
    E: Egyetemista_Access;
    Nevek: constant array (1..10) of PString := (
             new String'("Jani"), new String'("Peti"), new String'("Mari"), 
             new String'("Juci"), new String'("B�la"), new String'("Gabi"), 
             new String'("Zoli"), new String'("Dani"), new String'("G�za"),
             new String'("Rozi") );

begin

    for I in 1..10 loop
        delay 0.5;
        if V�letlen < 0.5 then
           Put_Line("Egy r�szeg t�vedt erre.");
           R := new R�szeg;
        else
           Put_Line("Egy egyetemista t�vedt erre.");
           E := new Egyetemista(Nevek(Integer(V�letlen*10.0+0.5)));
        end if;
    end loop;

end Kocsma;

