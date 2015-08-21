lcc -Wa-l -c helper.c entitiesmanager.c activeroom.c render.c entities/entity.c entities/player.c entities/blob.c main.c dialog.c && lcc -Wa-l -Wf-bo2 -c gen.c room.c && lcc -Wa-l -Wf-bo3 -c sprites/spriteblob.s sprites/spriteplayer.s sprites/tileset.s dialogs/welcome.s && lcc -Wl-yt1 -Wl-yo4 -Wl-m -o main.gb *.o && bgb main.gb
rm *.gb *.lst *.map *.o
