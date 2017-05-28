
<?php

require_once('model/mapEnumerator.php');
$maps = new MapEnumerator();

?>

<div class="container">
    <div class="col-sm-8 col-sm-offset-2">
        <h2>Játszható pályák</h2>
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>Név</th>
                    <th>Nehézség</th>
                    <th>Teljesítve</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($maps as $map) : ?>
                <tr>
                    <td><a href="index.php?page=game&<?= Form::MapName ?>=<?= $map->name() ?>"><?= $map->name() ?></td>
                    <td><?= $map->difficulty() ?></td>
                    <td><?= $map->finished(current_user()['email']) ? "✔" : '✖' ?></td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table> 
    </div>
</div>