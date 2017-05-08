with Ada.Calendar, Ada.Text_IO;
 use Ada.Calendar, Ada.Text_IO;
 
procedure Main is
	task Por is
		entry Lep_Bal;
		entry Lep_Jobb;
	end Por;
	
	task body Por is
	begin
		for I in 1..5 loop
			accept Lep_Bal do
				Put_Line("A bal cipo lepett");
			end Lep_Bal;
			accept Lep_Jobb do
				Put_Line("A jobb cipo lepett");
			end Lep_Jobb;
		end loop;
	end;
	
	task type Bal_Cipo is
	end Bal_Cipo;
	
	task body Bal_Cipo is
	begin
		loop
			select
				Por.Lep_Bal;
			else
				Put_Line("Bal_Cipo pihen.");
				delay 1.0;
			end select;
		end loop;
	exception
		when Tasking_Error => Put_Line("Bal_Cipo kilepett.");
	end Bal_Cipo;
	
	task type Jobb_Cipo is
	end Jobb_Cipo;
	
	task body Jobb_Cipo is
	begin
		loop
			select
				Por.Lep_Jobb;
			else
				Put_Line("Jobb_Cipo pihen.");
				delay 1.0;
			end select;
		end loop;
	exception
		when Tasking_Error => Put_Line("Jobb_Cipo kilepett.");
	end Jobb_Cipo;
	
	J_C: Jobb_Cipo;
	B_C: Bal_Cipo;
begin
	
	null;
end;