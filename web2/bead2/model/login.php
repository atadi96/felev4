<?php

require_once('etc.php');
require_once('user.php');
require_once('form.php');

allow('POST');

$users = load_from_file('../data/users.json');

$result = new Result();
$data = [];

$rules = [
    Form::LoginEmail => [
        'filter' => FILTER_VALIDATE_EMAIL,
        'errormsg' => 'A megadott email-cím nem megfelelő formátumú!'
    ],
    Form::LoginPassword => [
        'filter' => FILTER_DEFAULT,
        'errormsg' => 'A megadott jelszó nem megfelelő (szöveg) formátumú!'
    ]
];

validate($_POST, $rules, $data, $result);

if(!$result->success()) {
    save_to_flash($result);
    redirect('index.php?page='.Pages::Welcome);
    die();
}

$email = $data[Form::LoginEmail];
$pw1 = $data[Form::LoginPassword];

if(isset($users[$email])) {
    $user = User::fromDatabase($users[$email]);
    if($user->verify_password($pw1)) {
        login($user);
    } else {
        $result->add_error("Hibás email-cím vagy jelszó!");
    }
} else {
    $result->add_error("Hibás email-cím vagy jelszó!");
}

save_to_flash($result);

if($result->success()) {
    redirect('index.php?page='.Pages::Home);
} else {
    redirect('index.php?page='.Pages::Welcome);
}