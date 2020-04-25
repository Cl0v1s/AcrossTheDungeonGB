lcd:
  .wait_vblank:
    ld a,[LCD_Y] ;A=($FF44)
    cp 144 ;Comparer A avec 144
    jr c, .wait_vblank ;Sauter à waitvbl si A<144
    ret

  .wait_vram_writable: 
    push hl
    ld   hl,LCD_STATUS    ;-STAT Register
    .wait_vram_writable_loop:            ;\
      bit  1,[hl]     ; Wait until Mode is 0 or 1
      jr   nz,.wait_vram_writable_loop    ;/
    pop hl

  .off:
    xor a
    ld [LCD_CONTROL], a 
    ret
  
  .on:
    ld a,%11100100 ;11=Noir 10=Gris foncé 01=Gris clair 00=Blanc/transparent
    ld [$FF47],a ; Palette BG
    ld [$FF48],a ; Palette sprite 0
    ld [$FF49],a ; Palette sprite 1 (ne sert pas)
    ld a,%10010011 ; Ecran on, Background on, tiles à $8000
    ld [LCD_CONTROL],a
    ret


  