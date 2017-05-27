
<div class="container">
    <div class="col-sm-4 col-sm-offset-4">
        <h1>Fejtörő fényvesztő</h1>

        <h2>Regisztráció</h2>

        <?php $result = load_from_flash(); if($result !== null) $result->html(); ?>

        <form action="model/addUser.php" method="post">
            <div class="form-group">
                <label for="username" class="control-label">Felhasználónév</label><br />
                <input name="<?= Form::RegisterName ?>" id="username" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="email" class="control-label">E-mail cím</label><br />
                <input name="<?= Form::RegisterEmail ?>" id="email" type="text" placeholder="example@host.com" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="passwd2" class="control-label">Jelszó</label><br />
                <input name="<?= Form::RegisterPassword  ?>" id="passwd" type="password" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="passwd" class="control-label">Jelszó</label><br />
                <input name="<?= Form::RegisterPassword2  ?>" id="passwd2" type="password" class="form-control"><br />
            </div>
            <input type="submit" value="Bejelentkezés" class="btn btn-primary">
        </form>
        Nincs fiókod? <a href="index.php?page=<?= Pages::Register ?>">Regisztrálj itt</a>, <br />
        vagy próbáld ki <a href="demo.html">a demót!</a>
    </div>
</div>