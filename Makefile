construct:
	rgbasm -o build/game.obj game.asm
	rgblink -m build/game.map -n build/game.sym -o build/game.gb build/game.obj
	rgbfix -p0 -v build/game.gb

run: 
	/Applications/BGB.app/Contents/MacOS/startwine $(shell pwd)/build/game.gb

create-res:
	mkdir res/$(out)
	tools/gb-convert -i -$(mode) $(path) >> res/$(out)/$(out).asm &
	mv $(path) res/$(out)/$(out).png
	