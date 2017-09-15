INCLUDE "include/Hardware.inc"
INCLUDE "include/Shift.inc"
INCLUDE "const.asm"

IF !DEF(ENTITY_INC)
ENTITY_INC  SET  1

SECTION "ENTITY",HOME

;ENTITY_COORD_TO_CELL
;Convertit la position du joueur en position de cellule de 16*16 (utiles pour gestion des interractions et des collisions)
;Paramètres
; b -> position x
; c -> position y
;Retour
; b -> index x de cellules
; c -> index y de cellules
ENTITY_COORD_TO_CELL::
  ;On ajoute 8 pour n'avoir que le bas du corps et respecter là perspective
  ld a,c
  add 8
  ld c,a
  ;Division par 16 des x
  srl b
  srl b
  srl b
  ;Division par 16 des y
  srl c
  srl c
  srl c
ret

;ENTITY_CAN_WALK
;Retourne si le joueur peut bouger ou non
;Lit directement dans la mémoire vidéo
;Paramètres:
;b -> position x de la case à tester
;c -> position y de la case à tester
;Retour:
;a -> 1 si le joueur peut passer, 2 sinon
ENTITY_CAN_WALK::
  ld hl,_SCRN0
  ;Récupération adresse mémoire verticale
  ld d,c
  ld e,$20
  call Multiply
  add hl,de
  ;Ajout de l'index mémoire vidéo horizontal
  ld d,0
  ld e,b
  add hl,de
  ;test de passage
  ld a,[hl]
  cp 0
  jp z,.entity_can_walk_yes
  ld a,2
  ret
.entity_can_walk_yes
  ld a,1
  ret

ENDC
