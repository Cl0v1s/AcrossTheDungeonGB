INCLUDE "include/Hardware.inc"
INCLUDE "const.asm"

        IF      !DEF(PLAYER_ASM)
PLAYER_ASM  SET  1

SECTION "Player",HOME


;PLAYER_INIT
; b-> position x
; c -> position y
PLAYER_INIT::
	;Reglage déplacement
	ld a,0
	ld [_PLAYER_MOVED],a
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
	
;PLAYER_UPDATE
;Met à jour la position du joueur
PLAYER_UPDATE::
	ld a,[_PLAYER_MOVED]
	cp 1
	jp z,PLAYER_UPDATE_CHANGE_SPRITE_POS
	

PLAYER_UPDATE_AFTER_POS_TEST::
		;on continue l'update ici
	
		ret	
PLAYER_UPDATE_CHANGE_SPRITE_POS:: ;On arrive ici si le joueur s'est déplacé
		call WAIT_VBLANK
		;SUP gauche
		ld a,[_PLAYER_POS]
		ld b,a
		ld a,[_PLAYER_POS+1]
		ld c,a
		ld a,0
		call SPRITE_SET_POS
		;SUP droite
		ld a,[_PLAYER_POS]
		add 8
		ld b,a
		ld a,[_PLAYER_POS+1]
		ld c,a
		ld a,1
		call SPRITE_SET_POS
		;INF Gauche
		ld a,[_PLAYER_POS]
		ld b,a
		ld a,[_PLAYER_POS+1]
		add 8
		ld c,a
		ld a,2
		call SPRITE_SET_POS		
		;INF Droite
		ld a,[_PLAYER_POS]
		add 8
		ld b,a
		ld a,[_PLAYER_POS+1]
		add 8
		ld c,a
		ld a,3
		call SPRITE_SET_POS		
		ld a,0
		ld [_PLAYER_MOVED],a
		jp PLAYER_UPDATE_AFTER_POS_TEST
		
		
	
;PLAYER_MOVE
;Déplace le joueur dans la direction donnée
PLAYER_MOVE_RIGHT::
	ld a,[_PLAYER_POS]
	add a,_PLAYER_MOVE_SPEED
	ld [_PLAYER_POS],a
	ld a,1
	ld [_PLAYER_MOVED],a
	ret	
PLAYER_MOVE_LEFT::
	ld a,[_PLAYER_POS]
	sub _PLAYER_MOVE_SPEED
	ld [_PLAYER_POS],a
	ld a,1
	ld [_PLAYER_MOVED],a
	ret	
PLAYER_MOVE_UP::
	ld a,[_PLAYER_POS+1]
	sub _PLAYER_MOVE_SPEED
	ld [_PLAYER_POS+1],a
	ld a,1
	ld [_PLAYER_MOVED],a
	ret	
PLAYER_MOVE_DOWN::
	ld a,[_PLAYER_POS+1]
	add a,_PLAYER_MOVE_SPEED
	ld [_PLAYER_POS+1],a
	ld a,1
	ld [_PLAYER_MOVED],a
	ret	
	
		ENDC
