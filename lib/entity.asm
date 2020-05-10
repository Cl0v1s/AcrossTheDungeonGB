

; Dessine toutes les entités en mémoire
M_entity_draw: macro 
  ld hl, ENTITIES_START
  ld b, ENTITIES_MAX
  .M_entity_draw_loop:
    ld a, [hl]
    and %10000000
    cp %10000000 ; si l'entité existe et qu'elle est à mettre à jour
    jr nz, .M_entity_draw_loop_no_draw
      push hl 
      push bc 
      M_memory_address_to_index ENTITIES_START
      call entity.draw
      pop bc 
      pop hl 
      res 6, [hl] ; on signale que l'entité n'est plus à mettre à jour
    .M_entity_draw_loop_no_draw:
    dec b
    ld d, $00
    ld e, ENTITIES_SIZE
    add hl, de
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
  ; a index de l'entité
  ; b position x  
  ; c position y
  ; return a: 0 -> accessible
  ; optimisable en ne testant que les points concernés par direction
  .can_walk: 
    ; on ne prend que les pieds 
    ld a, c 
    add 8 
    ld c, a

    ; vérification map
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
    set 6, [hl]
    inc hl ; 1: x
    ld [hl], b
    inc hl ; 2: y
    ld [hl], c
  ret

  ; vérifie qu'aucune entité ne se trouve aux coordonnées demandées 
  ; a: index de l'entité courante 
  ; b: position x à vérifier 
  ; c: position y à vérifier 
  ; return a -> 0: ok, >0 pas possible, index (inversé) de l'entité responsable de la collision 
  .check_for_entities:
    ld hl, ENTITIES_START
    ld d, ENTITIES_MAX
    ld e, a 

    .check_for_entities_loop:
      push bc 
      push de 
      push hl 
      ld a, [hl]
      and %10000000
      cp %10000000 ; si l'entité existe 
      jr nz, .check_for_entities_loop_pass
      push bc 
      M_memory_address_to_index ENTITIES_START
      pop bc
      cp e ; on regarde si c'est la même entité 
      jr z, .check_for_entities_loop_pass ; si c'est le cas on saute
      ; a contient l'index de l'autre entité
      push af 
      call .collision
      cp 0 
      pop bc ; ancien af maintenant dans bc, index de l'autre entité dans b 
      jr nz, .check_for_entities_no

      .check_for_entities_loop_pass:
      pop hl 
      ld d, $00 
      ld e, ENTITIES_SIZE
      add hl, de 
      pop de 
      pop bc 
      dec d 
      jr nz, .check_for_entities_loop

    ; .check_for_entities_yes:
    ld a, 0 
    ret
    .check_for_entities_no:
    ld a, b
    xor $FF ; on inverse 
    pop hl 
    pop de 
    pop bc 
    ret 

  ; vérifie si l'entité a entre en collision avec les cordonnées passées en paramètres 
  ; a: index de l'entit é
  ; b: coordonnée x 
  ; c: coordonnée y
  .collision
    M_memory_index_to_address ENTITIES_START
    inc hl ; selection x 
    ldi a, [hl]
    ;sra a ; divise par 8 pour avoir la cellule 
    ;sra a 
    ;sra a 
    ld d, a ; x de l'entité 
    ld a, [hl]
    ;add 8 ; on ne veut que les pieds 
    ;sra a ; on divise par 8 pour avoir la cellule 
    ;sra a 
    ;sra a 
    ld e, a ; y de l'entité 

    ;sra b 
    ;sra b 
    ;sra b 
    ;sra c 
    ;sra c 
    ;sra c 

    ld a, e 
    add 15 ; e + 2 >= c 
    cp c 
    jr c, .collision_no
    ; a contient e + 1
    sub 31 ; e - 2 <= c 
    cp c 
    jr nc, .collision_no

    ld a, d 
    add 15 ; d + 2 >= b 
    cp b 
    jr c, .collision_no
    ; a contient d + 1
    sub 31 ; d - 2 <= b
    cp b  
    jr nc, .collision_no

    ; .collision_yes 
    ld a, 1
    ret 
    .collision_no 
    ld a, 0 
  ret 

  ; Vérifie si l'entité se trouve au coordonnées demandées
  ; a: index de l'entité 
  ; b: x 
  ; c: y 
  ; return a-> 1: oui, 0: non
  .is_at_coord:
    sra b 
    sra b 
    sra b 
    sra c 
    sra c 
    sra c 

    jp .is_at_cell

  ; Vérifie si l'entité se trouve à la cellule demandée 
  ; a: index de l'entité 
  ; b: x cellule 
  ; c: y cellule 
  ; return a-> 1: oui, 0: non
  .is_at_cell:
    M_memory_index_to_address ENTITIES_START
    inc hl ; selection x 
    ldi a, [hl]
    sra a ; divise par 8 pour avoir la cellule 
    sra a 
    sra a 
    ld d, a ; x de l'entité 
    ld a, [hl]
    ;add 8 ; on ne veut que les pieds 
    sra a ; on divise par 8 pour avoir la cellule 
    sra a 
    sra a 
    ld e, a ; y de l'entité 

    ; ld a, e 
    cp c 
    jr z, .is_at_cell_test_x
    jp .is_at_cell_no

    .is_at_cell_test_x
    ld a, d 
    cp b 
    jr nz, .is_at_cell_no
      ld a, 1 ; si on est sur la même cellule, on arrête là
      ret
    .is_at_cell_no: 
    ld a, 0 
  ret

  ; déplace l'entité dans la direction demandée à la vitesse demandée 
  ; a: index de l'entité 
  ; b: direction 0:down 1:left 2:up 3:right
  ; c: vitesse
  ; return 0: si pas de collision, 1: si avec le terrain, 2: Si avec une entitié 
  .move: 
    push af 
    M_memory_index_to_address ENTITIES_START
    set 6, [hl]

    inc hl ; selection x 
    ld a, [hl]
    ld d, a 
    inc hl ; selection y 
    ld a, [hl]
    ld e, a 

    ld a, b
    cp 0 ; down 
    jr z, .move_down
    cp 1 ; left 
    jr z, .move_left
    cp 3 
    jr z, .move_right 
    ; cp 2
    ; jr z, .move_up

    .move_up:
    ld a, e
    sub c
    ld e, a 
    jp .move_end
    .move_down: 
    ld a, e 
    add c 
    ld e, a
    jp .move_end
    .move_left: 
    ld a, d
    sub c 
    ld d, a 
    jp .move_end
    .move_right: 
    ld a, d
    add c 
    ld d, a 
    ;jp .move_end 
    .move_end: 
    inc hl 
    ld a, b ; maj dir
    ld [hl], a 
    inc hl 
    ld a, [hl] ; maj step
    add PLAYER_SPEED
    ld [hl], a 
    dec hl 
    dec hl ; selection y 

    push de 
    push hl 
    ld b, d
    ld c, e
    call .can_walk
    pop hl
    pop bc ; ancien de maintenant dans bc 
    pop de ; ancien af maintenant dans de 
    cp 0 
    jr nz, .move_done

    call player.collision 
    cp 0 
    jr nz, .move_no_collision

    push hl 
    push bc 
    ld a, d 
    call .check_for_entities
    pop de ; ancien bc maintenant dans de 
    pop hl 
    cp 0 
    jr nz, .move_no_entities 
    
    ld a, e 
    ld [hl], a 
    dec hl ; selection x 
    ld a, d 
    ld [hl], a
    ld a, 0 ; Renvoie 0 si pas de soucis 
    jp .move_done 
    .move_no_collision
    ld a, 1 ; renvoie 1 si collision avec le terrain
    jp .move_done
    .move_no_entities 
    ld a, 2 ; renvoie 2 si collision avec une entit é
    .move_done
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

      ld a, [LDC_SCROLL_X]
      ld d, a
      inc hl ; selection x 
      ld a, [hl]
      add 8
      sub d
      ld b, a

      ld a, [LDC_SCROLL_Y]
      ld e, a 
      inc hl ; selection y 
      ld a, [hl]
      add 16 
      sub e
      ld c, a

      dec hl ; selection sprite Index
      dec hl 
      ld a, [hl]
      and $0F ; on ne récupère que l'index de sprite
      M_memory_index_to_address SPRITEGROUPS_START
      call sprite.move_group

  pop hl 
  ret 
  