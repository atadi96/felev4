<?php

class Song implements JsonSerializable {
    private $title;
    private $artist;
    private $year;
    private $album;
    private $duration;
    private $category;
    private $links;
    private $album_url;

    private function __construct($title, $artist, $year, $album, $duration, $category, $links, $album_url) {
        $this->title = $title;
        $this->artist = $artist;
        $this->year = $year;
        $this->album = $album;
        $this->duration = $duration;
        $this->category = $category;
        $this->links = $links;
        $this->album_url = $album_url;
    }

    public static function fromUser($title, $artist, $year, $album, $duration, $category, $links, $album_url) {
        return new Song($title, $artist, $year, $album, $duration, $category, $links, $album_url);
    }

    public static function fromDatabase($data) {
        return new Song($data['title'], $data['artist'], $data['year'], $data['album'], $data['duration'], $data['category'], $data['links'], $data['album_url']);
    }

    public function jsonSerialize() {
        return [
            'title' => $this->title,
            'artist' => $this->artist,
            'year' => $this->year,
            'album' => $this->album,
            'duration' => $this->duration,
            'category' => $this->category,
            'links' => $this->links,
            'album_url' => $this->album_url,
        ];
    }
}