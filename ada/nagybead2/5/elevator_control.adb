with Ada.Text_IO, Ada.Calendar;
 use Ada.Text_IO, Ada.Calendar;
procedure elevator_control is
    type Motor_Direction is (Forward, Backward, None, Power_Off);

    task Elevator is
        entry Move_Up;
        entry Move_Down;
    end Elevator;

    task body Elevator is
        Height: Natural := 0;
    begin
        loop
            select
                 when Height < 40 =>
                    accept Move_Up do
                        Height := Height + 1;
                        Put_Line("Elevator: " & Natural'Image(Height));
                    end Move_Up;
            or
                when Height > 0 =>
                    accept Move_Down do
                        Height := Height - 1;
                        Put_Line("Elevator: " & Natural'Image(Height));
                    end Move_Down;
            or
                terminate;
            end select;
        end loop;
    end Elevator;

    task Motor is
        entry Command(Direction: in Motor_Direction); 
    end Motor;

    Motor_Burned_Out: exception;

    task body Motor is
        Current_Direction: Integer := 0;
        Last_Move: Time := Clock;
        Displacement: Duration := 0.0;
        procedure Change_Direction(Direction: in Motor_Direction) is
            Temp_Clock: Time := Clock;
            Displacement_Change: Duration := Current_Direction * (Temp_Clock - Last_Move);
        begin
            if Displacement_Change >= 0.1 then
                select
                    Elevator.Move_Up;
                else
                    raise Motor_Burned_Out;
                end select;
            end if;
            if Displacement_Change <= -0.1 then
                select
                    Elevator.Move_Down;
                else
                    raise Motor_Burned_Out;
                end select;
            end if;
            Displacement := Displacement + Displacement_Change;
            Last_Move := Temp_Clock;
            if Direction = Forward then
                Current_Direction := Current_Direction + 1;
            elsif Direction = Backward then
                Current_Direction := Current_Direction - 1;
            end if;
            if Current_Direction > 1 then
                Current_Direction := 1;
            end if;
            if Current_Direction < -1 then
                Current_Direction := -1;
            end if;
            --Put_Line(Duration'Image(Displacement));
        end Change_Direction;
        function Int_To_Dir(Source: in Integer) return Motor_Direction is
        begin
            if Source > 0 then
                return Forward;
            elsif Source < 0 then
                return Backward;
            else
                return None;
            end if;
        end Int_To_Dir;

        Power_On: Boolean := True;
    begin
        while Power_On loop
            select
                accept Command(Direction: in Motor_Direction) do
                    if Direction = Power_Off then
                        Power_On := False;
                    else
                        Change_Direction(Direction);
                    end if;
                end Command;
            or
                delay until Last_Move + 0.1;
                Change_Direction(Int_To_Dir(Current_Direction));
            end select;
        end loop;
    exception
        when Motor_Burned_Out =>    begin
                                        Put_Line("A motor leégett");
                                    end;
    end Motor;
begin
    delay 1.0;
    Put_Line("Forward");
    Motor.Command(Forward);
    delay 3.5;
    Motor.Command(Backward);
    Motor.Command(Backward);
    delay 10.5;
    Put_Line("Stop");
    Motor.Command(Backward);
    delay 0.7;
    Put_Line("Backward");
    Motor.Command(Backward);
    delay 0.5;
    Motor.Command(Backward);
    delay 1.0;
    Put_Line("Stop");
    Motor.Command(Forward);
    delay 1.0;
    Put_Line("Forward");
    Motor.Command(Forward);
    delay 2.0;
    Motor.Command(Power_Off);
    Put_Line("Motor leállt");
exception
    when Tasking_Error => Put_Line("A motor leégett");
end elevator_control;
