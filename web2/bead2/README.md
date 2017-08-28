# Web2 2. assignment

## Configuring the website

A redirect-ek megfelelő működéséhez a honlapnak ismernie kell az `index.php` könyvtárának url-jét.
A honlap beállításához nyissa meg a `setup.php` fájlt a böngészőből. Ha ez nem működne,
akkor hozzon létre egy `config.ini` fájlt az `index.php` fájl mellett, és írja bele, 
hogy `base_url = http://beadandó/elérési/útja/`.

## Implemented Features

* Registration, login with registered accounts
* The level list shows the difficulty level, the number of players who already solved the level, and that the logged in player has solved the level or not
* When a logged in user solves a puzzle, this gets saved on the server and the other winner players get displayed with AJAX technology
* No big bugs, the website can not crash