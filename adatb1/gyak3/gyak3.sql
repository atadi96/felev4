--http://people.inf.elte.hu/vopraai/adatb17/feladat2.txt
--SZERET tábla
--8.feladat - legalább 2féle gyümölcs
--pi(szigma(sz1.n=sz2.n és sz1.gy!=sz2.gy)(sz1×sz2))
--pi = project; szigma = select; ró = rename
SELECT DISTINCT sz1.nev
  FROM szeret sz1, szeret sz2
  WHERE 
    sz1.nev = sz2.nev AND
    sz1.GYUMOLCS != sz2.GYUMOLCS;
--9.feladat - legalább 3féle gyümölcs
--X = 
SELECT DISTINCT sz1.nev
  FROM szeret sz1, szeret sz2, szeret sz3
  WHERE 
    sz1.nev = sz2.nev AND
    sz1.GYUMOLCS != sz2.GYUMOLCS AND
    sz1.GYUMOLCS != sz3.GYUMOLCS AND
    sz2.GYUMOLCS != sz3.GYUMOLCS;
--10. feladat - legfeljebb 2féle gyümölcs
--PI_n(SZ) - x
SELECT NEV FROM szeret MINUS (
  SELECT DISTINCT sz1.nev
  FROM szeret sz1, szeret sz2, szeret sz3
  WHERE 
    sz1.nev = sz2.nev AND
    sz1.GYUMOLCS != sz2.GYUMOLCS AND
    sz1.GYUMOLCS != sz3.GYUMOLCS AND
    sz2.GYUMOLCS != sz3.GYUMOLCS
);
--11. feladat = feladat_8 MINUS feladat_9
(
  SELECT DISTINCT sz1.nev
    FROM szeret sz1, szeret sz2
    WHERE 
      sz1.nev = sz2.nev AND
      sz1.GYUMOLCS != sz2.GYUMOLCS
) MINUS (
  SELECT DISTINCT sz1.nev
  FROM szeret sz1, szeret sz2, szeret sz3
  WHERE 
    sz1.nev = sz2.nev AND
    sz1.GYUMOLCS != sz2.GYUMOLCS AND
    sz1.GYUMOLCS != sz3.GYUMOLCS AND
    sz2.GYUMOLCS != sz3.GYUMOLCS
);

--DOLGOZO feladatok
--11. feladat - dolgozok, akinek a fonoke king
SELECT d1.dnev
  FROM dolgozo d1, dolgozo d2
  WHERE d2.dnev = 'KING'
    AND d1.fonoke = d2.dkod;
--12. feladat - fonokok neve, akik nem 'MANAGER'-ek
SELECT d1.dnev
  FROM dolgozo d1, dolgozo d2
  WHERE d2.foglalkozas != 'MANAGER'
    AND d1.fonoke = d2.dkod;
--13.feladat - dolgozo, aki tobbet keres a fonokenel
SELECT d1.dnev
  FROM dolgozo d1, dolgozo d2
  WHERE d1.fonoke = d2.dkod
    AND d1.fizetes > d2.fizetes;
--14.feladat - dolgozók, akiknek a fonokenek a fonoke 'KING'
SELECT d1.dnev
  FROM dolgozo d1, dolgozo d2, dolgozo d3
  WHERE d1.fonoke = d2.dkod
    AND d2.fonoke = d3.dkod
    AND d3.dnev = 'KING';
--15.feladat - dolgozok, akinek osztaly telephelye DALLAS vagy CHICAGO
SELECT dolg.dnev
  FROM dolgozo dolg, dept telep
  WHERE dolg.OAZON = telep.DEPTNO
    AND (telep.LOC = 'DALLAS'
        OR telep.LOC = 'CHICAGO');
SELECT dolg.dnev
  FROM dolgozo dolg, dept telep
  WHERE dolg.OAZON = telep.DEPTNO
    AND telep.LOC in ('DALLAS', 'CHICAGO');
--16.feladat - dolgozok, akinek osztaly telephelye nem (DALLAS vagy CHICAG)
SELECT dolg.dnev
  FROM dolgozo dolg, dept telep
  WHERE dolg.OAZON = telep.DEPTNO
    AND NOT(telep.LOC = 'DALLAS'
            OR telep.LOC = 'CHICAGO');
SELECT dolg.dnev
  FROM dolgozo dolg, dept telep
  WHERE dolg.OAZON = telep.DEPTNO
    AND telep.LOC not in ('DALLAS', 'CHICAGO');
--17.feladat - dolgozo, aki >2000 keres, vagy CHICAGOI
SELECT dolg.dnev
  FROM dolgozo dolg, dept telep
  WHERE dolg.OAZON = telep.DEPTNO
    AND (dolg.FIZETES > 2000
        OR telep.LOC = 'CHICAGO');
--18.feladat - osztaly, aminek nincs dolgozoja
--PI_OAZON(O) - PI_OAZON(D) -- nem ez az SQL, mert nevet kertek
(
SELECT dname FROM dept
) MINUS (
  SELECT DISTINCT dept.dname
    FROM dept, dolgozo dolg
    WHERE dept.deptno = dolg.oazon
);
--19.feladat - van >2000 fizetes beosztott
--PI_d2.nev(SZIGMA_(d1.fonoke = d2.dkod && d1.fizetes>2000) (d1×d2))
SELECT DISTINCT d2.dnev
  FROM dolgozo d1, dolgozo d2
  WHERE d1.fonoke = d2.dkod
    AND d1.fizetes > 2000;
--20.feladat - nincs >2000 fizetesu beosztott
--PI_dnev(dolgozo) - feladat19
(SELECT dnev from dolgozo
) MINUS (
SELECT DISTINCT d2.dnev
  FROM dolgozo d1, dolgozo d2
  WHERE d1.fonoke = d2.dkod
    AND d1.fizetes > 2000
);
--21. feladat - telephely, ahol van elemzo
--PI_thely.dname(SZIGMA_(dolg.oazon=thely.deptno && dolg.foglalkozas='ANALYST')(dolg×thely))
SELECT DISTINCT thely.dname
  FROM dolgozo dolg, dept thely
  WHERE dolg.oazon = thely.deptno
    AND dolg.foglalkozas = 'ANALYST';
--22. feladat - telephely, ahol nincs ANALYST
--PI_dname(DEPT) - feladat20
(SELECT dname FROM dept
) MINUS (
SELECT DISTINCT thely.dname
  FROM dolgozo dolg, dept thely
  WHERE dolg.oazon = thely.deptno
    AND dolg.foglalkozas = 'ANALYST'
);
--23.feladat max fizetesu dolgozok neve
SELECT dnev
  FROM dolgozo
  WHERE fizetes = (
    SELECT MAX(fizetes)
      FROM dolgozo
  );
--2000nel nagyobb fizetesek
SELECT dnev
  FROM dolgozo
  WHERE fizetes in (
    SELECT fizetes
      FROM dolgozo
      WHERE fizetes > 2000
  );