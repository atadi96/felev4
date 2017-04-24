/* A módosítást egy másodpéldányon végezzük, hogy a tábla eredeti tartalma megmaradjon
*/
CREATE TABLE dolg2 AS SELECT * FROM nikovits.dolgozo;
CREATE TABLE oszt2 AS SELECT * FROM nikovits.osztaly;
/*
UPDATE dolg2 ...
Ellen?rzés: SELECT ... FROM dolg2 ...         
*/
DROP TABLE dolg2;
/*
*/

--DELETE

-- Töröljük azokat a dolgozókat, akiknek jutaléka NULL.
DELETE FROM dolg2 WHERE jarulek IS NULL;
-- Töröljük azokat a dolgozókat, akiknek a belépési dátuma 1982 el?tti.
DELETE FROM dolg2 WHERE BELEPES < TO_DATE('1982-01-01', 'YYYY-MM-DD');
-- Töröljük azokat a dolgozókat, akik osztályának telephelye DALLAS.
DELETE FROM dolg2 WHERE oazon = (
  SELECT oazon FROM oszt2 WHERE telephely = 'DALLAS'
);
-- Töröljük azokat a dolgozókat, akiknek a fizetése kisebb, mint az átlagfizetés.
DELETE FROM dolg2 WHERE fizetes < (SELECT AVG(FIZETES) FROM dolgozo);
-- Töröljük a jelenleg legjobban keres? dolgozót
DELETE FROM dolg2 WHERE fizetes = (SELECT MAX(FIZETES) FROM dolgozo);

/* Töröljük ki azokat az osztályokat, akiknek van olyan dolgozója,
  aki a 2-es fizetési kategóriába esik (lásd még Fiz_kategoria táblát).
  (Adjuk meg azon osztályok nevét, amelyeknek van olyan dolgozója,
  aki a 2-es fizetési kategóriába esik)
*/
DELETE FROM oszt2 WHERE OAZON in (
  SELECT oazon
    FROM dolg2, fiz_kategoria
    WHERE fiz_kategoria.KATEGORIA = 2
      AND fizetes >= also
      AND fizetes <= fiz_kategoria.FELSO
);
-- Töröljük ki azon osztályokat, amelyeknek 2 olyan dolgozója van, aki a 2-es fizetési kategóriába esik.
SELECT * FROM oszt2 WHERE oazon in (
  SELECT dolg2.oazon
    FROM dolg2, fiz_kategoria
    WHERE fiz_kategoria.KATEGORIA = 2
      AND fizetes >= also
      AND fizetes <= fiz_kategoria.FELSO
    GROUP BY dolg2.oazon
      HAVING NUM(dkod) = 2
);
/*
INSERT

- Vigyünk fel egy 'Kovacs' nev? új dolgozót a 10-es osztályra a következ? 
  értékekkel: dkod=1, dnev='Kovacs', oazon=10, belépés=aktuális dátum,
  fizetés=a 10-es osztály átlagfizetése. A többi oszop legyen NULL.
*/

INSERT INTO dolg2(dkod, dnev, oazon, belepes, fizetes)
  VALUES(
    1,
    'Kovacs',
    10,
    CURRENT_DATE,
    (SELECT AVG(fizetes) FROM dolg2)
  );
  
--UPDATE

-- Növeljük meg a 20-as osztályon a dolgozók fizetését 20%-kal.

-- Növeljük meg azok fizetését 500-zal, akik jutaléka NULL vagy a fizetésük kisebb az átlagnál.

-- Növeljük meg mindenkinek a jutalékát a jelenlegi maximális jutalékkal. (NULL tekintsük 0-nak)

-- Módosítsuk 'Loser'-re a legrosszabbul keres? dolgozó nevét.

-- Növeljük meg azoknak a dolgozóknak a jutalékát 3000-rel, akiknek legalább 2 közvetlen beosztottjuk van. 
   Az ismeretlen (NULL) jutalékot vegyük úgy, mintha 0 lenne. 

-- Növeljük meg azoknak a dolgozóknak a fizetését, akiknek van beosztottja, a minimális fizetéssel

-- Növeljük meg a nem fonökök fizetését a saját osztályuk átlagfizetésével

