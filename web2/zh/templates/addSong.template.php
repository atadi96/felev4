<?php include_once('templates/header.template.php');
      header_template('Dal hozzáadása');
 ?>

<div class="container">
    <div class="col-sm-4 col-sm-offset-4">
        <h1>Új dal hozzáadása</h1>

        <?php
            $flash = load_from_flash();
            $result = isset($flash['result']) ? $flash['result'] : new Result();
            $data = isset($flash['data']) ? $flash['data'] : [];
            $result->html();
         ?>

        <form action="model/addSong.php" method="post">
            <div class="form-group">
                <label for="<?= Form::SongTitle ?>" class="control-label">Dal címe</label><br />
                <input <?= remember($data, Form::SongTitle) ?> id="<?= Form::SongTitle ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::ArtistName ?>" class="control-label">Előadó</label><br />
                <input <?= remember($data, Form::ArtistName) ?> id="<?= Form::ArtistName ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::SongDuration ?>" class="control-label">Dal hossza (ms)</label><br />
                <input <?= remember($data, Form::SongDuration) ?> id="<?= Form::SongDuration ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::AlbumTitle ?>" class="control-label">Album címe</label><br />
                <input <?= remember($data, Form::AlbumTitle) ?> id="<?= Form::AlbumTitle ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::AlbumYear ?>" class="control-label">Kiadás éve</label><br />
                <input <?= remember($data, Form::AlbumYear) ?> id="<?= Form::AlbumYear ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::SongCategory ?>" class="control-label">Kategória</label><br />
                <input <?= remember($data, Form::SongCategory) ?> id="<?= Form::SongCategory ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::SongLinks ?>" class="control-label">Linkek</label><br />
                <input <?= remember($data, Form::SongLinks) ?> id="<?= Form::SongLinks ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::AlbumImageURL ?>" class="control-label">Albumborító URL</label><br />
                <input <?= remember($data, Form::AlbumImageURL) ?> id="<?= Form::AlbumImageURL ?>" type="text" class="form-control"><br />
            </div>
            <input type="submit" value="Mentés" class="btn btn-primary">
        </form>
    </div>
</div>