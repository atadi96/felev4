with Ada.Text_IO, Ada.Numerics.Discrete_Random;
 use Ada.Text_IO;

procedure Utkereszt is

	type Lampa_Szinek is (Piros, Piros_Sarga, Zold, Sarga);
	
	protected Jelzolampa is
		procedure Valt;
		function Szin return Lampa_Szinek;
		entry Athalad;
	private
		Akt_Szin: Lampa_Szinek := Piros;
	end Jelzolampa;
	
	protected body Jelzolampa is
		entry Athalad when Akt_Szin = Zold is
		begin
			Put_Line("Jelzolampa: egy auto athaladt");
		end;
		procedure Valt is
		begin
			if Akt_Szin = Sarga then
				Akt_Szin := Piros;
			else
				Akt_Szin := Lampa_Szinek'Succ(Akt_Szin);
			end if;
			Put_Line(Lampa_Szinek'Image(Akt_Szin));
		end Valt;
		
		function Szin return Lampa_Szinek is
		begin
			return Akt_Szin;
		end Szin;
	end Jelzolampa;
	
	task Utemezo is
		entry Leall;
	end Utemezo;
	
	task body Utemezo is
		Megy: Boolean := True;
	begin
		while Megy loop
			Jelzolampa.Valt;
			delay 3.0;
			Jelzolampa.Valt;
			delay 0.5;
			Jelzolampa.Valt;
			delay 2.0;
			Jelzolampa.Valt;
			delay 1.0;
			
			select
				accept Leall do
					Megy := False;
				end Leall;
			else
				Put_Line("A szimulacio fut tovabb");
			end select;
		end loop;
	end Utemezo;
	
	type PString is access String;
	type PDuration is access Duration;
	task type Auto(Rendszam: PString; Menetido_A_Lampaig: PDuration);
	
	type Iranyok is (Egyenesen_Megy, Fordul);
	
	type PAuto is access Auto;
	Autok: array(1..3) of PAuto;
	
	package Irany_Random_Pack is new Ada.Numerics.Discrete_Random(Iranyok);
	
	protected Irany_Random is
		procedure Reset;
		entry General(Irany: out Iranyok);
	private
		G: Irany_Random_Pack.Generator;
		Inicializalt: Boolean := False;
	end Irany_Random;
	
	protected body Irany_Random is
		procedure Reset is begin
			Irany_Random_Pack.Reset(G);
			Inicializalt := True;
		end;
		entry General(Irany: out Iranyok) when Inicializalt is begin
			Irany := Irany_Random_Pack.Random(G);
		end General;
	end Irany_Random;
	
	task body Auto is
		Atment: Boolean := False;
		Irany: Iranyok;
	begin
		Put_Line(Rendszam.all & " elindult");
		delay Menetido_A_Lampaig.all;
		Put_Line(Rendszam.all & " megerkezett a lampahoz");
		while not Atment loop
			select
				Jelzolampa.Athalad;
				Atment := True;
				Irany_Random.General(Irany);
				Put_Line(Rendszam.all
						& " athaladt "
						& Iranyok'Image(Irany)
						& " iranyba"
						);
			or delay 0.2;
				Put_Line(Rendszam.all & " varakozik");
			end select;
		end loop;
	end Auto;
	
	task Lampakezelo;
	
	task body Lampakezelo is
	begin
		delay 15.0;
		Utemezo.Leall;
		Put_Line("A szimulacio veget ert");
	end;
	
begin
	Irany_Random.Reset;
	Autok(1) := new Auto(new String'("NOT-911"), new Duration'(1.5));
	Autok(2) := new Auto(new String'("LUL-123"), new Duration'(3.3));
	Autok(3) := new Auto(new String'("OSU-300"), new Duration'(7.5));
end;