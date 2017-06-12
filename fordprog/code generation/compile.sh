#!/bin/bash

echo "Compiling to assembly..." &&
eval "./while $1 > $1.asm" &&
echo "Assembling..." &&
eval "nasm -f elf32 $1.asm -o$1.asm.obj" &&
echo "Linking..." &&
eval "gcc io.c $1.asm.obj -oa" &&
eval "chmod u+x a" &&
echo "Removing temporary files..." &&
eval "rm $1.asm.obj" &&
echo "Compiling $1 done!"
