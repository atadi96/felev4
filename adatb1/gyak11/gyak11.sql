/*CREATE VIEW EXAMPLE_VIEW AS
  SELECT *
  FROM DOLGOZO JOIN FIZ_KAT
    ON FIZETES >= ALSÓ AND FIZETES <= FELSÕ; */
    
CREATE OR REPLACE FUNCTION KAT_ATLAG(N INT) RETURN NUMBER IS
  CURSOR CURS1 IS SELECT *
    FROM DOLGOZO JOIN FIZ_KAT
      ON FIZETES >= ALSÓ AND FIZETES <= FELSÕ
      WHERE FIZ_KAT = N
      --FOR UPDATE fizetes
      ;
  REC CURS1%ROWTYPE;
  atl FLOAT;
  db INT;
/*
begin
  open curs1;
  begin loop
    if curs1%notfound then exit;
    fetch curs1 into rec;
    ...
  end loop;
  close;
end;
console olvasás: ACCEPT L_ONEV VARCHAR(1) PROMTP 'arbitrary szoveg';
a session-ben olvashato lesz &L_ONEV-vel
dbms_putline('kiirando ' || &L_ONEV || ' szoveg');
REGEXP_COUNT('alma', '[aeiou]', 1, 'i');
*/
BEGIN
  ATL := 0.0;
  DB := 0;
  FOR REC IN CURS1 LOOP
    atl := atl + rec.fizetes;
    db := db + 1;
    --UPDATE dolgozo SET fizetes = fizetes + 1 WHERE CURRENT OF CURS1;
  end loop;
  atl := atl / db;
END;
  
  