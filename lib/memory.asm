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
