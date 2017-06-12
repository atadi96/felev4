
<div class="container">
    <div class="col-sm-4 col-sm-offset-4">
        <h1>Fejtörő fényvesztő</h1>

        <h2>Bejelentkezés</h2>

        <?php $result = load_from_flash(); if($result !== null) $result->html(); ?>

        <form action="model/login.php" method="post">
            <div class="form-group">
                <label for="email" class="control-label">E-mail cím</label><br />
                <input name="<?= Form::LoginEmail ?>" id="email" type="text" placeholder="example@host.com" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="passwd" class="control-label">Jelszó</label><br />
                <input name="<?= Form::LoginPassword  ?>" id="passwd" type="password" class="form-control"><br />
            </div>
            <input type="submit" value="Bejelentkezés" class="btn btn-primary">
        </form>
        Nincs fiókod? <a href="index.php?page=<?= Pages::Register ?>">Regisztrálj itt</a>, <br />
        vagy próbáld ki <a href="demo/index.html">a demót!</a>
    </div>
</div>