# Web2 2. beadandó

## A honlap konfigurálása

A redirect-ek megfelelő működéséhez a honlapnak ismernie kell az `index.php` könyvtárának url-jét.
A honlap beállításához nyissa meg a `setup.php` fájlt a böngészőből. Ha ez nem működne,
akkor hozzon létre egy `config.ini` fájlt az `index.php` fájl mellett, és írja bele, 
hogy `base_url = http://beadandó/elérési/útja/`.

## Megoldott feladatok

* Lehet regisztrálni, és a regisztrált adatokkal bejelentkezni. (1 pont)
* A pályalista feltünteti a nehézséget, a teljesítők számát és azt, hogy a bejelentkezett       felhasználó megoldotta-e már. (2 pont)
* Bejelentkezett felhasználó sikeres megoldás után a sikerességet elmenti a szerveren, a        mentéshez és a teljesítők listája lekérdezéséhez AJAX technológiát használ. (2 pont)
* Nincs nagyobb programhiba, nem csalhatók elő furcsa jelenségek (2 pont)