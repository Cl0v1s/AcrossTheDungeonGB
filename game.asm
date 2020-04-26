include "res/res.asm"


SECTION "rom", rom0[$0]
; $0000 - $003F: RST handlers.
ret
REPT 7
    nop
ENDR
; $0008
ret
REPT 7
    nop
ENDR
; $0010
ret
REPT 7
    nop
ENDR
; $0018
ret
REPT 7
    nop
ENDR
; $0020
ret
REPT 7
    nop
ENDR
; $0028
ret
REPT 7
    nop
ENDR
; $0030
ret
REPT 7
    nop
ENDR
; $0038
ret
REPT 7
    nop
ENDR

; $0040 - $0067: Interrupt handlers.
call draw
REPT 5
    nop
ENDR
; $0048
jp stat
REPT 5
    nop
ENDR
; $0050
jp timer
REPT 5
    nop
ENDR
; $0058
jp serial
REPT 5
    nop
ENDR
; $0060
jp joypad
REPT 5
    nop
ENDR

; $0068 - $00FF: Free space.
DS $98

; $0100 - $0103: Startup handler.
nop
jp main

include "data/header.asm"
include "lib/address.asm"
include "lib/variables.asm"

main:
	di
	ld sp,$FFF4 ;SP=$FFF4
	call lcd.wait_vblank
	call lcd.off
	; reset des variables 
	call variables.init
	; Nettoyage de la VRAM
	ld hl, VRAM_START
	ld de, VRAM_END-VRAM_START
	call memory.clear
	; Nettoyage de la map background 
	ld hl, VRAM_BACKGROUNDMAP_START
	ld de, 32*32
	call memory.clear
	; Nettoyage de la map window 
	ld hl, VRAM_WINDOWMAP_START
	ld de, 32*32
	call memory.clear
	; Chargement de la police en VRAM
	ld hl, VRAM_START+$1000 ; Police en $9000
	ld bc, FONT_DATA
	ld de, FONT_COUNT
	call memory.copy
	; Chargement du tileset en VRAM 
	ld hl, VRAM_START
	ld bc, TILESET_DATA
	ld de, TILESET_COUNT
	call memory.copy
	; Chargement du joueur en VRAM
	ld hl, VRAM_START+PLAYER_SPRITE
	ld bc, PLAYER_DATA
	ld de, PLAYER_COUNT
	call memory.copy


	; Nettoyage OAM
	ld hl, OAM_START
	ld de, 40*4
	call memory.clear

	call player.create

	call lcd.on
	ei 
.loop:
    jr .loop

draw:
	call player.update
	call player.draw
	reti
stat:
timer:
serial:
joypad:
		reti

include "lib/lcd.asm"
include "lib/memory.asm"
include "lib/sprite.asm"
include "lib/input.asm"
include "lib/player.asm"