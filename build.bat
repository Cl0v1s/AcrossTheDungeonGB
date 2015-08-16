@echo off
rm *.gb *.lst *.map
@echo on
lcc -Wa-l -c helper.c gen.c activeroom.c render.c room.c player.c main.c && lcc -Wa-l -Wf-bo3 -c sprites/spriteplayer.s sprites/tileset.s font/font.s && lcc -Wl-yt1 -Wl-yo4 -Wl-m -o main.gb *.o && bgb main.gb
