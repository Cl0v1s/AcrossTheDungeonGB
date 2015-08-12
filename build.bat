@echo off
rm *.gb *.lst *.map
@echo on
lcc -Wa-l -c helper.c room.c player.c main.c && lcc -Wl-m -o main.gb *.o && "C:\Program Files (x86)\mednafen\mednafen.exe" main.gb
