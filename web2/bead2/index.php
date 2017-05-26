<?php

require_once('etc.php');

class Pages {
    const Welcome = "welcome";
    const Home = "home";
    const Register = "register";
    const Levels = "levels";
    const Game = "game";
    const Demo = "demo";
}

$page = "";
$result = new Result();
if(isset($_GET["page"]) && !empty($_GET['page'])) {
    $page = $_GET['page'];
} else if(auth()->success()) {
    $page = Pages::Home;
} else {
    $page = Pages::Welcome;
    $result = $result->concat(auth());
}

include("templates/header.template.php");
header_template("Fejtörő fényvesztő");

switch($page) {
    case Pages::Welcome:
        include("templates/welcome.template.php");
        break;
    case Pages::Home:
        break;
    case Pages::Register:
        break;
    case Pages::Levels:
        break;
    case Pages::Game:
        break;
    case Pages::Demo:
        break;
}