<?php

require_once('etc.php');

allow('POST');

logout();

redirect('index.php?page='.Pages::Welcome);