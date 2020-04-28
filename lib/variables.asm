SECTION "variables", wram0[RAM_START]

TEST db

; Adresses tiles 
PLAYER_SPRITE_TILE EQU $80


; Adresses propres au joueur
PLAYER_DIR db ; 0: bas 1: gauche 2: haut 3: droite 
PLAYER_X db
PLAYER_Y db
PLAYER_STEP db
PLAYER_ATTR db
PLAYER_SPEED equ 15

; Adresse de la map courante
MAP_CURRENT ds 2

; Emplacement mémoire de la liste des spritegroups
SPRITEGROUPS_MAX equ 4
SPRITEGROUPS_SIZE equ 4
SPRITEGROUPS_START ds SPRITEGROUPS_MAX*SPRITEGROUPS_SIZE ; on peut avoir jusqu'à 4 groupes de sprites
; 4 byte par groupe
; 0: Adresse OAM haut gauche
; 1: Adresse OAM haut droit
; 2: Adresse OAM bas gauche
; 3: Adresse OAM bas droit

; Emplacement mémoire de la liste des entités
ENTITIES_SIZE db 
ENTITIES_START ds 4*5 ; on peut avoir jusqu'à 4 entités
; 4 byte par entités
; 0: index sprite group
; 1: x
; 2: y
; 3: step
; 4: attributs




SECTION "variables_init", rom0
variables: 
  ; Initialise les variables à 0
.init: 
  push hl

  ld hl, TEST
  ld [hl], 0

  ld hl, MAP_CURRENT
  ld bc, MAP_1_DATA
  ld [hl], b
  inc hl 
  ld [hl], c

  ld hl, SPRITEGROUPS_SIZE
  ld [hl], 0

  ld hl, PLAYER_DIR
  ld [hl], 0

  ld hl, PLAYER_X
  ld [hl], 16

  ld hl, PLAYER_Y
  ld [hl], 16
  

  pop hl 
  ret