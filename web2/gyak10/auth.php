<?php

require_once 'functions.php';
allow('POST');

$users = load_from_file('users.json');

$input = [];
$errors = [];
$messages = [];


if(not_empty($_POST, 'username')) {
    $input['username'] = (string)$_POST['username'];
} else {
    $errors[] = "Nem adtál meg felhasználónevet!";
}

if(not_empty($_POST, 'password')) {
    $input['password'] = $_POST['password'];
} else {
    $errors[] = 'Nem adtál meg jelszót!';
}

if(!$errors) {
    if(password_verify($input['password'], $users[$input['username']])) {
        $messages = "Sikeres bejelentkezés";
        $_SESSION['logged_in'] = $input['username'];
        save_to_flash([
            'errors' => $errors,
            'messages' => $messages
        ]);

        redirect('index.php');
    } else {
        $errors[] = "Hibás felhasználónév vagy jelszó!";
        save_to_flash([
            'errors' => $errors,
            'messages' => $messages
        ]);
        redirect('reg.php');
    }
} else {
    save_to_flash([
        'errors' => $errors,
        'messages' => $messages
    ]);

    redirect('reg.php');
}