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
ENTITIES_SIZE equ 6
ENTITIES_START ds ENTITIES_MAX*ENTITIES_SIZE ; on peut avoir jusqu'à 4 entités
; 4 byte par entités
; 1: index sprite group / status -> ab00 xxxx / x = index a = existe b = to_update
; 2: x
; 3: y
; 4: dir
; 5: step
; 5: tile

NPC_MAX equ 4
NPC_SIZE equ 7
NPC_START ds NPC_MAX*NPC_SIZE
; 5 bytes par npc 
; 0: Index entity 
; 1: attr 1
; 2: attr 2
; 3: int addr 1
; 4: int addr 2
; 5: update addr 1
; 6: update addr 2

; Index du prochain caractère à afficher 
DIALOG_TEXT_TILE_START equ $50
DIALOG_CONTENT_SIZE equ 24
DIALOG_NEXT_ADDR ds 2
DIALOG_INDEX db
DIALOG_CONTENT ds DIALOG_CONTENT_SIZE





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

  ld hl, DIALOG_INDEX
  ld [hl], $FF

  

  pop hl 
  ret