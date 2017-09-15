;****************************************************************************************************************************************************
;*	HELLO.ASM - Hello World Source Code
;*
;****************************************************************************************************************************************************
;*
;*
;****************************************************************************************************************************************************

;****************************************************************************************************************************************************
;*	Includes
;****************************************************************************************************************************************************
	; system includes
	INCLUDE	"include/Hardware.inc"
	INCLUDE	"include/Shift.inc"

	; project includes
	INCLUDE "data/tileset.asm"
	INCLUDE "data/spriteplayer.asm"
	INCLUDE "const.asm"
	INCLUDE "sprite.asm"
	INCLUDE "game.asm"
	INCLUDE "player.asm"

;****************************************************************************************************************************************************
;*	user data (constants)
;****************************************************************************************************************************************************


;****************************************************************************************************************************************************
;*	equates
;****************************************************************************************************************************************************


;****************************************************************************************************************************************************
;*	cartridge header
;****************************************************************************************************************************************************

	SECTION	"Org $00",HOME[$00]
RST_00:
	jp	$100

	SECTION	"Org $08",HOME[$08]
RST_08:
	jp	$100

	SECTION	"Org $10",HOME[$10]
RST_10:
	jp	$100

	SECTION	"Org $18",HOME[$18]
RST_18:
	jp	$100

	SECTION	"Org $20",HOME[$20]
RST_20:
	jp	$100

	SECTION	"Org $28",HOME[$28]
RST_28:
	jp	$100

	SECTION	"Org $30",HOME[$30]
RST_30:
	jp	$100

	SECTION	"Org $38",HOME[$38]
RST_38:
	jp	$100

	SECTION	"V-Blank IRQ Vector",HOME[$40]
VBL_VECT:
	;call WAIT_VBLANK
	call GAME_DRAW_MAP
	call GAME_DRAW_SPRITES	
	reti

	SECTION	"LCD IRQ Vector",HOME[$48]
LCD_VECT:
	reti

	SECTION	"Timer IRQ Vector",HOME[$50]
TIMER_VECT:
	reti

	SECTION	"Serial IRQ Vector",HOME[$58]
SERIAL_VECT:
	reti

	SECTION	"Joypad IRQ Vector",HOME[$60]
