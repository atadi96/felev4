<?php

require_once('etc.php');
require_once('form.php');

allow('GET');

function error($code, $description = "") {
    http_response_code($code);
    die(print($description));
}

$auth_result = auth();
if(!$auth_result->success()) {
    error(401, "You're not logged in!");
}

$rules = [
    Form::FinishedMapName => [
        'filter' => FILTER_DEFAULT,
        'errormsg' => 'You didn\'t specify the name of the passed level!'
    ]
];

$data;

validate($_GET, $rules, $data, $auth_result);

if(!$auth_result->success()) {
    error(400);
}

$map_name=$data[Form::FinishedMapName];

$maps = load_from_file('../data/games.json');

if(!isset($maps[$map_name])) {
    error(400);
}

$map_users = $maps[$map_name]['finished'];

$users = load_from_file('../data/users.json');

foreach($map_users as $email) {
    echo $users[$email]['name']."\n";
}

