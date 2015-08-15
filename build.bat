@echo off
rm *.gb *.lst *.map
@echo on
lcc -Wa-l -c helper.c gen.c activeroom.c sprites/spriteplayer.c sprites/tileset.c font/font.c render.c room.c player.c main.c && lcc -Wl-m -o main.gb *.o && bgb main.gb
