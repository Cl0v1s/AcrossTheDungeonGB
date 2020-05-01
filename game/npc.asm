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


    M_memory_address_to_index NPC_START

  ret