<?php

require_once('etc.php');
require_once('form.php');

$rules = [
   Form::SongTitle => [
       'filter' => FILTER_DEFAULT,
       'errormsg' => 'A megadott dalcím nem megfelelő formátumú!'
   ], 
   Form::ArtistName => [
       'filter' => FILTER_DEFAULT,
       'errormsg' => 'A megadott előadó név nem megfelelő formátumú!'
   ], 
   Form::SongDuration => [
       'filter' => FILTER_VALIDATE_INT,
       'errormsg' => 'A megadott dalhossz nem megfelelő formátumú!'
   ], 
   Form::AlbumTitle => [
       'filter' => FILTER_DEFAULT,
       'errormsg' => 'A megadott albumcím nem megfelelő formátumú!'
   ], 
   Form::AlbumYear => [
       'filter' => FILTER_VALIDATE_INT,
       'errormsg' => 'A megadott megjelenési év nem megfelelő formátumú!'
   ], 
   Form::SongCategory => [
       'filter' => FILTER_DEFAULT,
       'errormsg' => 'A megadott kategória nem megfelelő formátumú!'
   ], 
   Form::SongLinks => [
       'filter' => FILTER_DEFAULT,
       'errormsg' => 'A megadott link lista nem megfelelő formátumú!'
   ], 
   Form::AlbumImageURL => [
       'filter' => FILTER_VALIDATE_URL,
       'errormsg' => 'A megadott albumborító URL nem megfelelő formátumú!'
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
        save_to_file('../data/songs.json');
        $result->add_message('A dal sikeresen felvéve az adatbázisba!');
    }
}

save_to_flash([
    'result' => $result,
    'data' => ($result->success()? [] : $_POST)
]);
redirect('index.php?page='.($result->success ? Pages::List : Pages::AddSong));