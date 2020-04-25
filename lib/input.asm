input:

; Retourne si la touche demandées et préssée
; b touche demandée (and %0000 1111) (ordre bas, haut, gauche, droite)
; return a = 0 si oui, a = 1 sinon
.is_pressed:
  ld a, [JOYPAD]
  and %11101111 ; on écoute les directions 
  ld [JOYPAD], a

  ld a, [JOYPAD]
  and b

  jr z, .is_pressed_end ; si a == b
  ; sinon
    ld a, 1
  .is_pressed_end:
    ret