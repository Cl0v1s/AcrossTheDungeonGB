@echo off
rm build/rom.gb
@echo on
rgbasm -o rom.o main.asm && rgblink -o build\rom.gb *.o && rgbfix -v build\rom.gb && build\bgb.exe build\rom.gb
@echo off
rm *.o
