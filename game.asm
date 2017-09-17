INCLUDE "const.asm"
INCLUDE "player.asm"
INCLUDE "dungeon.asm"

        IF      !DEF(GAME_ASM)
GAME_ASM  SET  1

SECTION "Game", HOME

;GAME_INIT
;Initialise le jeu
GAME_INIT::
	ld a, IEF_VBLANK|IEF_HILO
	ldh [rIE],a 
	ret

;GAME_UPDATE
;Met à jour les données du jeu
GAME_UPDATE::
	call GAME_INPUT
	ret


;GAME_INPUT
;Gère les entrées de jeu
GAME_INPUT::
	ld a,[_INPUT_COUNTER]
	cp 0
	jp nz,.game_update_decrease_input_counter
	;Controle de la croix directionnelle
	;Gauche
	ld a,[rP1]
	cp _PAD_LEFT
	jp z,.game_update_pad_left
	;Droite
	ld a,[rP1]
	cp _PAD_RIGHT
	jp z,.game_update_pad_right
	;Up
	ld a,[rP1]
	cp _PAD_UP
	jp z,.game_update_pad_up
	;Down
	ld a,[rP1]
	cp _PAD_DOWN
	jp z,.game_update_pad_down
	jp .game_update_after_pad
.game_update_decrease_input_counter
	ld a,[_INPUT_COUNTER]
	dec a
	ld [_INPUT_COUNTER],a
.game_update_after_pad
	;call GAME_DRAW
	ret
.game_update_pad_left
	call PLAYER_MOVE_LEFT
	ld a,70
	ld [_INPUT_COUNTER],a
	jp .game_update_after_pad
.game_update_pad_right
	call PLAYER_MOVE_RIGHT
	ld a,70
	ld [_INPUT_COUNTER],a
	jp .game_update_after_pad
.game_update_pad_up
	call PLAYER_MOVE_UP
	ld a,70
	ld [_INPUT_COUNTER],a
	jp .game_update_after_pad
.game_update_pad_down
	call PLAYER_MOVE_DOWN
	ld a,70
	ld [_INPUT_COUNTER],a
	jp .game_update_after_pad
	ret


GAME_DRAW_MAP::

  ;call IS_VBLANK
  ;cp 1
  ;jp nz, .game_draw_done
  ld a,[_PLAYER_POS]
  sub 72
  ldh [rSCX],a
  ld a,[_PLAYER_POS+1]
  sub 64
  ldh [rSCY],a
.game_draw_done
  ret

GAME_DRAW_SPRITES::
	; on regarde si la OAM est busy
	ldh	a,[rSTAT]
	and STATF_OAM
	cp STATF_OAM
	;jp nz, .game_draw_sprites_done

	call PLAYER_DRAW
.game_draw_sprites_done
	ret

ENDC

