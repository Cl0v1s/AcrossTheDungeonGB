npc_blob:
  ; Initialise le blob 
  .create: 
    ld a, BLOB_SPRITE_TILE
    call npc.create ; hl contient l'adresse de l'entité nouvellement crée ; a contient son index 
    push af 

    inc hl ; selection attr 1 
    ld [hl], $00
    inc hl ; selection attr 2 
    ld [hl], $00


    inc hl ; selection de l'emplacement de routine d'interaction
    ld [hl], (npc_blob.interact_player >> 8)
    inc hl 
    ld [hl], (npc_blob.interact_player & $00FF) ; overflow prévu

    inc hl ; selection de l'emplacement de la routine d'update 
    ld [hl], (npc_blob.update >> 8)
    inc hl 
    ld [hl], (npc_blob.update & $00FF) ; overflow prévu 

    pop af ; récupération de l'index du npc 
    ret

  ; Met à jour le blob
  ; bc: adresse du npc blob
  .update: 
    ld h, b 
    ld l, c 
    push hl 
    ld a, [hl] 
    and $0F ; a index de l'entité 
    ld b, 0
    ld c, 1
    call entity.move 
    pop hl 
    cp 0 
    jr z, .update_end
    ld b, a 
    and $F0  
    cp $F0
    jr z, .update_col_entity

    ld a, b
    cp 1 
    jr z, .bump ; si collision avec le terrain on bump
    cp 2
    call z, .interact_player ; si collision avec le joueur on interagit 
    jp .update_end

    .update_col_entity: 
      ld a, b
      xor $FF ; récupération de l'index de l'entité problématique 
      call .interact ; interaction avec entité 

    .update_end:
      jp npc.update_after ; on retourne au code appelant 

  .bump: 
  nop 
  ret

  ; Le blob intéragit avec le joueur  
  ; bc: adresse du npc blob 
  .interact_player: 
  ld h, b
  ld l, c 
  call npc.free
  ret

  ; Le blob intéragit avec une entité 
  ; hl: adresse du npc blob 
  ; a: index de l'autre entité 
  .interact:
  nop
  ret

