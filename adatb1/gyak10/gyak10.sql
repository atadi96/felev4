CREATE OR REPLACE FUNCTION faktor(n integer) RETURN integer IS
begin
  IF n = 0 THEN
      RETURN 1;
  ELSE
      RETURN n * faktor(n-1);
  END IF;
end;

SELECT faktor(5) FROM DUAL;

create or replace FUNCTION hanyszor(p1 VARCHAR2, p2 VARCHAR2) RETURN integer IS
  c int := 0;
  i int;
begin
  for i in 1..length(p1)-length(p2)+1 loop
    if substr(p1, i, length(p2)) = p2 then
      res := res + 1;
    end if;
  end loop;
  return c;
end;

create or replace FUNCTION osszeg(p_char VARCHAR2) RETURN number IS
  res int := 0;
  tmp VARCHAR(10) := "";
  i int;
begin
  for i in 1..length(p_char) loop
    if substr(p_char, i, 1) != '+' then
      tmp := tmp || substr();
    else
      res := res + TO_NUMBER(tmp);
      tmp := "";
    end if;
  end loop;
  res := res + TO_NUMBER(tmp);
  return res;
end;  