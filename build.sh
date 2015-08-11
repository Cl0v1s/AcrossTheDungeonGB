#!/bin/sh

rm *.gb *.lst *.map
../../../bin/lcc -Wa-l -c main.c room.c player.c
../../../bin/lcc -Wl-m -o main.gb *.o
