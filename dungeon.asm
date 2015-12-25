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
  ld [_TEMP],a
  ld a,d
  and %00001111
  add a
  ld c,a
  ld [_TEMP+1],a
  ;Sauvegarde de l'emplacement mémoire de la lecture
  push hl
  ;Dessin des murs
  call DUNGEON_LOAD_MAP_DRAW_WALLS
  ;Récupération de l'adresse de récupération des murs
  pop hl
  ;Récupération des infos sur les portes
  ld b,[hl]
  inc hl
  ld c,[hl]
  ;Création des variables de compteur et de boucle
  ld d,%00000011
  ld e,0
.dungeon_load_map_door_for
  push bc
  push de
  ;Traitement des infos sur les portes
  ld a,b
  and d
  cp 0 ;Si les infos valent zéro, alors on ne dessine pas la porte
  jp z,.dungeon_load_map_door_next
  ld e,a
  ld a,c
  and d
  ld d,a
  call Multiply
  ld a,e;on ne garde que la fin
  add 2;on ajoute un minimum de 2 qui sera retiré de 1 par le maximum
  ld b,a
  call DUNGEON_LOAD_MAP_DRAW_DOOR
.dungeon_load_map_door_next
  pop de
  pop bc
  inc e
  sla d;décalage du masque
  sla d
  ld a,e
  cp 4
  jp nz,.dungeon_load_map_door_for

ret

; DUNGEON_LOAD_MAP_DRAW_DOOR
; Dessine une porte
; Paramètres
; b-> position de la porte
; e-> index de la porte (0, gauche, 1 haut etc..)
DUNGEON_LOAD_MAP_DRAW_DOOR::
  ;Lecture de l'index et saut en conséquence
  ld a,e
  cp 0
  jp z,.dungeon_load_map_draw_door_left

;Dessin de la porte du mur gauche
.dungeon_load_map_draw_door_left
  ;on rabote la hauteur pour qu'elle ne dépasse pas la taille de la salle
  ld a,[_TEMP+1]
  ld c,a
  ld a,b
  cp c
  jp c,.dungeon_load_map_draw_door_left_jump
  ;Si la position n'est pas inférieur à la taille du mur on le limite
  ld a,c
  sub 2
  ld b,a
.dungeon_load_map_draw_door_left_jump;Sinon
  ld d,b
  ld e,$20
  call Multiply
  ld hl,_SCRN0
  add hl,de
  ld [hl],_CELL_DOOR_V
  ld de,$20
  add hl,de
  ld [hl],_CELL_DOOR_V



ret



DUNGEON_LOAD_MAP_DRAW_WALLS::
  ld hl,_SCRN0
  ld de,$20
  ;Ecriture du mur du haut
  ld c,0
.dungeon_load_map_draw_wall_top
  ;mur du haut
  ld [hl],_CELL_WALL_H_OVER
  push hl
  add hl,de
  ld [hl],_CELL_WALL_H
  pop hl
  inc hl
  inc c
  ld a,c
  cp b
  jp nz,.dungeon_load_map_draw_wall_top
  ;Récupération des valeurs
  ld a,[_TEMP+1]
  ld c,a
  ;calcul du nouveau hl pour le mur du bas
  ld hl,_SCRN0
  ld d,$20
  ld e,c
  call Multiply
  add hl,de
  ;Initialisation des valeurs de dessin
  ld de,$20
  ld c,0
.dungeon_load_map_draw_wall_bot
  ;mur du bas
  ld [hl],_CELL_WALL_H_OVER
  push hl
  add hl,de
  ld [hl],_CELL_WALL_H
  pop hl
  inc hl
  inc c
  ld a,c
  cp b
  jp nz,.dungeon_load_map_draw_wall_bot
  ;Récupération des valeurs
  ld a,[_TEMP+1]
  ld c,a
  ;Dessin des murs verticaux
  ld hl,_SCRN0
  ld de,$20
  ld b,0
.dungeon_load_map_draw_wall_left
  ld [hl],_CELL_WALL_V
  add hl,de
  inc b
  ld a,b
  cp c
  jp nz,.dungeon_load_map_draw_wall_left
  ;Calcul de l'emplacement du mur de droite
  ld hl,_SCRN0
  ld a,[_TEMP]
  add l
  sub 1
  ld l,a
  ;Dessin du mur de droite
  ld b,0
.dungeon_load_map_draw_wall_right
  ld [hl],_CELL_WALL_V
  add hl,de
  inc b
  ld a,b
  cp c
  jp nz,.dungeon_load_map_draw_wall_right
ret


ENDC
