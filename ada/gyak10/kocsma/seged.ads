package Seged is

  procedure Put_Line( S: in String );

  function V�letlen return Float;

  task type Szemafor( Max: Positive ) is
    entry P;
    entry V;
  end Szemafor;

end Seged;
