include "res/res.asm"


SECTION "rom", rom0

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
jp draw
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
include "lib/sprite.asm"

main:

	di
	ld sp,$FFF4 ;SP=$FFF4
	call lcd.wait_vblank
	call lcd.off
	; reset des variables 
	call variables.init
	; Chargement de la police en VRAM
	ld hl, VRAM_START+16
	ld bc, FONT_DATA
	ld de, FONT_COUNT
	call memory.copy
	; Chargement du joueur en VRAM
	ld hl, VRAM_START+FONT_COUNT+8
	ld bc, PLAYER_DATA
	ld de, PLAYER_COUNT
	call memory.copy
	; Nettoyage de la map background 
	ld hl, VRAM_BACKGROUNDMAP_START
	ld de, 32*32
	call memory.clear
	; Nettoyage de la map window 
	ld hl, VRAM_WINDOWMAP_START
	ld de, 32*32
	call memory.clear
	; Nettoyage OAM
	ld hl, OAM_START
	ld de, 40*4
	call memory.clear

	ld b, $2B
	ld c, $2B
	ld d, $2C
	ld e, $2C
	call sprite.create_group

	ld hl, SPRITEGROUPS_START
	ld b, 16
	ld c, 32
	call sprite.move_group

	call lcd.on
.loop:
		halt
    jr .loop

draw:
stat:
timer:
serial:
joypad:
		reti

include "lib/lcd.asm"
include "lib/memory.asm"

.failure: 
	nop