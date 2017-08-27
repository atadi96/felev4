<?php

require_once('etc.php');
require_once('form.php');
require_once('song.php');

$rules = [
   Form::SongTitle => [
       'filter' => FILTER_DEFAULT,
       'errormsg' => 'Invalid title format!'
   ], 
   Form::ArtistName => [
       'filter' => FILTER_DEFAULT,
       'errormsg' => 'Invalid artist format!'
   ], 
   Form::SongDuration => [
       'filter' => FILTER_VALIDATE_INT,
       'errormsg' => 'Invalid length format!',
       'default' => 0
   ], 
   Form::AlbumTitle => [
       'filter' => FILTER_DEFAULT,
       'errormsg' => 'Invalid album title format!',
       'default' => ''
   ], 
   Form::AlbumYear => [
       'filter' => FILTER_VALIDATE_INT,
       'errormsg' => 'Invalid album year format!'
   ], 
   Form::SongCategory => [
       'filter' => FILTER_DEFAULT,
       'errormsg' => 'Invalid category format!'
   ], 
   Form::SongLinks => [
       'filter' => FILTER_DEFAULT,
       'errormsg' => 'Invalid link list format!',
       'default' => ''
   ], 
   Form::AlbumImageURL => [
       'filter' => FILTER_VALIDATE_URL,
       'default' => '',
       'errormsg' => 'Invalid cover URL format!'
   ], 
];

$data;

$result = validate($_POST, $rules, $data);

if($result->success()) {
    if($data[Form::AlbumYear] >= 1000 && $data[Form::AlbumYear] <= 9999) {
        $new_song = Song::fromUser(
            $data[Form::SongTitle],
            $data[Form::ArtistName],
            $data[Form::AlbumYear],
            $data[Form::AlbumTitle],
            $data[Form::SongDuration],
            $data[Form::SongCategory],
            $data[Form::SongLinks],
            $data[Form::AlbumImageURL]
        );
        $songs = load_from_file('../data/songs.json');
        $songs[time()] = $new_song;
        save_to_file('../data/songs.json', $songs);
        $result->add_message('Song successfully added to the database!');
    }
}

save_to_flash([
    'result' => $result,
    'data' => ($result->success()? [] : $_POST)
]);
redirect('index.php?page='.($result->success ? Pages::List : Pages::AddSong));