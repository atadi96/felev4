
<div class="container">
    <div class="col-sm-4 col-sm-offset-4">
        <h1>Mirror Puzzles</h1>

        <h2>Register</h2>

        <?php $result = load_from_flash(); if($result !== null) $result->html(); ?>

        <form action="model/addUser.php" method="post">
            <div class="form-group">
                <label for="username" class="control-label">Username</label><br />
                <input name="<?= Form::RegisterName ?>" id="username" type="text" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="email" class="control-label">Email address</label><br />
                <input name="<?= Form::RegisterEmail ?>" id="email" type="text" placeholder="example@host.com" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="passwd" class="control-label">Password</label><br />
                <input name="<?= Form::RegisterPassword  ?>" id="passwd" type="password" class="form-control"><br />
            </div>
            <div class="form-group">
                <label for="passwd2" class="control-label">Repeat password</label><br />
                <input name="<?= Form::RegisterPassword2  ?>" id="passwd2" type="password" class="form-control"><br />
            </div>
            <input type="submit" value="Register" class="btn btn-primary">
        </form>
        Don't have an account yet? <a href="index.php?page=<?= Pages::Register ?>">Register here</a>, <br />
        or try out the <a href="demo/index.html">demo!</a>
    </div>
</div>