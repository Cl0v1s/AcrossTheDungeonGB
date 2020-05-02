npc:
  ; créer le npc 
  ; a: type, indique comment remplir l'entité 
  ; bc: adresse de la routine d'initialisation des valeurs 
  .create: 
    push bc 
    ld hl, NPC_START
    ld b, NPC_SIZE
    ld c, NPC_MAX
    call memory.search_free
    push hl ; adresse du npc entry 

    ld b, BLOB_SPRITE_TILE
    ld c, BLOB_SPRITE_TILE+1
    call entity.create

    pop hl
    ld [hl], a ; Chargement sprite index 
    ; Chargement des attrs 
    inc hl 
    ld [hl], $FF
    inc hl 
    ld [hl], $FF 
    
    ; Chargement de l'adresse de la routine d'interaction
    pop bc 
    inc hl 
    ld a, b
    ldi [hl], a
    ld [hl], c 

    ; retour au début de la séquence npc
    dec hl 
    dec hl 
    dec hl 
    dec hl

    M_memory_address_to_index NPC_START
  ret

  ; déplace directement le npc à la cellule demandée
  ; a: index npc
  ; b: cellule x 
  ; c: cellule y
  .setPosition:
    M_memory_index_to_address NPC_START
    ld a, [hl] ; récupération de l'index entité
    sla b ; on multiplie b par 8 pour avoir position en pixels 
    sla b
    sla b
    sla c ; on multiplie c par 8 pour avoir la position en pixels  
    sla c 
    sla c
    call entity.setPosition
  ret 

  ; Libère la zone mémoire 
  ; a: index npc 
  .free:
    M_memory_index_to_address NPC_START
    ld d, $00
    ld e, $05
    call memory.clear
  ret 