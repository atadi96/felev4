/* A m�dos�t�st egy m�sodp�ld�nyon v�gezz�k, hogy a t�bla eredeti tartalma megmaradjon
*/
CREATE TABLE dolg2 AS SELECT * FROM nikovits.dolgozo;
CREATE TABLE oszt2 AS SELECT * FROM nikovits.osztaly;
/*
UPDATE dolg2 ...
Ellen?rz�s: SELECT ... FROM dolg2 ...         
*/
DROP TABLE dolg2;
/*
*/

--DELETE

-- T�r�lj�k azokat a dolgoz�kat, akiknek jutal�ka NULL.
DELETE FROM dolg2 WHERE jarulek IS NULL;
-- T�r�lj�k azokat a dolgoz�kat, akiknek a bel�p�si d�tuma 1982 el?tti.
DELETE FROM dolg2 WHERE BELEPES < TO_DATE('1982-01-01', 'YYYY-MM-DD');
-- T�r�lj�k azokat a dolgoz�kat, akik oszt�ly�nak telephelye DALLAS.
DELETE FROM dolg2 WHERE oazon = (
  SELECT oazon FROM oszt2 WHERE telephely = 'DALLAS'
);
-- T�r�lj�k azokat a dolgoz�kat, akiknek a fizet�se kisebb, mint az �tlagfizet�s.
DELETE FROM dolg2 WHERE fizetes < (SELECT AVG(FIZETES) FROM dolgozo);
-- T�r�lj�k a jelenleg legjobban keres? dolgoz�t
DELETE FROM dolg2 WHERE fizetes = (SELECT MAX(FIZETES) FROM dolgozo);

/* T�r�lj�k ki azokat az oszt�lyokat, akiknek van olyan dolgoz�ja,
  aki a 2-es fizet�si kateg�ri�ba esik (l�sd m�g Fiz_kategoria t�bl�t).
  (Adjuk meg azon oszt�lyok nev�t, amelyeknek van olyan dolgoz�ja,
  aki a 2-es fizet�si kateg�ri�ba esik)
*/
DELETE FROM oszt2 WHERE OAZON in (
  SELECT oazon
    FROM dolg2, fiz_kategoria
    WHERE fiz_kategoria.KATEGORIA = 2
      AND fizetes >= also
      AND fizetes <= fiz_kategoria.FELSO
);
-- T�r�lj�k ki azon oszt�lyokat, amelyeknek 2 olyan dolgoz�ja van, aki a 2-es fizet�si kateg�ri�ba esik.
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

- Vigy�nk fel egy 'Kovacs' nev? �j dolgoz�t a 10-es oszt�lyra a k�vetkez? 
  �rt�kekkel: dkod=1, dnev='Kovacs', oazon=10, bel�p�s=aktu�lis d�tum,
  fizet�s=a 10-es oszt�ly �tlagfizet�se. A t�bbi oszop legyen NULL.
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

-- N�velj�k meg a 20-as oszt�lyon a dolgoz�k fizet�s�t 20%-kal.

-- N�velj�k meg azok fizet�s�t 500-zal, akik jutal�ka NULL vagy a fizet�s�k kisebb az �tlagn�l.

-- N�velj�k meg mindenkinek a jutal�k�t a jelenlegi maxim�lis jutal�kkal. (NULL tekints�k 0-nak)

-- M�dos�tsuk 'Loser'-re a legrosszabbul keres? dolgoz� nev�t.

-- N�velj�k meg azoknak a dolgoz�knak a jutal�k�t 3000-rel, akiknek legal�bb 2 k�zvetlen beosztottjuk van. 
   Az ismeretlen (NULL) jutal�kot vegy�k �gy, mintha 0 lenne. 

-- N�velj�k meg azoknak a dolgoz�knak a fizet�s�t, akiknek van beosztottja, a minim�lis fizet�ssel

-- N�velj�k meg a nem fon�k�k fizet�s�t a saj�t oszt�lyuk �tlagfizet�s�vel

