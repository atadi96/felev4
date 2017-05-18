with tools, hauntedhouse, Ada.Text_IO;
 use tools, hauntedhouse, Ada.Text_IO;
procedure main is
    
    type PDuration is access Duration;
    
    task Princess is
        entry Scare(Scare_Pos: in Position);
    private
        
    end Princess;

    task body Princess is
        Pos: Position := (1,3);
        Health: Natural := 3;
    begin
        while Health > 0 loop
            select
                when GetField(Pos) = C =>
                    accept Scare(Scare_Pos: in Position) do
                        if Scare_Pos = Pos then
                            Health := Health - 1;
                            Output.Puts("Princess - oh! what a cute little ghost c: ("
                                     & Natural'Image(Health)
                                     & " HP)"
                             );
                        else 
                            Output.Puts("Princess - no scare me pls *-*");
                        end if;
                    end Scare;
            or
                delay 0.0;
            end select;
        end loop;
        Output.Puts("Princess: o no i got kawaii overload from ghost :o");
    end Princess;
    
    task type Ghost(Id: Positive; Cooldown: PDuration);
    
    task body Ghost is
        Pos: Position;
    begin
        while Princess'Callable loop
            Pos := GetRandPos;
            Output.Puts("Ghost "
                       & Positive'Image(Id) 
                       & " - wud u get scared of me please? ("
                       & Natural'Image(Pos.x)
                       & ","
                       & Natural'Image(Pos.y)
                       & ")");
            select
                Princess.Scare(Pos);
                delay Cooldown.all;
            or
                delay Cooldown.all;
            end select;
        end loop;
    end Ghost;
    
    task type Wizard(Ghost_Num: Positive; Cast_Time: PDuration);
    
    task body Wizard is
        type AGhost is access Ghost;
        type Ghosts is array(1..Ghost_Num) of AGhost;
        G: Ghosts;
    begin
        for I in Ghosts'Range loop
            delay Cast_Time.all;
            G(I) := new Ghost(I, new Duration'(I * Cast_Time.all));
        end loop;
    end Wizard;
    
    type AWizard is access Wizard;
    Kartoffel: AWizard := new Wizard(5, new Duration'(0.2));
    
begin
    null;
end main;