<?php

require_once('etc.php');
require_once('form.php');

allow('POST');

function error($code) {
    http_response_code($code);
    die();
}

$auth_result = auth();
if(!$auth_result->success()) {
    error(401);
}

$email = current_user()['email'];

$rules = [
    Form::FinishedMapName => [
        'filter' => FILTER_DEFAULT,
        'errormsg' => 'You didn\'t specify the name of the passed level!'
    ]
];

$data;

validate($_POST, $rules, $data, $auth_result);

$map_name=$data[Form::FinishedMapName];

if(!$auth_result->success()) {
    error(400);
}

$maps = load_from_file('../data/games.json');

if(!isset($maps[$map_name])) {
    error(400);
}

if(!isset($maps[$map_name]['finished'][$email])) {
    $maps[$map_name]['finished'][$email] = $email;
    save_to_file('../data/games.json', $maps);
}

