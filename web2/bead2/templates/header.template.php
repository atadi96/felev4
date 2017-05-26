<?php

function header_template($title) {
    ?>
    
    <!DOCTYPE html>
    <head>
        <meta charset="utf-8">
        <title><?= $title ?></title>
        <link rel="stylesheet" href="http://bootswatch.com/darkly/bootstrap.min.css">
    </head>
    
    <?php
}