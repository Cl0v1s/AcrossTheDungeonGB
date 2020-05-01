SECTION "variables", wram0[RAM_START]

TEST db

; Adresses tiles 
PLAYER_SPRITE_TILE EQU $80
BLOB_SPRITE_TILE EQU $8E


; Adresses propres au joueur
PLAYER_INDEX db
PLAYER_DIR db ; 0: bas 1: gauche 2: haut 3: droite 
PLAYER_X db
PLAYER_Y db
PLAYER_STEP db
PLAYER_ATTR db
PLAYER_SPEED equ 15

; Adresse de la map courante
MAP_CURRENT ds 2

;SECTION "variables_1", wram0[$C010]
; Emplacement mémoire de la liste des spritegroups
SPRITEGROUPS_MAX equ 4
SPRITEGROUPS_SIZE equ 1
SPRITEGROUPS_START ds SPRITEGROUPS_MAX*SPRITEGROUPS_SIZE ; on peut avoir jusqu'à 4 groupes de sprites
; 4 byte par groupe
; 0: Adresse OAM haut gauche
; 1: Adresse OAM haut droit
; 2: Adresse OAM bas gauche
; 3: Adresse OAM bas droit

;SECTION "variables_2", wram0[$C020]
; Emplacement mémoire de la liste des entités
ENTITIES_MAX equ 4
ENTITIES_SIZE equ 5
ENTITIES_START ds ENTITIES_MAX*ENTITIES_SIZE ; on peut avoir jusqu'à 4 entités
; 4 byte par entités
; 0: index sprite group
; 1: x
; 2: y
; 3: dir
; 4: step





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

  

  pop hl 
  ret