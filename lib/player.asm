player: 

  ; créer l'ensemble sprite du joueur 
  .create:
    ld b, $2B
    ld c, $2B
    ld d, $2C
    ld e, $2C
    call sprite.create_group
    ret

  .update:
    call input.listen_directions
    bit 3, a ; on test si le bit 3 vaut 0 -> la touche bas est pressé
    jr nz, .nod
    call .move_down
    jp .update_end
    .nod:
      bit 2, a ; on test si le bit 2 vaut 0 -> la touche haut est pressé
      jr nz, .nou
      call .move_up
      jp .update_end
    .nou:
      bit 1, a ; on test si le bit 1 vaut 0 -> la touche gauche est pressé
      jr nz, .nol
      call .move_left
      jp .update_end
    .nol:
      bit 0, a ; on test si le bit 0 vaut 0 -> la touche droite est pressé
      jr nz, .update_end
      call .move_right
    .update_end:
      ret

  .move_down:
    ld a, [PLAYER_Y]
    add 1
    ld [PLAYER_Y], a

    ld a, [PLAYER_STEP]
    add PLAYER_SPEED
    ld [PLAYER_STEP], a

    ld hl, SPRITEGROUPS_START
    ld b, $2B
    ld c, $2B
    ld d, $2C
    ld e, $2D
    cp $7F
    jr nc, .move_down_no_step
    ld d, $2D
    ld e, $2C
    .move_down_no_step:
      ld a, %1010
      call sprite.change_group
      ret

  .move_up:
    ld a, [PLAYER_Y]
    sub 1
    ld [PLAYER_Y], a

    ld a, [PLAYER_STEP]
    add PLAYER_SPEED
    ld [PLAYER_STEP], a

    ld hl, SPRITEGROUPS_START
    ld b, $35
    ld c, $35
    ld d, $37
    ld e, $36
    cp $7F
    jr nc, .move_up_no_step
    ld d, $36
    ld e, $37
    .move_up_no_step:
    ld a, %1010
    call sprite.change_group
    ret

  .move_right:
    ld a, [PLAYER_X]
    add 1
    ld [PLAYER_X], a

    ld a, [PLAYER_STEP]
    add PLAYER_SPEED
    ld [PLAYER_STEP], a

    ld hl, SPRITEGROUPS_START
    ld b, $30
    ld c, $2F
    ld d, $32
    ld e, $31
    cp $7F
    jr nc, .move_right_no_step
      ld d, $34
      ld e, $33
    .move_right_no_step
      ld a, %1111
      call sprite.change_group
      ret

  .move_left:
    ld a, [PLAYER_X]
    sub 1
    ld [PLAYER_X], a

    ld a, [PLAYER_STEP]
    add PLAYER_SPEED
    ld [PLAYER_STEP], a

    ld hl, SPRITEGROUPS_START
    ld b, $2F
    ld c, $30
    ld d, $31
    ld e, $32
    cp $7F
    jr nc, .move_left_no_step
      ld d, $33
      ld e, $34
    .move_left_no_step
    ld a, %0000
    call sprite.change_group
    ret

  .draw:
    push hl
    ld a, [PLAYER_X]
    add 8 ; x à l'écran commence à 8
    ld b, a

    ld a, [PLAYER_Y]
    add 16 ; y à l'écran commence à 16 
    ld c, a

    ld hl, SPRITEGROUPS_START
    call sprite.move_group

    pop hl 
    ret