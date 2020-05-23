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

  ; gère le déplacement du blob 
  ; hl: adresse du blob 
  ; return a: > 0 -> collision /  0 -> Ok
  .move:
  ld a, [hl]
  and $0F
  ld d, a ; sauvegarde a 
  inc hl 
  inc hl 
  ld a, [hl] ; récupération attr 2
  and %00000011 ; récupération des 2 bits inférieurs 

  bit 1, a
  jr z, .move_horizontally
  
  ; .move_vertically:
    bit 0, a 
    jr z, .move_down
    ;.move_up:
      ld a, d
      ld b, 2 
      ld c, 1
      call entity.move
      jp .move_done
    .move_down: 
      ld a, d
      ld b, 0 
      ld c, 1
      call entity.move
      jp .move_done

  .move_horizontally:
    bit 0, a 
    jr z, .move_right
    ;.move_left: 
      ld a, d
      ld b, 1 
      ld c, 1
      call entity.move
    jp .move_done
    .move_right:
      ld a, d
      ld b, 3
      ld c, 1
      call entity.move

  ; jp .move_done
  .move_done:
  ret 

  ; Change la direction du blob 
  ; hl: adresse du blob 
  .change_dir:
  call random.generate
  and %00000011 ; on ne conserve que les 2 derniers bits 
  ld b, a 
  inc hl 
  inc hl 
  ld a, [hl] 
  xor b
  ld [hl], a
  ret 

  ; Met à jour le blob
  ; bc: adresse du npc blob
  .update: 
    ld h, b 
    ld l, c 
    push hl
    call random.generate 
    cp 3
    call c, .change_dir
    pop hl 
    push hl
    call .move
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
    call .change_dir
  ret

  ; Le blob intéragit avec le joueur  
  ; bc: adresse du npc blob 
  .interact_player: 
  call input.listen_actions
  call input.listen_actions ; doit être effectué deux fois pour des raisons de hardware
  bit 0, a 
  jr z, .interact_player_a
  ret 
  .interact_player_a:

  ;ld h, b
  ;ld l, c 
  ;call npc.free
  ld bc, TEST_DATA
	ld de, .interact_player_1
	call dialog.create
  ret

  .interact_player_1: 
  ld bc, TEST1_DATA
	ld de, $00
	call dialog.create

  ret 

  ; Le blob intéragit avec une entité 
  ; hl: adresse du npc blob 
  ; a: index de l'autre entité 
  .interact:
  nop
  ret