JOYPAD_VECT:
	reti

	SECTION	"Start",HOME[$100]
	nop
	jp	Start

	; $0104-$0133 (Nintendo logo - do _not_ modify the logo data here or the GB will not run the program)
	DB	$CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	DB	$00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	DB	$BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

	; $0134-$013E (Game title - up to 11 upper case ASCII characters; pad with $00)
	DB	"ATDGB"
		;0123456789A

	; $013F-$0142 (Product code - 4 ASCII characters, assigned by Nintendo, just leave blank)
	DB	"    "
		;0123

	; $0143 (Color GameBoy compatibility code)
	DB	$00	; $00 - DMG
			; $80 - DMG/GBC
			; $C0 - GBC Only cartridge

	; $0144 (High-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0145 (Low-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0146 (GameBoy/Super GameBoy indicator)
	DB	$00	; $00 - GameBoy

	; $0147 (Cartridge type - all Color GameBoy cartridges are at least $19)
	DB	$00	; $00 - ROM Only

	; $0148 (ROM size)
	DB	$00	; $00 - 256Kbit = 32Kbyte = 2 banks

	; $0149 (RAM size)
	DB	$00	; $00 - None

	; $014A (Destination code)
	DB	$00	; $01 - All others
			; $00 - Japan

	; $014B (Licensee code - this _must_ be $33)
	DB	$33	; $33 - Check $0144/$0145 for Licensee code.

	; $014C (Mask ROM version - handled by RGBFIX)
	DB	$00

	; $014D (Complement check - handled by RGBFIX)
	DB	$00

	; $014E-$014F (Cartridge checksum - handled by RGBFIX)
	DW	$00


;****************************************************************************************************************************************************
;*	Program Start
;****************************************************************************************************************************************************

	SECTION "Program Start",HOME[$0150]
Start::
	di			;disable interrupts
	ld	sp,$FFFE	;set the stack to $FFFE
	call WAIT_VBLANK	;wait for v-blank

	ld	a,LCDCF_OFF		;
	ldh	[rLCDC],a	;turn off LCD

	call CLEAR_RAM
	call CLEAR_MAP
	call CLEAR_OAM

	;Insérer ici le chargement des élements vidéo
	ld hl,TILESET
	ld bc,13
	call LOAD_TILES	;load up our tiles

	;Chargement du sprite du joueur
	ld hl,SPRITE_PLAYER
	ld bc,14
	ld de,0
	call LOAD_SPRITE

	;Intialisation des données mémoires
	;Passage du compteur d'input à 0
	ld a,0
	ld [_INPUT_COUNTER],a
	;Création du joueur
	ld b,10
	ld c,10
	call PLAYER_INIT

	call DUNGEON_INIT

	call DUNGEON_LOAD_MAP



	ld	a,%11100100	;load a normal palette up 11 10 01 00 - dark->light
	ldh	[rBGP],a	;Chargement de la palette de background
	ld	a,%11100100	;load a normal palette up 11 10 01 00 - dark->light
	ldh	[rOBP0],a	;Chargement de la palette sprite

	;Activation de l'écran et paramétrage de ce dernier
	ld	a,LCDCF_ON | LCDCF_WINOFF | LCDCF_OBJON | LCDCF_BG8000 | LCDCF_BGON
	ldh	[rLCDC],a	;turn on the LCD, BG, etc
	ei

	call GAME_INIT

Loop::
	call GAME_UPDATE
	jp Loop

;***************************************************************
;* Subroutines
;***************************************************************

	SECTION "Support Routines",HOME

IS_VBLANK::
  ldh	a,[rSTAT]
  and %00000011
  cp %01
  jp nz, .is_vblank_no
  ld a,1
  ret
.is_vblank_no
 ld a,0
 ret

WAIT_VBLANK::
	ldh	a,[rSTAT]		;get current scanline
	and %00000011
	cp	%01			;Are we in v-blank yet?
	jr	nz,WAIT_VBLANK	;if A-91 != 0 then loop
	ret				;done

CLEAR_MAP::
	ld	hl,_SCRN0		;loads the address of the bg map ($9800) into HL
	ld	bc,32*32		;since we have 32x32 tiles, we'll need a counter so we can clear all of them
CLEAR_MAP_LOOP::
	ld	[hl],0		;load A into HL, then increment HL (the HL+)
    inc hl
	dec	bc			;decrement our counter
	ld	a,b			;load B into A
	or	c			;if B or C != 0
	jr	nz,CLEAR_MAP_LOOP	;then loop
	ret				;done

CLEAR_OAM::
	ld hl,_OAMRAM
	ld bc,40*4 ;on a 40 fois 4 bytes à effacer
CLEAR_OAM_LOOP::
	ld [hl],0
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,CLEAR_OAM_LOOP
	ret

;Code de débuggage à supprimer
;TODO: a supprimer
CLEAR_RAM::
	ld hl,$C000
.clear_ram_for
	ld [hl],0
	inc hl
	ld a,l
	cp $00
	jp nz,.clear_ram_for
	ld a,h
	cp $E0
	jp nz,.clear_ram_for
	ret

;LOAD_SPRITE
;hl -> adresse des sprites
;bc -> nombre de frame/parties à charger
;de -> index de départ de l'enregistrement mémoire (pour charger des sprites de différents fichiers)
LOAD_SPRITE::
	ld a,h
	ld [_TEMP],a
	ld a,l
	ld [_TEMP+1],a
	sla16 de,4
	ld hl,_SRAM
	add hl,de
	ld d,h
	ld e,l
	ld a,[_TEMP]
	ld h,a
	ld a,[_TEMP+1]
	ld l,a
	sla16 bc,4
LOAD_SPRITE_LOOP::
	ld	a,[hl+]	;get a byte from our tiles, and increment.
	ld	[de],a	;put that byte in VRAM and
	inc	de		;increment.
	dec	bc		;bc=bc-1.
	ld	a,b		;if b or c != 0,
	or	c		;
	jr	nz,LOAD_SPRITE_LOOP	;then loop.
	ret			;done



; LOAD_TILES
; Charge les tuiles graphics dans la mémoire de tuiles
; Paramètres:
; hl -> adresse des tuiles à charger
; bc -> nombre de tuiles à charger
LOAD_TILES::
	ld	de,_VRAM
	sla16 bc,4

LOAD_TILES_LOOP::
	ld	a,[hl+]	;get a byte from our tiles, and increment.
	ld	[de],a	;put that byte in VRAM and
	inc	de		;increment.
	dec	bc		;bc=bc-1.
	ld	a,b		;if b or c != 0,
	or	c		;
	jr	nz,LOAD_TILES_LOOP	;then loop.
	ret			;done

; LOAD_MAP
; Place les tuiles dans la mémoire vidéo à afficher en fonction de la map précisée
; Paramètres:
; hl -> adresse de la map servant de modèle
; c -> nombre de tuiles à charger
LOAD_MAP::
	ld	de,_SCRN0	;where our map goes
LOAD_MAP_LOOP::
	ld	a,[hl+]	;get a byte of the map and inc hl
	ld	[de],a	;put the byte at de
	inc	de		;duh...
	dec	c		;decrement our counter
	jr	nz,LOAD_MAP_LOOP	;and of the counter != 0 then loop
	ret			;done





;*** End Of File ***
