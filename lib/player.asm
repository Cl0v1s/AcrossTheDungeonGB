player: 

  ; créer l'ensemble sprite du joueur 
  .create:
    ld b, PLAYER_SPRITE_TILE
    ld c, PLAYER_SPRITE_TILE
    ld d, PLAYER_SPRITE_TILE+1
    ld e, PLAYER_SPRITE_TILE+1
    call sprite.create_group
    ; centrage à l'écran
    ld b, 16+160/2-16
    ld c, 8+168/2-16
    ld hl, SPRITEGROUPS_START
    call sprite.move_group
    ret

  ; Test si la position demandée est accessible 
  ; b position x  
  ; c position y
  ; return a cellule
  .get_cell:
    push de

    ld hl, MAP_CURRENT
    ldi a, [hl]
    ld d, a 
    ld a, [hl]
    ld l, a
    ld h, d
    ; une ligne de la backgroundmap fait 32 bytes
    ld d, $00
    ld e, $20
    ld a, c
    ; on divise par 8, les cellules faisant chacune 8 pixels 
    srl a
    srl a
    srl a
    .update_y_loop:
      add hl, de
      dec a
      cp 0
      jr nz, .update_y_loop
    ld a, b
    ; on divise par 8, les cellules faisant chacune 8 pixels 
    srl a
    srl a
    srl a
    ; ld d, $00
    ld e, a
    add hl, de

    ld a, [hl]
    ld [TEST], a
    pop de
  ret

  ; Test si la position demandée est accessible 
  ; b position x  
  ; c position y
  ; return a: 0 -> accessible
  ; optimisable en ne testant que les points concernés par direction
  .can_walk: 
    ; ld [TEST], a

    ; on ne prend que les pieds 
    ld a, c 
    add 8 
    ld c, a

    ; coin haut gauche 
    ; ld b, b
    ; ld c, c
    call .get_cell
    cp 0 
    jr nz, .can_walk_no

    ; coin haut droit 
    ld a, b 
    add 16 ; largeur personnage
    ld b, a
    ; ld c, c
    call .get_cell
    cp 0 
    jr nz, .can_walk_no

    ; coin bas droit 
    ; ld b, b
    ld a, c
    add 8 ; 8 et non 16 car on ne prend que les pieds
    ld c, a
    call .get_cell 
    cp 0 
    jr nz, .can_walk_no

    ; coin bas gauche 
    ld a, b 
    sub 16 
    ld b, a
    ; ld c, c
    call .get_cell
    cp 0 
    jr nz, .can_walk_no

    .can_walk_yes: 
      ld a, 0
      jp .can_walk_end
    .can_walk_no: 
      ld a, 1
    .can_walk_end
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
    call .can_walk
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
      call .can_walk
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
      call .can_walk
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
      call .can_walk
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

    ld b, 168/2-16-8
    ld a, [PLAYER_Y]
    sub b
    ld [LDC_SCROLL_Y], a

    ld b, 160/2-8
    ld a, [PLAYER_X]
    sub b
    ld [LDC_SCROLL_X], a

    ; Déplacement du background 
    ; ld a, [LDC_SCROLL_X]
    ; add 16+160/2-16
    ; ld [LDC_SCROLL_X], a
    ; ld a, [LDC_SCROLL_Y]
    ; ld a, [PLAYER_Y]
    ; add 8+168/2-16
    ; ld [LDC_SCROLL_Y], a

      ret