with Ada.Text_IO, Ada.Calendar;
 use Ada.Text_IO, Ada.Calendar;
procedure elevator_control is
    type Motor_Direction is (Forward, Backward);

    task Motor is
        entry Command(Direction: in Motor_Direction); 
    end Motor;

    task body Motor is
        Current_Direction: Integer := 0;
        Last_Move: Time := Clock;
        Displacement: Duration := 0.0;
        procedure Change_Direction(Direction: in Motor_Direction) is
            Temp_Clock: Time := Clock;
        begin
            Displacement := Displacement + Current_Direction * (Temp_Clock - Last_Move);
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
            Put_Line(Duration'Image(Displacement));
        end Change_Direction;
    begin
        loop
            select
                accept Command(Direction: in Motor_Direction) do
                    Change_Direction(Direction);
                end Command;
                or terminate;
            end select;
        end loop;
    end Motor;

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
                        Put_Line(Natural'Image(Height));
                    end Move_Up;
            or
                when Height > 0 =>
                    accept Move_Down do
                        Height := Height - 1;
                        Put_Line(Natural'Image(Height));
                    end Move_Down;
            or
                terminate;
            end select;
        end loop;
    end Elevator;
begin
    Elevator.Move_Up;
    Elevator.Move_Down;
    Elevator.Move_Up;
    Elevator.Move_Up;
    Elevator.Move_Down;
    Motor.Command(Forward);
    delay 1.5;
    Motor.Command(Forward);
    delay 0.5;
    Motor.Command(Backward);
    delay 0.7;
    Motor.Command(Backward);
    delay 0.5;
    Motor.Command(Backward);
    delay 2.5;
    Motor.Command(Forward);
    delay 1.0;
    Motor.Command(Forward);
    delay 2.0;
    Elevator.Move_Down;
    Elevator.Move_Up;
    Elevator.Move_Up;
    Elevator.Move_Down;
end elevator_control;
