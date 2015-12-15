INCLUDE "include/Hardware.inc"
INCLUDE "const.asm"

SECTION "Player",HOME


;PLAYER_INIT
; b-> position x
; c -> position y
PLAYER_INIT::
	;Réglage des points de vie du joueur
	ld a,10
	ld [_PLAYER_LIFE],a
	;Réglage de l'index de frames du joueur
	ld a,0
	ld [_PLAYER_FRAME],a
	;Paramétrage position du joueur
	ld a,b
	ld [_PLAYER_POS],a
	ld a,c
	ld [_PLAYER_POS+1],a
	;Paramétrage sprites
	;SUP gauche
	ld a,0
	ld d,_PLAYER_SPRITE_INDEX
	call SPRITE_CREATE
	;SUP droite
	ld a,b
	add a,8
	ld b,a
	ld d,_PLAYER_SPRITE_INDEX
	ld a,1
	call SPRITE_CREATE
	ld a,1
	ld b,_SINVX
	call SPRITE_SET_META
	;INF Gauche
	ld a,[_PLAYER_POS]
	ld b,a
	ld a,[_PLAYER_POS+1]
	add a,8
	ld c,a
	ld d,_PLAYER_SPRITE_INDEX+1
	ld a,2
	call SPRITE_CREATE
	; INF droit
	ld a,b
	add a,8
	ld b,a
	ld d,_PLAYER_SPRITE_INDEX+1
	ld a,3
	call SPRITE_CREATE
	ld a,3
	ld b,_SINVX
	call SPRITE_SET_META
	
	ret
	
	
