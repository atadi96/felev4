

<?php
    include_once('templates/header.template.php');
    $maps = load_from_file('data/games.json');
    if(!isset($maps[$_GET[Form::MapName]]) || empty($maps[$_GET[Form::MapName]])) {
        header('Hiba!');
        (new Result([], [], ["A kiválasztott pálya nincs az adatbázisban!"]))->html();
        die();
    }
    $map = $maps[$_GET[Form::MapName]];
    header($map->name().' - Fénytörő Fejtörő');
    echo '<link rel="stylesheet" href="demo/index.css">';
    include('templates/navbar.template.php');
?>

<main class="container noselect">
    <h1><?= $map->name() ?> - Fénytörő fejtörő</h1>
    <div id="game">
        <table> 
            <caption>Tábla</caption>
            <tbody id="gamefield"> </tbody>
        </table>
        <table id="sparetable"> 
            <caption>Hozzáadandó</caption>
            <tbody id="sparefield"> </tbody>
        </table>
        <table id="targetnumtable">
            <caption>Célok száma</caption>
            <tr>
                <td id="targetnum"></td>
            </tr>
        </table>
        <svg width="450px" height="450px">
            <path id="laserpath" d="" stroke="red" stroke-width="3" fill="none">
        </svg>
        <div id="buttons">
            <button id="clearbutton">Lézerek törlése</button>
            <button id="evalbutton">Ellenőrzés</button>
            <span id="gamewontext"></span>
        </div>
    </div>
</main>
<script src="templates/game.js.php" lang="text/javascript"></script>