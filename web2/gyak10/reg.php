<?php

require_once 'functions.php';

allow("GET");

$flash = load_from_flash();
$errors = $flash['errors'];
$messages = $flash['messages'];

require 'header.tpl.php';

?>

<form action="adduser.php" method="post">
    <div>
        <label for="">Felhasználónév</label>
        <input type="text">
    </div>
    <div>
        <label for="">Jelszó</label>
        <input type="password" name="password">
    </div>
    <div>
        <label for="">Jelszó mégegyszer</label>
        <input type="password" name="password2">
    </div>
    <a href="login.php">Bejelentkezés</a>
</form>
    

<?php foreach((array)$errors as $error) : ?>
    <div class="alert alert-danger"><?= $error ?></div>
<?php endforeach; ?>

<?php foreach((array)$messages as $message) : ?>
    <div class="alert alert-success"><?= $message ?></div>
<?php endforeach; ?>