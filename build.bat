@echo off
rm *.gb *.lst *.map
@echo on
lcc -Wa-l -c helper.c activeroom.c render.c player.c main.c dialog.c && lcc -Wa-l -Wf-bo2 -c gen.c room.c && lcc -Wa-l -Wf-bo3 -c sprites/spriteplayer.s sprites/tileset.s dialogs/welcome.s && lcc -Wl-yt1 -Wl-yo4 -Wl-m -o main.gb *.o && bgb main.gb
