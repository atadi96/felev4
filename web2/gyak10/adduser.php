<?php

require_once 'functions.php';
allow('POST');

$users = load_from_file('users.json');

$input = [];
$errors = [];
$messages = [];


if(not_empty($_POST, 'username')) {
    if(!isset($users[$_POST['username']])) {
        $input['username'] = (string)$_POST['username'];
    } else {
        $errors[] = "Van már ilyen felhasználó";
    }
} else {
    $errors[] = "Nem adtál meg felhasználónevet!";
}

if(not_empty($_POST, 'password')) {
    if($_POST['password'] === $_POST['password2']) {
        $input['password'] = $_POST['password'];
    } else {
        $errors[] = 'A két jelszó nem egyezik meg!';
    }
} else {
    $errors[] = 'Nem adtál meg jelszót!';
}

if(!$errors) {
    $users[$input['username']] = password_hash($input['password'], PASSWORD_DEFAULT);

    save_to_file('users.json', $users);

    save_to_flash([
        'errors' => $errors,
        'messages' => $messages
    ]);

    redirect('login.php');
} else {
    save_to_flash([
        'errors' => $errors,
        'messages' => $messages
    ]);

    redirect('reg.php');
}