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
    } else if(!$auth_result->success() && $page != Pages::Welcome && $page != Pages::Register) {
        $page = Pages::Welcome;
        $auth_result->html();
    }
} else if($auth_result->success()) {
    $page = Pages::Home;
} else {
    $page = Pages::Welcome;
}

include("templates/header.template.php");
header_template("Mirror Puzzle");

switch($page) {
    case Pages::Welcome:
        include("templates/welcome.template.php");
        break;
    case Pages::Home:
        include('templates/navbar.template.php');
        include('templates/maplist.template.php');
        break;
    case Pages::Register:
        include("templates/register.template.php");
        break;
    case Pages::Game:
        include('templates/game.template.php');
        break;
    default:
        if($auth_result->success()) {
            include("templates/navbar.template.php");
        }
        ?>
            <div class="col-sm-6 col-sm-offset-3">
                <h1 class="alert alert-danger">The pade does not exist!</h1>
            </div>
        <?php
        break;
}