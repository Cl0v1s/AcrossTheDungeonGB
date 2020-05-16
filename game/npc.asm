M_npc_update: macro 
  ld hl, (NPC_START - NPC_SIZE)
  ld de, NPC_SIZE
  ld b, NPC_MAX

  .M_npc_update_loop:
    add hl, de 
    bit 7, [hl]
    jr z, .M_npc_update_loop_next
    push hl 
    push bc 
    push de 
    M_memory_address_to_index NPC_START
    call npc.update 
    pop de 
    pop bc 
    pop hl 
    .M_npc_update_loop_next:
    dec b 
    jr nz, .M_npc_update_loop
endm


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
  
  ; Libère le NPC 
  ; hl: Adresse du npc à libérer
  .free: 
    ; Récupération de l'index de l'entité 
    ld a, [hl]
    and $0F
    push hl 
    M_memory_index_to_address ENTITIES_START
    call entity.free
    pop hl 
    ld de, NPC_SIZE
    call memory.clear ; libération du npc 
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


  ; Retourne l'adresse du npc associé à l'entité passée en paramètre 
  ; b: index de l'entité à rechercher 
  ; hl: Adresse du npc correspondant, $00 si non-trouvé 
  .search_npc_by_entity_id:
    ld hl, (NPC_START - NPC_SIZE)
    ld de, NPC_SIZE
    ld c, NPC_MAX

    .search_npc_by_entity_id_loop:
      add hl, de
      ld a, [hl]
      and $0F
      cp b
      jr z, .search_npc_by_entity_id_loop_done
      dec c
      jr nz, .search_npc_by_entity_id_loop
      
      .search_npc_by_entity_id_loop_no:
      ld hl, $00
      ret 

    .search_npc_by_entity_id_loop_done:
    ; hl contient la bonne adresse 
  ret 