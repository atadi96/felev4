<?php

@include_once('etc.php');
@include_once('gameMap.php');
@include_once('../model/etc.php');
@include_once('../model/gameMap.php');
@include_once('model/etc.php');
@include_once('model/gameMap.php');

class MapEnumerator implements Iterator {

    private $map_iterator;
    private $index;

    public function __construct() {
        $this->map_iterator = (new ArrayObject(load_from_file('data/games.json')))->getIterator();
    }

    public function current (  ) {
        return GameMap::fromDatabase($this->map_iterator->current());
    }
    public function key () {
        return $this->map_iterator->key();
    }
    public function next () {
        $this->map_iterator->next();
    }
    public function rewind () {
        $this->map_iterator->rewind();
    }
    public function valid () {
        return $this->map_iterator->valid();
    }
}