<?php

require_once 'functions.php';

allow("GET");

$expenses = load_from_file('data.json');

$flash = load_from_flash();
$errors = $flash['errors'];
$messages = $flash['messages'];

require 'header.tpl.php';

?>

<form action="logout.php" method="post">
    <input type="submit" value="Kijelentkezés">
</form>  

<div class="container">
    <div class="col-sm-6 col-sm-offset-3">
        <h1>Májmáni</h1>
        <form method="post" action="addentry.php">
            <div class="form-group">
                <label class="control-label">Leírás</label>
                <input type="text" name="desc" class="form-control">
            </div>
            <div class="form-group">
                <label class="control-label">Bevétel/Kiadás</label>
                <div class="input-group col-sm-6">
                    <input type="text" name="amount" class="form-control">
                    <span class="input-group-addon">HUF</span>
                </div>
            </div>
            <input type="submit" class="btn btn-primary" value="Rögzít">
        </form>

        <?php foreach((array)$errors as $error) : ?>
            <div class="alert alert-danger"><?= $error ?></div>
        <?php endforeach; ?>

        <?php foreach((array)$messages as $message) : ?>
            <div class="alert alert-success"><?= $message ?></div>
        <?php endforeach; ?>

        <table class="table table-striped table-hover ">
            <thead>
                <tr>
                <th>#</th>
                <th>Leírás</th>
                <th>Összeg</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach((array)$expenses as $key => $row) : ?>
                <tr>
                    <td><?= ($key + 1) ?></td>
                    <td><?= $row['desc'] ?></td>
                    <td class="<?= ($row['amount'] >= 1 ? "text-success" : "text-danger") ?>"><?= $row['amount'] ?> Ft</td>
                    <td>
                        <form method="post" action="delentry.php">
                            <input type="hidden" name="delkey" value="<?= $key ?>">
                            <input type="submit" value="Törlés" class="btn btn-xs btn-danger">
                        </form>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table> 
    </div>
</div>