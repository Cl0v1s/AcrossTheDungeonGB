INCLUDE "include/Hardware.inc"
INCLUDE "include/Shift.inc"
INCLUDE "entity.asm"
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
	ld [_PLAYER_ANIMATION],a
  ;Reglage salle courante
  ld [_PLAYER_ROOM],a
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
  ;call PLAYER_DRAW
	ret

;PLAYER_DRAW
;Dessine le joueur
PLAYER_DRAW::
	;Mise à jour du sprite du joueur si il a bougé
	ld a,[_PLAYER_ANIMATION]
	and %10
	cp _PLAYER_MOVED
	jp nz,.player_draw_pos_done
	;Mise à jour des frames du sprite
	;Récupération de l'index de frame
	ld a,[_PLAYER_FRAME]
	ld c,a
  srl c
  srl c
  srl c
  srl c
  ;Remise à zéro des info meta des sprites
  ld b,_SNORM
  ld a,0
  call SPRITE_SET_META
  ld a,1
  call SPRITE_SET_META
  ld a,2
  call SPRITE_SET_META
  ld a,3
  call SPRITE_SET_META
	;Mise à jour en fonction de la direction
	ld a,[_PLAYER_ANIMATION]
	and _PLAYER_DIRECTION
	ld b,a
	cp 4
	jp z,.player_draw_sprite_left
	ld a,b
	cp 1
	jp z,.player_draw_sprite_up
	ld a,b
	cp 5
	jp z,.player_draw_sprite_right
	ld a,b
	cp 0
	jp z,.player_draw_sprite_down
;Gestion des animations vers le bas
.player_draw_sprite_down
	ld a,0
	ld b,_PLAYER_SPRITE_INDEX
	call SPRITE_SET_TILE
  ld a,1
	call SPRITE_SET_TILE
  ld b,_SINVX
  ld a,1
  call SPRITE_SET_META
	ld a,1
	add a,c
	add a,_PLAYER_SPRITE_INDEX
	ld b,a
	ld a,2
	call SPRITE_SET_TILE
	ld a,b
	add 1
	ld b,a
	ld a,3
	call SPRITE_SET_TILE
  ld b,_SINVX
  ld a,3
  call SPRITE_SET_META
	jp .player_draw_pos
;Gestion des animations vers le haut
.player_draw_sprite_up
	ld a,_PLAYER_SPRITE_INDEX
	add $A
	ld b,a
	ld a,0
	call SPRITE_SET_TILE
	ld a,1
	call SPRITE_SET_TILE
  ld b,_SINVX
  ld a,1
  call SPRITE_SET_META
	ld a,$B
	add a,c
	add a,_PLAYER_SPRITE_INDEX
	ld b,a
	ld a,2
	call SPRITE_SET_TILE
	ld a,b
	add 1
	ld b,a
	ld a,3
	call SPRITE_SET_TILE
  ld b,_SINVX
  ld a,3
  call SPRITE_SET_META
	jp .player_draw_pos
;Gestion des animations vers la gauche
.player_draw_sprite_left
  ld a,_PLAYER_SPRITE_INDEX
  add $4
  ld b,a
  ld a,0
  call SPRITE_SET_TILE
  ld a,b
  add 1
  ld b,a
  ld a,1
  call SPRITE_SET_TILE
  ld a,c
  sla a
  add 6
  add _PLAYER_SPRITE_INDEX
  ld b,a
  ld a,2
  call SPRITE_SET_TILE
  ld a,b
  add 1
  ld b,a
  ld a,3
  call SPRITE_SET_TILE
	jp .player_draw_pos
.player_draw_sprite_right
  ld a,_PLAYER_SPRITE_INDEX
  add $4
  ld b,a
  ld a,1
  call SPRITE_SET_TILE
  ld b,_SINVX
  ld a,1
  call SPRITE_SET_META
  ld a,_PLAYER_SPRITE_INDEX
  add $5
  ld b,a
  ld a,0
  call SPRITE_SET_TILE
  ld b,_SINVX
  ld a,0
  call SPRITE_SET_META
  ld b,_SINVX
  ld a,3
  call SPRITE_SET_META
  ld a,c
  sla a
  add $6
  add _PLAYER_SPRITE_INDEX
  ld b,a
  ld a,3
  call SPRITE_SET_TILE
  ld a,b
  add 1
  ld b,a
  ld a,2
  call SPRITE_SET_TILE
  ld b,_SINVX
  ld a,2
  call SPRITE_SET_META
  ;jp .player_draw_pos optionnel étant donné que c'est la suite
