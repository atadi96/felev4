
<div class="container">
    <div class="col-sm-4 col-sm-offset-4">
        <h1>Mirror Puzzles</h1>

        <h2>Log in</h2>

        <?php $result = load_from_flash(); if($result !== null) $result->html(); ?>

        <form action="model/login.php" method="post">
            <div class="form-group">
                <label for="email" class="control-label">Email address</label><br />
                <input name="<?= Form::LoginEmail ?>" id="email" type="text" placeholder="example@host.com" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="passwd" class="control-label">Password</label><br />
                <input name="<?= Form::LoginPassword  ?>" id="passwd" type="password" class="form-control"><br />
            </div>
            <input type="submit" value="Log in" class="btn btn-primary">
        </form>
        Don't have an account yet? <a href="index.php?page=<?= Pages::Register ?>">Register here</a>, <br />
        or try out the <a href="demo/index.html">demo!</a>
    </div>
</div>