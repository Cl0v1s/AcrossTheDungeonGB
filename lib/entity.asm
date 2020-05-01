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
  ; return hl: index de l'entité
  .create:
    ld d, c
    ld e, c
    ld c, b
    ; ld b, b
    call sprite.create_group
    push hl 
    ld hl, ENTITIES_START
    ld b, ENTITIES_SIZE
    ld c, ENTITIES_MAX
    call memory.search_free
    pop bc ; ancien hl maintenant dans bc
    ld [hl], c ; sauvegarde de la position du spriteGroup
    ; récupération de l'index à ajouter à l'adresse de début des entities
    ld a, l 
    sub ENTITIES_START
    ld l, a
    ld a, h 
    sbc (ENTITIES_START >> 8)
    ld h, a
    ret
    
    
  ret 

  