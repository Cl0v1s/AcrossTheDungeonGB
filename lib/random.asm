random: 

; Génère un nombre "aléatoire"
; return a: nombre 
.generate:
  ld a, [DRAW_STEP]
  ld b, a 
  ld a, [$FF04]
  sub b
  ret