-- DOLGOZO feladatok

SELECT DNEV FROM dolgozo WHERE fizetes >= 2800; --1. feladat
SELECT * FROM dolgozo WHERE oazon=10 OR oazon=20; --2.feladat
SELECT * FROM dolgozo WHERE jutalek > 600; --3. feladat
SELECT * FROM dolgozo WHERE jutalek<=600 OR jutalek IS NULL; --4.feladat
SELECT * FROM dolgozo WHERE jutalek IS NULL; --5.feladat
SELECT DISTINCT foglalkozas FROM dolgozo; --6.feladat
SELECT dnev, fizetes*2 FROM dolgozo WHERE oazon = 10; --7.feladat
SELECT dnev FROM dolgozo WHERE belepes > TO_DATE('1982-01-01', 'YYYY-MM-DD');--8.feladat
SELECT dnev FROM dolgozo WHERE fonoke IS NULL; --9.feladat
SELECT dnev FROM dolgozo WHERE fonoke = (SELECT dkod FROM dolgozo WHERE dnev='KING');--10.feladat

-- SZERET feladatok
SELECT * FROM szeret;
SELECT gyumolcs FROM szeret WHERE nev='Micimackó'; --1.feladat
SELECT gyumolcs FROM szeret
  WHERE gyumolcs NOT IN (SELECT gyumolcs FROM szeret WHERE nev = 'Micimackó');--2. feladat
SELECT gyumolcs FROM (
  (SELECT DISTINCT gyumolcs FROM szeret) 
  MINUS
  (SELECT gyumolcs FROM szeret WHERE nev = 'Micimackó')
);--2.feladat
SELECT nev FROM szeret WHERE gyumolcs = 'alma';--3.feladat
(SELECT DISTINCT nev FROM szeret) MINUS (SELECT nev FROM szeret WHERE gyumolcs = 'körte');--4.feladat
SELECT DISTINCT nev FROM szeret WHERE gyumolcs='alma' OR gyumolcs='körte';--5.feladat
(SELECT nev FROM szeret WHERE gyumolcs='alma') UNION (SELECT nev FROM szeret WHERE gyumolcs='alma');--5.feladat
(SELECT nev FROM szeret WHERE gyumolcs='alma') INTERSECT (SELECT nev FROM szeret WHERE gyumolcs='körte');--6.feladat
(SELECT nev FROM szeret WHERE gyumolcs='alma') MINUS (SELECT nev FROM szeret WHERE gyumolcs='körte');--7.feladat

-- EGYÉB feladatok - táblamûveletek

DROP TABLE szeret;

CREATE TABLE szeret (
  nev VARCHAR(10),
  gyumolcs VARCHAR(10)
);
INSERT INTO szeret VALUES ('Micimackó', 'alma');
INSERT INTO szeret VALUES ('Neptune', 'puding');
INSERT INTO szeret VALUES ('Noire', 'Neptune');

DROP TABLE szeret;

CREATE TABLE szeret AS (SELECT * FROM nikovits.szeret);