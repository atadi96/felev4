<?php

$base_url = 'base_url = http'.
            (isset($_SERVER['HTTPS'])?'s':'').
            '://'.
            $_SERVER['SERVER_NAME'].
            substr(
                $_SERVER['SCRIPT_NAME'],
                0,
                strlen($_SERVER['SCRIPT_NAME']) - strlen('init.php')
            ).
            "\n";

file_put_contents(
    'config.ini',
    $base_url
);
$check = @file_get_contents('config.ini');
if($check == $base_url) {
    echo 'config.ini created successgully!';
} else {
    echo 'Couldn\t create the config.ini file!';
}