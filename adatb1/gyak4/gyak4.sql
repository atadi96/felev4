DROP TABLE csatak;
DROP TABLE hajok;
DROP TABLE hajoosztalyok;
DROP TABLE kimenetelek;
create table csatak as select * from nikovits.csatak;
create table hajok as select * from nikovits.hajok;
create table hajoosztalyok as select * from nikovits.hajoosztalyok;
create table kimenetelek as select * from nikovits.kimenetelek;

create table fizkategoria as select * from nikovits.fizkategoria;

--1. feladat --Yamato FTW
SELECT osztaly, orszag FROM hajoosztalyok WHERE KALIBER>=16;
--2. feladat --KONGOU DE~SU
SELECT hajonev FROM hajok WHERE FELAVATVA < 1921;
--3. feladat --R.I.P. Bismark :'(
SELECT hajonev
  FROM kimenetelek
  WHERE CSATANEV='Denmark Strait'
    AND EREDMENY='elsullyedt'; 
--4. feladat
SELECT hajok.hajonev
  FROM hajok, hajoosztalyok
  WHERE hajoosztalyok.OSZTALY = hajok.OSZTALY
    AND hajok.FELAVATVA > 1921
    AND hajoosztalyok.VIZKISZORITAS > 35000;
--5. feladat
SELECT hajok.hajonev, hajoosztalyok.vizkiszoritas, hajoosztalyok.agyukszama
  FROM hajok, hajoosztalyok, kimenetelek
  WHERE hajok.OSZTALY = hajoosztalyok.osztaly
    AND hajok.hajonev = kimenetelek.hajonev
    AND kimenetelek.csatanev = 'Guadalcanal';
--6. feladat
--Adjuk meg az adatbázisban szereplõ összes hadihajó nevét. (Ne feledjük,
--hogy a Hajók relációban nem feltétlenül szerepel az összes hajó!)

--dolgozók
SELECT dnev, fizetes, RPAD(' ', ROUND(fizetes/1000,0), '#')
  FROM dolgozo;
  
SELECT dnev, fizetes, jutalek, ROUND((NVL(jutalek,0) / fizetes),2)
  FROM dolgozo;
  
SELECT MAX(fizetes), SUM(fizetes) FROM dolgozo;
SELECT AVG(fizetes) FROM dolgozo WHERE oazon = 20;
SELECT COUNT(distinct foglalkozas) FROM dolgozo;
SELECT COUNT(*) FROM dolgozo WHERE fizetes > 2000;

SELECT oazon, AVG(fizetes) FROM dolgozo GROUP BY oazon;

SELECT dept.deptno, dept.DNAME, AVG(dolgozo.fizetes)
  FROM dolgozo, dept
  WHERE dolgozo.oazon = dept.DEPTNO
  GROUP BY dept.deptno, dept.DNAME;
  
--egy egy osztályon hány ember dolgozik?
--SELECT COUNT(*) d FROM 

SELECT AVG(fizetes)
  FROM dolgozo
  GROUP BY oazon
  HAVING AVG(fizetes) > 2000;
  
SELECT dept.deptno, dept.dname, AVG(dolgozo.fizetes)
  FROM dolgozo, dept
  WHERE dolgozo.oazon = dept.deptno
  GROUP BY dept.deptno, dept.dname
  HAVING COUNT(*) > 4;
  
SELECT dept.deptno, dept.dname
  FROM dolgozo, dept
  WHERE dolgozo.oazon = dept.deptno
  GROUP BY dept.deptno, dept.dname
  HAVING AVG(dolgozo.fizetes) > 2000;
