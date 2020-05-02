

; Dessine toutes les entités en mémoire
M_entity_draw: macro 
  ld hl, ENTITIES_START
  ld b, ENTITIES_MAX
  .M_entity_draw_loop:
    ld a, [hl]
    and %11000000
    cp %11000000 ; si l'entité existe et qu'elle est à mettre à jour
    jr nz, .M_entity_draw_loop_no_draw
      push hl 
      M_memory_address_to_index ENTITIES_START
      call entity.draw
      pop hl 
      res 6, [hl] ; on signale que l'entité n'est plus à mettre à jour
    .M_entity_draw_loop_no_draw:
    dec b
    jr nz, .M_entity_draw_loop
endm

entity:

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
    ; hl contient mnt l'adresse de la map dans la ROM

    ; une ligne de la backgroundmap fait 32 bytes
    ld d, $00
    ld e, $20
    ld a, c
    ; on divise par 8, les cellules faisant chacune 8 pixels 
    srl a
    srl a
    srl a
    .update_y_loop: ; on ajoute 32 (une ligne) pour chaque y
      add hl, de
      dec a
      cp 0
      jr nz, .update_y_loop
    ld a, b
    ; on divise par 8, les cellules faisant chacune 8 pixels 
    srl a
    srl a
    srl a
    ; ld d, $00 (d déja = 0)
    ld e, a
    add hl, de ; on ajoute les x
    ld a, [hl]
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

  ; Libère l'ensemble de la zone occupée par l'entité
  ; hl: adresse de l'entité dans la RAM
  .free:
  ld b, ENTITIES_SIZE
  call memory.clear

  ; créer l'entité
  ; b tile supérieur
  ; c tile inférieur
  ; return a: index de l'entité
  .create:
    push bc 

    ld hl, ENTITIES_START
    ld b, ENTITIES_SIZE
    ld c, ENTITIES_MAX
    call memory.search_free

    pop bc 
    ; Sauvegarde du tile de départ
    ld a, b
    ld de, $0005
    add hl, de 
    ld [hl], b
    dec hl 
    dec hl 
    dec hl 
    dec hl
    dec hl

    push hl 

    ld d, c
    ld e, c
    ld c, b
    ; ld b, b
    call sprite.create_group

    M_memory_address_to_index SPRITEGROUPS_START
    and $0F
    or %11000000
    pop hl
    ld [hl], a ; sauvegarde de la position du spriteGroup
    ; récupération de l'index à ajouter à l'adresse de début des entities
    M_memory_address_to_index ENTITIES_START
  ret 

  ; déplace l'entité à la position demandée 
  ; a: index de l'entité
  ; b: position x
  ; c: position y
  .setPosition: 
    M_memory_index_to_address ENTITIES_START
    inc hl ; 1: x
    ld [hl], b
    inc hl ; 2: y
    ld [hl], c
  ret

  ; Dessine l'entité 
  ; a: index de l'entité 
  .draw;
    M_memory_index_to_address ENTITIES_START
    push hl 
    inc hl ; Sélection dir
    inc hl 
    inc hl
    ld a, [hl] ; en fonction de la dir
    cp 0
    jr z, .draw_dir_down
    cp 1
    jr z, .draw_dir_left
    cp 2
    jr z, .draw_dir_up
    cp 3
    jr z, .draw_dir_right

    .draw_dir_down:
      inc hl ; selection tile 
      inc hl 
      ld a, [hl]
      ld b, a ; tile
      ld c, a ; tile
      add 1
      ld d, a ; tile + 1
      add 1
      ld e, a ; tile + 2
      dec hl ; selection step
      ld a, [hl]
      cp $7F
      jr nc, .draw_dir_down_no_step
      ld b, d 
      ld d, e ; tile + 2
      ld e, b ; tile + 1
      ld b, c ; tile
      .draw_dir_down_no_step:
        ld a, %1010
      jp .draw_dir_end

    .draw_dir_up:
      inc hl ; selection tile
      inc hl 
      ld a, [hl]
      add 10
      ld b, a ; tile + 10
      ld c, a ; tile + 10
      add 1
      ld e, a ; tile + 11
      add 1
      ld d, a ; tile + 12
      dec hl ; selection step
      ld a, [hl]
      cp $7F
      jr nc, .draw_dir_up_no_step
      ld b, d 
      ld d, e ; tile + 11
      ld e, b ; tile + 12
      ld b, c  ; tile + 10
      .draw_dir_up_no_step:
        ld a, %1010
      jp .draw_dir_end


    .draw_dir_right:
      inc hl ; selection tile
      inc hl 
      ld a, [hl]
      add 4
      ld c, a ; tile + 4
      add 1 
      ld b, a ; tile + 5
      add 1 
      ld e, a ; tile + 6
      add 1 
      ld d, a ; tile + 7
      dec hl ; selection step
      ld a, [hl]
      cp $7F
      jr nc, .draw_dir_right_no_step
        ld a, d
        add 1 
        ld e, a ; tile + 8
        add 1 
        ld d, a ; tile + 9
      .draw_dir_right_no_step
        ld a, %1111
      jp .draw_dir_end
      

    .draw_dir_left: 
      inc hl ; selection tile
      inc hl 
      ld a, [hl]
      add 4
      ld c, a ; tile + 4
      add 1 
      ld b, a ; tile + 5
      add 1 
      ld e, a ; tile + 6
      add 1 
      ld d, a ; tile + 7
      dec hl ; selection step
      ld a, [hl]
      cp $7F
      jr nc, .draw_dir_left_no_step
        ld a, d
        add 1 
        ld e, a ; tile + 8
        add 1 
        ld d, a ; tile + 9
      .draw_dir_left_no_step
        ld a, %0000
      jp .draw_dir_end

    .draw_dir_end:
      dec hl 
      dec hl 
      dec hl 
      dec hl 
      push hl
      push af 
      ld a, [hl]
      and $0F ; on ne récupère que l'index de sprite
      M_memory_index_to_address SPRITEGROUPS_START
      pop af
      call sprite.change_group
      pop hl

      inc hl ; selection x 
      ld a, [hl]
      add 8
      ld b, a

      inc hl ; selection y 
      ld a, [hl]
      add 16 
      ld c, a

      dec hl ; selection sprite Index
      dec hl 
      ld a, [hl]
      and $0F ; on ne récupère que l'index de sprite
      M_memory_index_to_address SPRITEGROUPS_START
      call sprite.move_group

  pop hl 
  ret 
  