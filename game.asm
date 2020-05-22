include "res/res.asm"
include "data/maps/maps.asm"


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

include "lib/lcd.asm"
include "lib/memory.asm"
include "lib/sprite.asm"
include "lib/input.asm"
include "lib/entity.asm"
include "lib/player.asm"
include "lib/npc.asm"
include "lib/dialog.asm"

include "game/npc_blob.asm"

main:
	di
	ld sp,$FFF4 ;SP=$FFF4
	call lcd.wait_vblank
	call lcd.off
	; Nettoyage RAM 
	ld hl, RAM_START
	ld de, 1024
	call memory.clear
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
	; Nettoyage OAM
	ld hl, OAM_START
	ld de, 40*4
	call memory.clear
	; Chargement de la police en VRAM
	ld hl, VRAM_START+$500 ; Police en $9000
	ld bc, FONT_DATA
	ld de, FONT_COUNT
	call memory.copy
	; Chargement du tileset en VRAM 
	ld hl, VRAM_START
	ld bc, TILESET_DATA
	ld de, TILESET_COUNT
	call memory.copy

	; Chargement du joueur en VRAM
	ld hl, VRAM_START+(PLAYER_SPRITE_TILE<<4)
	ld bc, PLAYER_DATA
	ld de, PLAYER_COUNT
	call memory.copy
	; chargement du blob en VRAM 
	ld hl, VRAM_START+(BLOB_SPRITE_TILE<<4)
	ld bc, BLOB_DATA
	ld de, BLOB_COUNT
	call memory.copy

	; Chargement de la map de test
	ld hl, MAP_CURRENT
	ldi a, [hl]
	ld b, a 
	ld a, [hl]
	ld c, a
	ld hl, VRAM_BACKGROUNDMAP_START
	; ld bc, bc
	ld de, 32*32
	call memory.copy

	; Création du joueur 
	call player.create

	

	call npc_blob.create
	ld b, 5
	ld c, 5
	call npc.setPosition

	call lcd.on

	ei 
.loop:
	halt 
	call dialog.update 
	cp 1
	jr z, .loop_done ; si un dialogue est en cours, on ne mets pas à jour le reste du jeu

	call player.update
	M_npc_update 
	

	.loop_done:
    jr .loop

draw:
	call dialog.draw
	cp 1 
	jr z, .draw_done

	ld a, [DRAW_STEP]
	add 1 
	ld [DRAW_STEP], a
	bit 0, a
	jr z, .draw_entity
	
	call player.draw
	jp .draw_done	
	.draw_entity
		M_entity_draw
	.draw_done
	reti
stat:
timer:
serial:
joypad:
		reti

