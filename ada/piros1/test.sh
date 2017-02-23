#!/bin/bash
gnatmake ./sinus.adb
./sinus <<<'-3.14159265359'
./sinus <<<'-1.5708'
./sinus <<<'0'
./sinus <<<'1.5708'
./sinus <<<'3.14159265359'
