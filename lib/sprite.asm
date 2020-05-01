sprite:
  ; Libère un emplacement de sprite
  ; hl emplacement à libérer
  .free: 
    ld a, 0
    ldi [hl], a ; y
    ldi [hl], a ; x
    ldi [hl], a ; tile
    ldi [hl], a ; flag
    ret
  
  ; Cherche un emplacement de sprite libre 
  ; return hl
  .search_free: 
    push bc
    push de
    ld hl, OAM_START
    ld b, 0 ; compteur 
    .search_free_loop:
      ; Si hl sorti de OAM    
      ld a, b 
      cp 40 ; est ce qu'on a fait le tour des 40 emplacement ? 
      jr z, .search_free_exit
      ld c, [hl] ; position y
      inc hl 
      inc hl 
      inc hl 
      inc hl
      ; comparaison à zéro
      xor a ; raz
      or c 
      cp 0
      jr nz, .search_free_loop
      dec hl 
      dec hl 
      dec hl 
      dec hl
      jp .search_free_end
      .search_free_exit:
        ld hl, 0 ; si on a rien trouvé on met hl à 0
    .search_free_end:
      pop de
      pop bc 
      ret

; Fait apparaitre un sprite à l'écran
; b position x
; c position y
; d tile number 
; e flags 
.spawn:
  call .search_free
  ld a, b 
  ldi [hl], a 
  ld a, c 
  ldi [hl], a 
  ld a, d 
  ldi [hl], a 
  ld a, e 
  ldi [hl], a 
  ; on remets hl à la valeut initiale de la position dans l'OAM
  dec hl 
  dec hl 
  dec hl 
  dec hl
  ret

; déplace un sprite
; hl doit contenir l'adresse OAM
; b position x 
; c position y
.move: 
  push hl

  ld a, c 
  ldi [hl], a
  ld a, b
  ldi [hl], a

  pop hl
  ret

; Change un sprite 
; hl doit contenir l'adresse OAM
; b nouveau tile
; c attributes
.change:
  push hl 

  inc hl
  inc hl 
  ld [hl], b
  inc hl 
  ld [hl], c

  pop hl
ret

; Retourne l'adresse de la structure de spritegroup valide
; return hl: adresse 
.get_group_address: 
  ld hl, SPRITEGROUPS_START
  ld b, SPRITEGROUPS_SIZE
  ld c, SPRITEGROUPS_MAX
  call memory.search_free
  ret


; Crée un groupe de sprites qui pourront être contrôlés ensemble
; b tile 1
; c tile 2
; d tile 3
; e tile 4
; return a: index du groupe 
.create_group
  push bc
  push de 
  call .get_group_address ; hl contient l'adresse du groupe

  pop de 
  pop bc
  push bc 
  push de 
  push hl

  ; Gestion sprite 1
  ld d, b
  ld b, 16 
  ld c, 8 
  ld e, 0
  call .spawn

  pop hl ; hl contient l'adresse RAM du groupe
  pop de 
  pop bc
  ; a contient l'adresse OAM du sprite (4 derniers bits)
  xor $FF ; on inverse pr que 0 = FF et ne bug pas la recherche de mémoire
  ld [hl], a
  push hl

  ; On restaure et on re-sauve les paramètres
  push bc 
  push de


  ; Gestion sprite 2
  ld d, c
  ld b, 16
  ld c, 8+8
  ld e, %00100000
  call .spawn

  ; On restaure et on re-sauve les paramètres
  pop de
  pop bc 
  push bc 
  push de

  ; Gestion sprite 3
  ; d a déjà la bonne valeur
  ld b, 16+8
  ld c, 8
  ld e, 0
  call .spawn

  ; On restaure et on re-sauve les paramètres
  pop de
  pop bc 
  push bc 
  push de

  ; Gestion sprite 3
  ld d, e
  ld b, 16+8
  ld c, 8+8
  ld e, %00100000
  call .spawn

  pop de 
  pop bc
  pop hl
  ; récupération de l'index à ajouter à l'adresse de début des spritegroups
  ; ld hl, hl
  M_memory_address_to_index SPRITEGROUPS_START
ret

; Déplace un groupe de sprite 
; hl doit contenir l'adresse du groupe dans la RAM
; b doit contenir nouvelle position x 
; c doit contenir nouvelle position y
.move_group

  ld a, [hl] ; récupère 4 derniers bits de l'adresse du premier OAM
  xor $FF ; on inverse les bits
  push hl 
  ld hl, OAM_START
  ld l, a
  call .move

  pop hl 
  ld a, [hl]
  xor $FF
  add $04
  push hl 
  ld hl, OAM_START
  ld l, a
  ld a, b 
  add 8 ; on décale de 8 pixels vers la droite
  ld b, a
  call .move

  pop hl 
  ld a, [hl]
  xor $FF
  add $08
  push hl 
  ld hl, OAM_START
  ld l, a
  ld a, b 
  sub 8 ; on décale de 8 pixels vers la gauche
  ld b, a
  ld a, c
  add 8 ; on décale de 8 pixels vers le bas
  ld c, a
  call .move

  pop hl 
  ld a, [hl]
  xor $FF
  add $0C
  ld hl, OAM_START
  ld l, a
  ld a, b 
  add 8 ; on décale de 8 pixels vers la droite
  ld b, a
  call .move
  
ret

; Change les caractéristiques d'un groupe de sprite 
; hl doit contenir l'adresse du groupe
; a invert %4321
; b tile 1
; c tile 2
; d tile 3
; e tile 4
.change_group:
  push bc
  push hl
  push af 

  ; haut gauche
  ld a, [hl]
  xor $FF
  ld hl, OAM_START
  ld l, a
  ; ld b, b b a déjà la bonne valeur
  ld c, 0 
  pop af
  push af
  bit 0, a
  jr z, .change_group_hg
  ld c, %00100000
  .change_group_hg:
    call .change


  pop af 
  pop hl 
  pop bc 
  push bc 
  push hl 
  push af

  ; haut droite
  ld a, [hl]
  xor $FF
  add $04
  ld hl, OAM_START
  ld l, a
  ld b, c
  ld c, 0
  pop af
  push af
  bit 1, a
  jr z, .change_group_hd
  ld c, %00100000
  .change_group_hd:
    call .change

  pop af 
  pop hl 
  pop bc 
  push bc 
  push hl 
  push af
  ; bas gauche
  ld a, [hl]
  xor $FF
  add $08
  ld hl, OAM_START
  ld l, a
  ld b, d
  ld c, 0
  pop af
  push af
  bit 2, a
  jr z, .change_group_bg
  ld c, %00100000
  .change_group_bg:
    call .change

  pop af 
  pop hl 
  pop bc 
  push bc 
  push hl 
  push af
  ; haut droite
  ld a, [hl]
  xor $FF
  add $0C
  ld hl, OAM_START
  ld l, a
  ld b, e
  ld c, 0
  pop af
  push af
  bit 3, a
  jr z, .change_group_bd
  ld c, %00100000
  .change_group_bd:
    call .change

  pop af 
  pop hl 
  pop bc
  
ret