#!/bin/bash
compiler=$1
testdir=$2

function run {
    for filename in "$2"/*; do
        echo "$filename"
        eval "$1 $filename > /dev/null"
        echo $?
    done
}

echo -e "-- Correct files --\n\n"
run $compiler $testdir"correct"
echo -e "\n\n-- Lexical error files --\n\n"
run $compiler $testdir"lexical-error"
echo -e "\n\n-- Syntax error files --\n\n"
run $compiler $testdir"syntactic-error"
echo -e "\n\n-- Semantic error files --\n\n"
run $compiler $testdir"semantic-error"
