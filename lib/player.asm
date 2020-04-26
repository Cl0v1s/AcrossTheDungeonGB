player: 

  ; créer l'ensemble sprite du joueur 
  .create:
    ld b, PLAYER_SPRITE_TILE
    ld c, PLAYER_SPRITE_TILE
    ld d, PLAYER_SPRITE_TILE+1
    ld e, PLAYER_SPRITE_TILE+1
    call sprite.create_group
    ret

  .input: 
    call input.listen_directions
    bit 3, a ; on test si le bit 3 vaut 0 -> la touche bas est pressé
    jr nz, .nod
    call .move_down
    jp .input_end
    .nod:
      bit 2, a ; on test si le bit 2 vaut 0 -> la touche haut est pressé
      jr nz, .nou
      call .move_up
      jp .input_end
    .nou:
      bit 1, a ; on test si le bit 1 vaut 0 -> la touche gauche est pressé
      jr nz, .nol
      call .move_left
      jp .input_end
    .nol:
      bit 0, a ; on test si le bit 0 vaut 0 -> la touche droite est pressé
      jr nz, .input_end
      call .move_right
    .input_end:
    ret

  ; Met à jour le joueur
  .update:
    call .input

    ld hl, VRAM_BACKGROUNDMAP_START
    ; une ligne de la backgroundmap fait 32 bytes
    ld b, $00
    ld c, $20
    ld a, [PLAYER_Y]
    ; on ne prend que les pieds 
    add 8
    ; on divise par 8, les cellules faisant chacune 8 pixels 
    srl a
    srl a
    srl a
    .update_y_loop:
      add hl, bc
      dec a
      cp 0
      jr nz, .update_y_loop
    ld a, [PLAYER_X]
    ; on divise par 8, les cellules faisant chacune 8 pixels 
    srl a
    srl a
    srl a
    ; ld b, $00
    ld c, a
    add hl, bc

    ld a, [hl]
    ld [TEST], a




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

    ld hl, SPRITEGROUPS_START
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

    ; Gestion de la position 
    ld a, [PLAYER_X]
    add 8 ; x à l'écran commence à 8
    ld b, a

    ld a, [PLAYER_Y]
    add 16 ; y à l'écran commence à 16 
    ld c, a

    ld hl, SPRITEGROUPS_START
    call sprite.move_group

      ret