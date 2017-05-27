<?php

require_once('etc.php');
require_once('user.php');
require_once('form.php');

allow('POST');

$users = load_from_file('../data/users.json');

$result = new Result();
$data = [];

$rules = [
    Form::RegisterName => [
        'filter' => FILTER_DEFAULT,
        'errormsg' => 'A megadott felhasználónév nem megfelelő (szöveg) formátumú!'
    ],
    Form::RegisterEmail => [
        'filter' => FILTER_VALIDATE_EMAIL,
        'errormsg' => 'A megadott email-cím nem megfelelő formátumú!'
    ],
    Form::RegisterPassword => [
        'filter' => FILTER_DEFAULT,
        'errormsg' => 'A megadott jelszó nem megfelelő (szöveg) formátumú!'
    ],
    Form::RegisterPassword2 => [
        'filter' => FILTER_DEFAULT,
        'errormsg' => 'Az ismételt jelszó nem megfelelő (szöveg) formátumú!'
    ]
];

validate($_POST, $rules, $data, $result);

if(!$result->success()) {
    save_to_flash($result);
    redirect('index.php?page='.Pages::Register);
    die();
}

$name = $data[Form::RegisterName];
$email = $data[Form::RegisterEmail];
$pw1 = $data[Form::RegisterPassword];
$pw2 = $data[Form::RegisterPassword2];

if(!isset($users[$email])) {
    if($pw1 == $pw2) {
        $user = User::fromInput($name, $email, $pw1);
        $users[$email] = $user;
        $result->add_message('A regisztráció sikeres volt!');
    } else {
        $result->add_error("A két jelszó nem egyezik!");
    }
} else {
    $result->add_error("Ez az email-cím már foglalt!");
}

save_to_flash($result);

if($result->success()) {
    save_to_file("../data/users.json", $users);
    redirect('index.php?page='.Pages::Welcome);
} else {
    redirect('index.php?page='.Pages::Register);
}