SECTION "variables", wram0[RAM_START]

TEST db

; Adresses propres au jeu
PLAYER_X db
PLAYER_Y db

; Emplacement mémoire de la liste des spritegroups
SPRITEGROUPS_SIZE db
SPRITEGROUPS_START ds 16 ; on peut avoir jusqu'à 4 groupes de spritess



SECTION "variables_init", rom0
variables: 
  ; Initialise les variables à 0
.init: 
  push hl

  ld hl, TEST
  ld [hl], 0

  ld hl, SPRITEGROUPS_SIZE
  ld [hl], 0

  ld hl, PLAYER_X
  ld [hl], 0

  ld hl, PLAYER_Y
  ld [hl], 0
  

  pop hl 
  ret