<?php

require_once 'functions.php';

allow('POST');

$game = load_from_file('game.json');

$x = $_POST['x'];
$y = $_POST['y'];
$color = $_POST['color'];

$game[$y][$x]['color'] = $color;

save_to_file('game.json', $game);