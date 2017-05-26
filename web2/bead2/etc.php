<?php

@session_start();

function save_to_file($file, $data) {
    file_put_contents($file, json_encode($data));
}

function load_from_file($file) {
    return json_decode(file_get_contents($file), true);
}

function not_empty($array, $key) {
    return isset($array[$key]) && !empty($array[$key]);
}

function allow($method) {
    if($_SERVER['REQUEST_METHOD'] != $method) {
        die('Bad Request!');    
    }
}

function redirect($url) {
    header("Location: " . $url);
    exit;
}

function save_to_flash($data) {
    $_SESSION['_flash'] = $data;
}

function load_from_flash() {
    if(isset($_SESSION['_flash'])) {
        $data = $_SESSION['_flash'];
        unset($_SESSION['_flash']);
        return $data;
    } else {
        return null;
    }
}

class Result {
    private $m_messages;
    private $m_warnings;
    private $m_errors;

    public function __construct($messages = [], $warnings = [], $errors = []) {
        $this->m_messages = $messages;
        $this->m_warnings = $warnings;
        $this->m_errors = $errors;
    }

    public function messages() {
        return $this->m_messages;
    }

    public function warnings() {
        return $this->m_warnings;
    }

    public function errors() {
        return $this->m_errors;
    }

    public function success() {
        return empty($this->m_errors);
    }

    public function add_message($message) {
        $this->m_messages[] = $messages;
        return $this;
    }

    public function add_warning($warning) {
        $this->m_warnings[] = $warning;
        return $this;
    }

    public function add_error($error) {
        $this->m_errors[] = $error;
        return $this;
    }

    public function concat(Result $other) {
        $result = new Result();
        $result->m_messages = array_merge($this->m_messages, $other->m_messages);
        $result->m_warnings = array_merge($this->m_warnings, $other->m_warnings);
        $result->m_errors = array_merge($this->m_errors, $other->m_errors);
        return $result;
    }
}

function validate($input, $rules, &$data, &$result = null) {
    if($result == null) {
        $result = new Result();
    }
    
    $filtered_inputs = filter_var_array($input, $rules);
    
    foreach ($filtered_inputs as $key => $value) {
        $data[$key] = null;
        if (is_null($value) || is_empty($input, $key)) {
            if (isset($rules[$key]['default'])) {
                $data[$key] = $rules[$key]['default'];
            } else {
                $result->add_error("{$key} hiányzik");
            }
        } else if ($value === false) {
            $result->add_error($rules[$key]['errormsg']);
        } else {
            $data[$key] = $value;
        }
    }
    
    return $result;
}

function auth() {
    if(!isset($_SESSION['logged_in'])) {
        return new Result([], [], ["Csak bejelentkezéssel lehet folytatni!"]);
    }

}
