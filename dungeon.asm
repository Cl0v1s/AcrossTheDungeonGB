INCLUDE "include/Hardware.inc"
INCLUDE "include/Random.inc"
INCLUDE "const.asm"

IF !DEF(DUNGEON_ASM)
DUNGEON_ASM  SET  1

SECTION "Dungeon",HOME

;DUNGEON_INIT
;Génere un donjon aléatoirement
DUNGEON_INIT::
ld b,0; définition du compteur de salle
.dungeon_init_create_room_for
;On cherche l'adresse mémoire de la salle actuelle
ld hl,_DUNGEON_DATA
ld a,b
sla a
sla a
sla a
add a,l
ld l,a
;Trouver nombre aléatoire supérieur ou égal à 5
;Boucle tant que
call random
or %01010101
ld [hl],a
inc hl
;On écrit les infos sur les portes
call random
ld [hl],a
inc hl
;On écrit la position des portes
call random
ld [hl],a
inc hl
;On choisit la destination des portes (on boucle une deuxieme fois pour économie d'instructions)
ld d,0
.dungeon_init_create_room_for_door_dest
call random
and %00000111
ld c,a
sla c
sla c
sla c
sla c
call random
and %00000111
or c
ld [hl],a
inc hl
inc d
ld a,d
cp 2
jp nz,.dungeon_init_create_room_for_door_dest
inc b
ld a,b
cp _DUNGEON_MAX_ROOMS
jp nz,.dungeon_init_create_room_for
ret

;DUNGEON_LOAD_MAP
;Lit la map de la salle courante, la traite et la place dans la mémoire vidéo
;Nécessite de couper l'affichage
DUNGEON_LOAD_MAP::
  ;Récupération de l'adresse de la salle actuelle
  ld hl,_DUNGEON_DATA
  ld a,[_PLAYER_ROOM]
  sla a
  sla a
  sla a
  add l
  ;Récupération de la largeur et de la hauteur de la salle
  ld a,[hl]
  ld d,a
  and %11110000
  srl a
  srl a
  srl a
  srl a
  add a
  ld b,a
  ld a,d
  and %00001111
  add a
  ld c,a
  ;Ecriture de la mémoire video en conséquence
  push hl
  ld hl,_SCRN0+$20
  ;Ecriture du mur du haut
  ld d,0
.dungeon_load_map_draw_wall_top
  ;mur du haut
  ld [hl],_CELL_WALL_TOP
  inc hl
  inc d
  ld a,d
  cp b
  jp nz,.dungeon_load_map_draw_wall_top
;calcul du nouveau hl pour le mur du bas
  ld hl,_SCRN0+$20
  push hl
  ld d,$20
  ld e,c
  call Multiply
  ld a,h
  ld [$C100],a
  ld a,l
  ld [$C101],a
  ld d,h
  ld e,l
  pop hl
  add hl,de

.dungeon_load_map_draw_wall_bot
  ;mur du bas
  ld [hl],_CELL_WALL_TOP
  inc hl
  inc d
  ld a,d
  cp b
  jp nz,.dungeon_load_map_draw_wall_bot


  pop hl

ret


ENDC
