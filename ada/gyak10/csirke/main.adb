with Seged, Ada.Calendar;
 use Seged;
 
procedure Main is
	task Csirke is
		entry Etet;
		entry Jatszik;
	end Csirke;
	
	task body Csirke is
		exception Ded;
		Kendermagok: Natural := 4;
		Sad_Times: Time := Clock + 5.0;
	begin
		while 0 < Kendermagok and Kendermagok < 30 loop
			select
				accept Etet do
					Kendermagok := Kendermagok + 1;
				end Etet;
				or Jatszik do
					Sad_Times := Clock + 5.0;
				end Jatszik;
				or delay until Sad_Times do
					raise Ded;
				end Sad_Times;
			end select;
		end loop;
		if 0 >= Kendermagok then
			raise Ded;
		end if;
	end;
begin
end;