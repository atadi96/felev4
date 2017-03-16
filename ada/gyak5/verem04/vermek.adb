package body Vermek is

      procedure Push( V: in out Verem; E: in Elem ) is
      begin
          V.Veremtet� := V.Veremtet� + 1;
          V.Adatok(V.Veremtet�) := E;
      end;

      procedure Pop( V: in out Verem; E: out Elem ) is
      begin
          E := Top(V);
          V.Veremtet� := V.Veremtet� - 1;
      end;

      function Top( V: Verem ) return Elem is
      begin
          return V.Adatok(V.Veremtet�);
      end;

      function Is_Empty( V: Verem ) return Boolean is
      begin
          return V.Veremtet� = 0;
      end;

      function Is_Full( V: Verem ) return Boolean is
      begin
          return V.Veremtet� >= V.Max;
      end;

      function Size( V: Verem ) return Natural is
      begin
          return V.Veremtet�;
      end;

end Vermek;

