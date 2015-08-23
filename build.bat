
@echo off
echo compiling sprites
lcc -Wa-l -Wf-bo3 -c src/data/sprites/spriteblob.s src/data/sprites/spriteplayer.s
echo compiling tilesets
lcc -Wa-l -Wf-bo3 -c src/data/tilesets/tileset.s
echo compiling font
lcc -Wa-l -Wf-bo3 -c src/data/font/font.s
echo compiling logic
lcc -Wa-l -c src/main.c src/helper.c src/room.c
echo linking
lcc -Wl-yt1 -Wl-yo8 -Wl-m -o build/AcrossTheDungeon.gb *.o && start build/bgb build/AcrossTheDungeon.gb
rm *.lst *.o
