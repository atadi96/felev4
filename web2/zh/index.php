<?php

require_once('model/etc.php');
include_once('model/form.php');

allow('GET');

$page = isset($_GET['page']) ? $_GET['page'] : Pages::List;

switch($page) {
    case Pages::AddSong:
        include('templates/addSong.template.php');
        break;
    case Pages::SongDetails:
        include('templates/details.template.php');
        break;
    case Pages::List:
    default:
        include('templates/list.template.php');
        break;
}