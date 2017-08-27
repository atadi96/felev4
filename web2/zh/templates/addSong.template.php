<?php include_once('templates/header.template.php');
      header_template('Add song');
 ?>

<div class="container">
    <div class="col-sm-4 col-sm-offset-4">
        <h1>Add a new song</h1>

        <a href="index.php">Home page</a>
        <?php
            $flash = load_from_flash();
            $result = isset($flash['result']) ? $flash['result'] : new Result();
            $data = isset($flash['data']) ? $flash['data'] : [];
            $result->html();
         ?>

        <form action="model/addSong.php" method="post">
            <div class="form-group">
                <label for="<?= Form::SongTitle ?>" class="control-label">Title</label><br />
                <input <?= remember($data, Form::SongTitle) ?> id="<?= Form::SongTitle ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::ArtistName ?>" class="control-label">Artist</label><br />
                <input <?= remember($data, Form::ArtistName) ?> id="<?= Form::ArtistName ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::SongDuration ?>" class="control-label">Length (ms)</label><br />
                <input <?= remember($data, Form::SongDuration) ?> id="<?= Form::SongDuration ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::AlbumTitle ?>" class="control-label">Album title</label><br />
                <input <?= remember($data, Form::AlbumTitle) ?> id="<?= Form::AlbumTitle ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::AlbumYear ?>" class="control-label">Album year</label><br />
                <input <?= remember($data, Form::AlbumYear) ?> id="<?= Form::AlbumYear ?>" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::SongCategory ?>" class="control-label">Genre</label><br />
                <select name="<?= Form::SongCategory ?>" id="<?= Form::SongCategory ?>" class="form-control">
                    <?php 
                        foreach(['Classic', 'Pop', 'Rock', 'Country'] as $category) {
                            echo '<option value="'.$category.'" '.(isset($data[Form::SongCategory]) && $data[Form::SongCategory] == $category ? 'selected="selected"' : '').' >'.$category.'</option>';
                        }
                    ?>
                </select>
            </div>
            <div class="form-group">
                <label for="<?= Form::SongLinks ?>" class="control-label">Links</label><br />
                <input <?= remember($data, Form::SongLinks) ?> id="<?= Form::SongLinks ?>" type="textarea" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="<?= Form::AlbumImageURL ?>" class="control-label">Album cover URL</label><br />
                <input <?= remember($data, Form::AlbumImageURL) ?> id="<?= Form::AlbumImageURL ?>" type="text" class="form-control"><br />
            </div>
            <input type="submit" value="Save" class="btn btn-primary">
        </form>
    </div>
</div>