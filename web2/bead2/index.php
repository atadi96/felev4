<?php

require_once('model/etc.php');
include_once('model/form.php');
include_once('model/user.php');

allow('GET');

$page = "";
$result = new Result();
$auth_result = auth();
if(isset($_GET["page"]) && !empty($_GET['page'])) {
    $page = $_GET['page'];
    if($auth_result->success() && $page == Pages::Welcome) {
        $page = Pages::Home;
    } else if(!$auth_result->success() && $page == Pages::Home) {
        $page = Pages::Welcome;
    } else if(!$auth_result->success() && $page != Pages::Welcome) {
            $auth_result->html();
    }
} else if($auth_result->success()) {
    $page = Pages::Home;
} else {
    $page = Pages::Welcome;
}

include("templates/header.template.php");
header_template("Fejtörő fényvesztő");

switch($page) {
    case Pages::Welcome:
        include("templates/welcome.template.php");
        break;
    case Pages::Home:
        include('templates/navbar.template.php');
        break;
    case Pages::Register:
        include("templates/register.template.php");
        break;
    case Pages::Levels:
        break;
    case Pages::Game:
        break;
    case Pages::Demo:
        break;
}