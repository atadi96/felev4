<?php

class User implements JsonSerializable {
    private $m_name;
    private $m_email;
    private $m_pwhash;

    private function __construct($name, $email, $pwhash) {
        $this->m_name = $name;
        $this->m_email = $email;
        $this->m_pwhash = $pwhash;
    }

    public static function fromInput($name, $email, $password) {
        return new User($name, $email, password_hash($password, PASSWORD_DEFAULT));
    }

    public static function fromDatabase($data) {
        return new User($data['name'], $data['email'], $data['pwhash']);
    }

    public function name() {
        return $this->m_name;
    }

    public function email() {
        return $this->m_email;
    }

    public function verify_password($password) {
        return password_verify($password, $this->m_pwhash);
    }

    public function jsonSerialize() {
        return [
            'name' => $this->m_name,
            'email' => $this->m_email,
            'pwhash' => $this->m_pwhash
        ];
    }
}