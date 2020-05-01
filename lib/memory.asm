
; get index to add to a certain address
; max index = $FF
; \1: starting address
; hl: actual address
; return a: contain index 
M_memory_address_to_index: macro
  ld bc, \1
  ld a, l 
  sub c
endm

; get adress from index added to certain address
; max index = $FF
; \1 starting address
; a: actual index
; retur hl: actual address
M_memory_index_to_address: macro
  ld hl, \1
  add l
  ld l, a 
  ld a, h 
  adc 0 ; on ajoute la retenue éventuelle à h
  ld h, a 
endm



memory
  ; hl target
  ; bc data start
  ; de data count
  .copy:
    .copy_loop:
      ld a, [bc]
      ldi [hl], a
      inc bc
      dec de
      ld a, e
      or d ; vaut 0 si de = 0
      cp 0
      jr nz, .copy_loop
    ret

  ; hl target
  ; de length to clear
  .clear:
    .clear_loop:
      ld a, 0
      ldi [hl], a
      dec de
      ld a, e
      or d ; vaut 0 si de = 0
      cp 0
      jr nz, .clear_loop
    ret

  ; cherche un emplacement libre de la taille demandé à partir de l'adresse précisée
  ; hl: adresse de départ de la zone 
  ; b: taille de la zone à récupérer
  ; c: Nombre de parcours limit
  ; return hl: adresse libre 
  ; si la taille de la zone est égale à 1 et que la donnée peut potentiellement contenir 0, pensez à inverser (avec xor $FF)
  .search_free: 
    ld d, b 

    jp .search_free_0_reset

    .search_free_abort: 
      ld hl, $00
      push hl
      ret

    .search_free_0_reset:
      dec c
      jr z, .search_free_abort
      ld b, d
    .search_free_0_loop:
      ld a, [hl]
      cp 0
      jr z, .search_free_0_continue
      push de
      ld d, 0
      ld e, b
      add hl, de ; on parcours le chemin restant avant de reset
      pop de
      jp .search_free_0_reset
      .search_free_0_continue:
      inc hl
      dec b
      jr nz, .search_free_0_loop

    ; retour en  arrière du nombre de inc pour récupérer bonne adresse
    .search_free_restore:
      dec hl 
      dec d 
      jp nz, .search_free_restore  
  ret 
