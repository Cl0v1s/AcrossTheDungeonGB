npc:
  ; créer le npc 
  ; a: type, indique comment remplir l'entité 
  .create:
    push af 
    ld hl, NPC_START
    ld b, NPC_SIZE
    ld c, NPC_MAX
    call memory.search_free

    pop af ; récupération de la valeur de a 
    push hl ; adresse du npc entry 

    ld b, a
    add 1
    ld c, a
    call entity.create ; a contient l'index de l'entité 

    pop hl
    and $0F ; 
    or %10000000
    ld [hl], a ; Chargement entity index 

    M_memory_address_to_index NPC_START
  ret

  ; Lance la routine de mise à jour de l'entité
  ; a index de l'entité 
  .update:
    M_memory_index_to_address NPC_START
    push hl
    ld de, $0005
    add hl, de ; routine d'update 
    ldi a, [hl]
    ld d, a
    ld a, [hl]
    ld e, a 
    ld h, d
    ld l, e
    pop bc ; bc contient l'ancien hl 
    jp hl
    .update_after:
  ret 

  ; déplace directement le npc à la cellule demandée
  ; a: index npc
  ; b: cellule x 
  ; c: cellule y
  .setPosition:
    M_memory_index_to_address NPC_START
    ld a, [hl] ; récupération de l'index entité
    and $0F
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