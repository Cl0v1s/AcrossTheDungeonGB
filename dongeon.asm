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
.dungeon_init_create_room

.dungeon_init_create_room_for
;On cherche l'adresse mémoire de la salle actuelle
ld hl,_DUNGEON_DATA-3
ld a,b
sla a
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
;On choisit la destination des portes
call random
or _DUNGEON_MAX_ROOMS
and _DUNGEON_MAX_ROOMS

ld a,b
add 1
cp _DUNGEON_MAX_ROOMS
jp nz,.dungeon_init_create_room_for

.dungeon_init_create_room_done


ret


ENDC
