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
    ret

  .move_up:
    ld a, [PLAYER_Y]
    sub 1
    ld [PLAYER_Y], a
    ret

  .move_right:
    ld a, [PLAYER_X]
    add 1
    ld [PLAYER_X], a
    ret

  .move_left:
    ld a, [PLAYER_X]
    sub 1
    ld [PLAYER_X], a
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