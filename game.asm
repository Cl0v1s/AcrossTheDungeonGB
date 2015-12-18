INCLUDE "const.asm"
INCLUDE "player.asm"
INCLUDE "dungeon.asm"

        IF      !DEF(GAME_ASM)
GAME_ASM  SET  1

SECTION "Game", HOME

;GAME_UPDATE
;Met à jour les données du jeu
GAME_UPDATE::
	ld a,[_INPUT_COUNTER]
	cp 0
	jp nz,GAME_DECREASE_INPUT_COUNTER
	;Controle de la croix directionnelle
	;Gauche
	ld a,[rP1]
	cp _PAD_LEFT
	jp z,GAME_UPDATE_PAD_LEFT
	;Droite
	ld a,[rP1]
	cp _PAD_RIGHT
	jp z,GAME_UPDATE_PAD_RIGHT
	;Up
	ld a,[rP1]
	cp _PAD_UP
	jp z,GAME_UPDATE_PAD_UP
	;Down
	ld a,[rP1]
	cp _PAD_DOWN
	jp z,GAME_UPDATE_PAD_DOWN

	jp GAME_UPDATE_AFTER_PAD

GAME_DECREASE_INPUT_COUNTER::
	ld a,[_INPUT_COUNTER]
	dec a
	ld [_INPUT_COUNTER],a

GAME_UPDATE_AFTER_PAD::
	;Mise à jour du joueur
	call PLAYER_UPDATE

	ret
GAME_UPDATE_PAD_LEFT::
	call PLAYER_MOVE_LEFT
	ld a,20
	ld [_INPUT_COUNTER],a
	jp GAME_UPDATE_AFTER_PAD
GAME_UPDATE_PAD_RIGHT::
	call PLAYER_MOVE_RIGHT
	ld a,20
	ld [_INPUT_COUNTER],a
	jp GAME_UPDATE_AFTER_PAD
GAME_UPDATE_PAD_UP::
	call PLAYER_MOVE_UP
	ld a,20
	ld [_INPUT_COUNTER],a
	jp GAME_UPDATE_AFTER_PAD
GAME_UPDATE_PAD_DOWN::
	call PLAYER_MOVE_DOWN
	ld a,20
	ld [_INPUT_COUNTER],a
	jp GAME_UPDATE_AFTER_PAD

		ENDC
