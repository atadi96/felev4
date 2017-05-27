<?php

define('BASE_URL', 'http://localhost/web2/felev4/web2/bead2/');

@session_start();

function save_to_file($file, $data) {
    file_put_contents($file, json_encode($data));
}

function remember($input, $name) {
    return ' name="'.$name.'" ' . (isset($input[$name]) ? ' value="'. htmlentities( $input[$name]).'"' : "");
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

function global_redirect($url) {
    header("Location: " . $url);
    exit;
}

function redirect($url) {
    header("Location: ". BASE_URL . $url);
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
        $this->m_messages[] = $message;
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

    public function html() {
        foreach($this->m_errors as $error) {
            echo '<div class="alert alert-danger">'.$error.'</div>';
        }
        foreach($this->m_messages as $message) {
            echo '<div class="alert alert-info">'.$message.'</div>';
        }
        foreach($this->m_warnings as $warning) {
            echo '<div class="alert alert-warning">'.$warning.'</div>';
        }
    }
}

function is_empty($input, $key) {
    return !isset($input[$key]) || empty($input[$key]);
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

function login($user) {
    $_SESSION['logged_in'] = $user;
}

function auth() {
    if(!isset($_SESSION['logged_in'])) {
        return new Result([], [], ["Csak bejelentkezéssel lehet folytatni!"]);
    } else {
        return new Result();
    }
}

function logout() {
    unset($_SESSION['logged_in']);
}

class Pages {
    const Welcome = "welcome";
    const Home = "home";
    const Register = "register";
    const Levels = "levels";
    const Game = "game";
    const Demo = "demo";
}
