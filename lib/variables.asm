; Emplacement mémoire de la liste des spritegroups
SPRITEGROUPS_SIZE EQU RAM_START
SPRITEGROUPS_START EQU RAM_START+1



variables: 

  ; Initialise les variables à 0
.init: 
  push hl

  ld hl, SPRITEGROUPS_SIZE
  ld [hl], 0

  pop hl 
  ret