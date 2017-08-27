<?php include_once('model/form.php'); include_once('templates/header.template.php'); header_template('Song list') ?>

<div class="container">
    <div class="col-sm-8 col-sm-offset-2">
        <h1>Songs</h1>

        <?php
            $flash = load_from_flash();
            $result = isset($flash['result']) ? $flash['result'] : new Result();
            $data = isset($flash['data']) ? $flash['data'] : [];
            $result->html();
         ?>
         <form action="index.php?page=list" method="get">
            <input type="hidden" name="page" value="list">
            <div class="form-group">
                <label for="<?= Form::SongCategory ?>" class="control-label">Filter category: </label>
                <select name="<?= Form::SongCategory ?>" id="<?= Form::SongCategory ?>" class="form-control">
                    <option value=""></option>
                    <?php 
                        foreach(['Classic', 'Pop', 'Rock', 'Country'] as $category) {
                            echo '<option value="'.$category.'" '.(isset($_GET[Form::SongCategory]) && $_GET[Form::SongCategory] == $category ? 'selected="selected"' : '').' >'.$category.'</option>';
                        }
                    ?>
                </select>
            <input type="submit" value="Filter" class="btn btn-primary">
            </div>
        </form>
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>Artist</th>
                    <th>Album</th>
                    <th>Title</th>
                </tr>
            </thead>
            <tbody>
                <?php
                    $songs = load_from_file('data/songs.json'); 
                    $category = isset($_GET[Form::SongCategory]) && !empty($_GET[Form::SongCategory]) ? $_GET[Form::SongCategory] : null;
                ?>
                <?php foreach ($songs as $id => $song) : ?>
                    <?php if($category === null || $category == $song['category']) : ?>
                        <tr>
                            <td><?= $song['artist'] ?></td>
                            <td><?= $song['album'] ?></td>
                            <td><a href="index.php?page=<?= Pages::SongDetails ?>&<?= Form::SongID ?>=<?= $id ?>"><?= $song['title'] ?></td>
                        </tr>
                    <?php endif; ?>
                <?php endforeach; ?>
            </tbody>
        </table> 
        <a href="index.php?page=add_song">Add a new song</a>
    </div>
</div>