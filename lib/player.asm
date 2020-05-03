player: 

  ; créer l'ensemble sprite du joueur 
  .create:
    ld hl, PLAYER_X
    ld [hl], 30
    ld hl, PLAYER_Y
    ld [hl], 16

    ld b, PLAYER_SPRITE_TILE
    ld c, PLAYER_SPRITE_TILE+1
    ld d, c
    ld e, c
    ld c, b
    ; ld b, b
    call sprite.create_group
    ld [PLAYER_INDEX], a

    ; centrage à l'écran
    ld b, 16+160/2-16
    ld c, 8+168/2-16

    M_memory_index_to_address SPRITEGROUPS_START
    call sprite.move_group
  ret


  
  .input: 
    call input.listen_directions
    bit 3, a ; on test si le bit 3 vaut 0 -> la touche bas est pressé
    jr nz, .nod

    ld a, [PLAYER_X]
    ld b, a
    ld a, [PLAYER_Y]
    add 1
    ld c, a
    call entity.can_walk
    cp 0
    jr nz, .input_end

    call .move_down
    jp .input_end
    .nod:
      bit 2, a ; on test si le bit 2 vaut 0 -> la touche haut est pressé
      jr nz, .nou

      ld a, [PLAYER_X]
      ld b, a
      ld a, [PLAYER_Y]
      sub 1
      ld c, a
      call entity.can_walk
      cp 0
      jr nz, .input_end

      call .move_up
      jp .input_end
    .nou:
      bit 1, a ; on test si le bit 1 vaut 0 -> la touche gauche est pressé
      jr nz, .nol

      ld a, [PLAYER_X]
      sub 1
      ld b, a
      ld a, [PLAYER_Y]
      ld c, a
      call entity.can_walk
      cp 0
      jr nz, .input_end



      call .move_left
      jp .input_end
    .nol:
      bit 0, a ; on test si le bit 0 vaut 0 -> la touche droite est pressé
      jr nz, .input_end

      ld a, [PLAYER_X]
      add 1
      ld b, a
      ld a, [PLAYER_Y]
      ld c, a
      call entity.can_walk
      cp 0
      jr nz, .input_end

      call .move_right
    .input_end:
    ret

  ; Met à jour le joueur
  .update:
    call .input
  ret

  .move_down:
    ld a, [PLAYER_Y]
    add 1
    ld [PLAYER_Y], a

    ld a, [PLAYER_STEP]
    add PLAYER_SPEED
    ld [PLAYER_STEP], a

    xor a 
    ld [PLAYER_DIR], a

    ret

  .move_up:
    ld a, [PLAYER_Y]
    sub 1
    ld [PLAYER_Y], a

    ld a, [PLAYER_STEP]
    add PLAYER_SPEED
    ld [PLAYER_STEP], a

    ld a, 2
    ld [PLAYER_DIR], a

    ret

  .move_right:
    ld a, [PLAYER_X]
    add 1
    ld [PLAYER_X], a

    ld a, [PLAYER_STEP]
    add PLAYER_SPEED
    ld [PLAYER_STEP], a

    ld a, 3
    ld [PLAYER_DIR], a

    ret

  .move_left:
    ld a, [PLAYER_X]
    sub 1
    ld [PLAYER_X], a

    ld a, [PLAYER_STEP]
    add PLAYER_SPEED
    ld [PLAYER_STEP], a

    ld a, 1
    ld [PLAYER_DIR], a

    ret

  .draw:
    ld a, [PLAYER_INDEX]
    M_memory_index_to_address SPRITEGROUPS_START
    ld a, [PLAYER_DIR]
    cp 0
    jr z, .draw_dir_down
    cp 1
    jr z, .draw_dir_left
    cp 2
    jr z, .draw_dir_up
    cp 3
    jr z, .draw_dir_right

    .draw_dir_down:
      ld b, PLAYER_SPRITE_TILE
      ld c, PLAYER_SPRITE_TILE
      ld d, PLAYER_SPRITE_TILE+1
      ld e, PLAYER_SPRITE_TILE+2
      ld a, [PLAYER_STEP]
      cp $7F
      jr nc, .draw_dir_down_no_step
      ld d, PLAYER_SPRITE_TILE+2
      ld e, PLAYER_SPRITE_TILE+1
      .draw_dir_down_no_step:
        ld a, %1010
      jp .draw_dir_end

    .draw_dir_up:
      ld b, PLAYER_SPRITE_TILE+($35-$2B)
      ld c, PLAYER_SPRITE_TILE+($35-$2B)
      ld d, PLAYER_SPRITE_TILE+($37-$2B)
      ld e, PLAYER_SPRITE_TILE+($36-$2B)
      ld a, [PLAYER_STEP]
      cp $7F
      jr nc, .draw_dir_up_no_step
      ld d, PLAYER_SPRITE_TILE+($36-$2B)
      ld e, PLAYER_SPRITE_TILE+($37-$2B)
      .draw_dir_up_no_step:
        ld a, %1010
      jp .draw_dir_end


    .draw_dir_right:
      ld b, PLAYER_SPRITE_TILE+($30-$2B)
      ld c, PLAYER_SPRITE_TILE+($2F-$2B)
      ld d, PLAYER_SPRITE_TILE+($32-$2B)
      ld e, PLAYER_SPRITE_TILE+($31-$2B)
      ld a, [PLAYER_STEP]
      cp $7F
      jr nc, .draw_dir_right_no_step
        ld d, PLAYER_SPRITE_TILE+($34-$2B)
        ld e, PLAYER_SPRITE_TILE+($33-$2B)
      .draw_dir_right_no_step
        ld a, %1111
      jp .draw_dir_end
      

    .draw_dir_left: 
      ld b, PLAYER_SPRITE_TILE+($2F-$2B)
      ld c, PLAYER_SPRITE_TILE+($30-$2B)
      ld d, PLAYER_SPRITE_TILE+($31-$2B)
      ld e, PLAYER_SPRITE_TILE+($32-$2B)
      ld a, [PLAYER_STEP]
      cp $7F
      jr nc, .draw_dir_left_no_step
        ld d, PLAYER_SPRITE_TILE+($33-$2B)
        ld e, PLAYER_SPRITE_TILE+($34-$2B)
      .draw_dir_left_no_step
        ld a, %0000
      jp .draw_dir_end

    .draw_dir_end:
      call sprite.change_group

    ; Déplacement du background 
    ld b, 168/2-16-8
    ld a, [PLAYER_Y]
    sub b
    ld [LDC_SCROLL_Y], a
    ld b, 160/2-8
    ld a, [PLAYER_X]
    sub b
    ld [LDC_SCROLL_X], a


      ret