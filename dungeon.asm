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
ld c,a
cp 5
jp c,.dungeon_init_create_room_for
;On écrit la taille de la salle
ld a,c
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

  ld a,[_PLAYER_ROOM]
  sla a
  sla a
  sla a
  sla a

ret


ENDC
