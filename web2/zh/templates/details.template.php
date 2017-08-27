<?php

include_once('model/form.php');
include_once('templates/header.template.php');

$flash = load_from_flash();
$result = isset($flash['result']) ? $flash['result'] : new Result();
$data = isset($flash['data']) ? $flash['data'] : [];

$songs = load_from_file('data/songs.json');
$song;

if(isset($songs[$_GET[Form::SongID]])) {
    $song = $songs[$_GET[Form::SongID]];
} else {
    $result->add_error('The requested song could not be founf in the database!');
}


header_template($result->success() ? $song['title'] . ' - Details' : 'Error!') ?>

<div class="container">
    <div class="col-sm-8 col-sm-offset-2">
        <?php
            if($result->success()) :
         ?>
         
            <h1><?= $song['title'] ?> - Details</h1>
            <?php $result->html(); ?>
            <div>
            <img src="<?= $song['album_url'] ?>" style="width: 200px; height: 200px;">
            <table class="table table-striped table-hover" style="float: right;">
                <?php
                    $details = [
                        [   'name' => 'Artist'
                        ,   'index' => 'artist'
                        ],
                        [   'name' => 'Album'
                        ,   'index' => 'album'
                        ],
                        [   'name' => 'Title'
                        ,   'index' => 'title'
                        ],
                        [   'name' => 'Year'
                        ,   'index' => 'year'
                        ],
                        [   'name' => 'Length'
                        ,   'index' => 'duration'
                        ],
                        [   'name' => 'Category'
                        ,   'index' => 'category'
                        ],
                    ];
                    foreach($details as $detail) {
                        echo '<tr><td>'.$detail['name'].'</td><td>'.$song[$detail['index']].'</td></tr>';
                    }
                    $links = explode('\n', $song['links']);
                    foreach($links as $link) {
                        $delimiter_pos = strpos($link, ':');
                        $link_name = substr($link, 0, $delimiter_pos);
                        $link_url = substr($link, $delimiter_pos + 1);
                        echo '<tr><td>'.$link_name.'</td><td><a target="_blank" href="'.$link_url.'">'.$link_url.'</a></td></tr>';
                    }
                ?>
            </table> 
            </div>
            <a href="index.php">Home page</a>
        <?php endif; $result->html();?>
    </div>
</div>