.player_draw_pos
	;Changement de position du sprite
  ;Chargement et calcul de la position du sprite
  ldh a,[rSCX]
  ld b,a
  ld a,[_PLAYER_POS]
  sub b
  ld b,a
  ldh a,[rSCY]
  ld c,a
  ld a,[_PLAYER_POS+1]
  sub c
  ld c,a
	;SUP gauche
	ld a,0
	call SPRITE_SET_POS
	;SUP droite
  push bc
  ld a,b
  add 8
  ld b,a
	ld a,1
	call SPRITE_SET_POS
	;INF Gauche
  pop bc
  push bc
  ld a,c
  add 8
  ld c,a
	ld a,2
	call SPRITE_SET_POS
	;INF Droite
  pop bc
  ld a,b
  add 8
  ld b,a
  ld a,c
  add 8
  ld c,a
	ld a,3
	call SPRITE_SET_POS
	;On indique que le déplacement a été effectué
	ld a,[_PLAYER_ANIMATION]
	and %01
	ld [_PLAYER_ANIMATION],a
	;On incrémente le compteur de frame
	ld a,[_PLAYER_FRAME]
	add 6
	and %00011111
	ld [_PLAYER_FRAME],a
.player_draw_pos_done
		ret

;PLAYER_GET_POS
; Retourne la position du joueur dans b et c
; Retour
; b-> position x du joueur
; c->position y du joueur
PLAYER_GET_POS::
  ld a,[_PLAYER_POS]
  ld b,a
  ld a,[_PLAYER_POS+1]
  ld c,a
  ret


PLAYER_MOVE::
  ld a, [_INPUT_LAST]
  cp $CD
	jp z, .player_move_left_step
	cp $CE
	jp z, .player_move_right_step
	cp $CB
	jp z, .player_move_up_step
	cp $C7
	jp z, .player_move_down_step
  ret
.player_move_left_step
  call PLAYER_MOVE_LEFT
  ret
.player_move_right_step
  call PLAYER_MOVE_RIGHT
  ret
.player_move_up_step
  call PLAYER_MOVE_UP
  ret
.player_move_down_step
  call PLAYER_MOVE_DOWN
  ret

;PLAYER_MOVE
;Déplace le joueur dans la direction donnée
PLAYER_MOVE_RIGHT::
  call PLAYER_GET_POS
  ;on ajoute des x pour tester la case à droite
  ld a,b
  add 16+_PLAYER_MOVE_SPEED
  ld b,a
  call ENTITY_COORD_TO_CELL
  call ENTITY_CAN_WALK
  cp 1
  jp nz,player_move_done
	ld a,[_PLAYER_POS]
	add a,_PLAYER_MOVE_SPEED
	ld [_PLAYER_POS],a
	ld a,7 ;Direction à 5
	ld [_PLAYER_ANIMATION],a
	ret
PLAYER_MOVE_LEFT::
  call PLAYER_GET_POS
  ;on retire des x à gauche
  ld a,b
  sub _PLAYER_MOVE_SPEED
  ld b,a
  call ENTITY_COORD_TO_CELL
  call ENTITY_CAN_WALK
  cp 1
  jp nz,player_move_done
	ld a,[_PLAYER_POS]
	sub _PLAYER_MOVE_SPEED
	ld [_PLAYER_POS],a
	ld a,6; direction à 4
	ld [_PLAYER_ANIMATION],a
	ret
PLAYER_MOVE_UP::
  call PLAYER_GET_POS
  ;on retire des y en haut
  ld a,c
  sub _PLAYER_MOVE_SPEED
  ld c,a
  call ENTITY_COORD_TO_CELL
  call ENTITY_CAN_WALK
  cp 1
  jp nz,player_move_done
	ld a,[_PLAYER_POS+1]
	sub _PLAYER_MOVE_SPEED
	ld [_PLAYER_POS+1],a
	ld a,3; direction à 1 or %10, pour gagner une commande
	ld [_PLAYER_ANIMATION],a
	ret
PLAYER_MOVE_DOWN::
  call PLAYER_GET_POS
  ;on retire des y en haut
  ld a,c
  add 8+_PLAYER_MOVE_SPEED
  ld c,a
  call ENTITY_COORD_TO_CELL
  call ENTITY_CAN_WALK
  cp 1
  jp nz,player_move_done
	ld a,[_PLAYER_POS+1]
	add a,_PLAYER_MOVE_SPEED
	ld [_PLAYER_POS+1],a
	ld a,2 ;direction à 0 or %10, histoire de gagner une commande
	ld [_PLAYER_ANIMATION],a
	ret

player_move_done:: ;Sortie commune à tout les player move
  ret



		ENDC
