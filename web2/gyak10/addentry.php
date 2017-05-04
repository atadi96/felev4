<?php

require_once 'functions.php';
allow('POST');

$expenses = load_from_file('data.json');

$input = [];
$errors = [];
$messages = [];


if(not_empty($_POST, 'desc')) {
    $input['desc'] = (string)$_POST['desc'];
} else {
    $errors[] = "Nem adtál meg leírást!";
}
if(not_empty($_POST, 'amount')) {
    if(is_numeric($_POST['amount'])) {
        $input['amount'] = (int)$_POST['amount'];
    } else {
        $errors[] = "A megadott összeg nem szám!";
    }
} else {
    $errors[] = "Nem adtál meg összeget!";
}

if(!$errors) {
    $expenses[] = $input;
    $messages[] = "Tétel sikeresen elmentve!";
    save_to_file('data.json', $expenses);
}

save_to_flash([
    'errors' => $errors,
    'messages' => $messages
]);

redirect('index.php');