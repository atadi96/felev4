<?php

class GameMap implements JsonSerializable {
    private $m_name;
    private $m_finished;
    private $m_data;
    private $m_difficulty;

    private function __construct($name, $difficulty, $data, $finished = []) {
        $this->m_name = $name;
        $this->m_finished = $finished;
        $this->m_data = $data;
    }

    public static function fromUser($name, $difficulty, $data) {
        return new GameMap($name, $difficulty, $data);
    }

    public static function fromDatabase($name, $difficulty, $data, $finished) {
        return new GameMap($name, $difficulty, $data, $finished);
    }

    public function name() {
        return $this->m_name;
    }

    public function finished($email = null) {
        if($email == null) {
            return $this->m_finished;
        } else {
            return isset($this->m_finished[$email]);
        }
    }

    public function difficulty() {
        return $this->m_difficulty;
    }

    public function data() {
        return $this->m_data;
    }

    public function num_finished() {
        return count($this->m_finished);
    }
}