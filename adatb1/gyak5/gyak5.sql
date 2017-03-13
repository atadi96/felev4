SELECT 
  fizetes,
  count(*),
  count(fizetes),
  count(distinct fizetes),
  sum(fizetes),
  sum(distinct fizetes),
  avg(fizetes),
  avg(distinct fizetes)
  FROM dolgozo
  WHERE dnev like '%O%'
  GROUP BY fizetes
  HAVING SUM(fizetes) >= 2000;
  
CREATE TABLE FIZ_KATEGORIA AS SELECT * FROM NIKOVITS.FIZ_KATEGORIA;

--minden dolgozohoz hozzarendeljuk a fizetesi kategoriajat
SELECT dolgozo.dnev, fiz_kategoria.kategoria
  FROM dolgozo, fiz_kategoria
  WHERE dolgozo.FIZETES BETWEEN fiz_kategoria.ALSO AND fiz_kategoria.felso;
  
--minden dolgozohoz hozzarendeljuk a fizetesi kategoriajat
SELECT fiz_kategoria.kategoria, COUNT(*) dszam
  FROM dolgozo, fiz_kategoria
  WHERE dolgozo.FIZETES BETWEEN fiz_kategoria.ALSO AND fiz_kategoria.felso
  GROUP BY fiz_kategoria.kategoria
  --HAVING dszam > 3;
  HAVING count(distinct oazon) = 1;
  
SELECT DECODE(MOD(dkod, 2), 0, 'Páros', 'Páratlan') paritas, COUNT(*)
  FROM dolgozo
  GROUP BY MOD(dkod, 2);
  
--foglalkozasonkenti átlagfizetés
SELECT 
      foglalkozas,
      COUNT(*),
      ROUND(AVG(fizetes)) atlag,
      RPAD(' ', FLOOR(ROUND(AVG(fizetes))/200)+1, '#')
  FROM dolgozo
  GROUP BY foglalkozas;

SELECT COUNT(distinct gyumolcs) FROM szeret;
--ki szeret minden gyümölcsöt
SELECT nev, COUNT(*)
  FROM SZERET
  GROUP BY nev
  HAVING COUNT(*) = (SELECT COUNT(distinct gyumolcs) FROM szeret);

(SELECT *
FROM
  (SELECT nev FROM szeret),
  (SELECT gyumolcs
    FROM szeret
    WHERE nev = 'Micimackó'))
    MINUS (SELECT * FROM szeret);
    
SELECT DISTINCT sz1.nev, sz2.nev
  FROM szeret sz1, szeret sz2
  WHERE EXISTS (
    SELECT distinct gyumolcs FROM szeret WHERE nev = sz1.nev
    MINUS
    SELECT distinct gyumolcs FROM szeret WHERE nev = sz2.nev 
  );
  
