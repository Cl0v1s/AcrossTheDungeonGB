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
    cp 40
    jr z, .search_free_exit
    push bc ; on conserve la valeur de b
    ld b, [hl] ; position y
    inc hl 
    ld c, [hl] ; position x
    inc hl
    ld d, [hl] ; tile number 
    inc hl
    ld e, [hl] ; flag
    inc hl
    ; comparaison à zéro
    xor a ; raz
    or b 
    or c 
    or d 
    or e
    cp 0
    pop bc ; on restaure la valeur de b 
    jr nz, .search_free_loop
    ; repositionnement à la bonne valeur de hl
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
  ret

