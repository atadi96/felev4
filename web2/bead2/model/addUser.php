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
        'errormsg' => 'Invalid username format!'
    ],
    Form::RegisterEmail => [
        'filter' => FILTER_VALIDATE_EMAIL,
        'errormsg' => 'Invalid email format!'
    ],
    Form::RegisterPassword => [
        'filter' => FILTER_DEFAULT,
        'errormsg' => 'Invalid password format!'
    ],
    Form::RegisterPassword2 => [
        'filter' => FILTER_DEFAULT,
        'errormsg' => 'Invalid repeat password format!'
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
        $result->add_message('Your account has been dreated successfully!');
    } else {
        $result->add_error("The two passwords don't match!");
    }
} else {
    $result->add_error("This email address is already taken!");
}

save_to_flash($result);

if($result->success()) {
    save_to_file("../data/users.json", $users);
    redirect('index.php?page='.Pages::Welcome);
} else {
    redirect('index.php?page='.Pages::Register);
}