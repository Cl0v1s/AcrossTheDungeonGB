IF      !DEF(RANDOM_ASM)
RANDOM_ASM  SET  1

SECTION "Random", HOME

;-----> Generate a random number
; ouput a=answer 0<=a<=255
; all registers are preserved except: af
random:
        push de
        ld a,[$FF04]
        ld e,a
        ld a,[$FF44]
        xor e
        pop de
        ret

Multiply:                        ; this routine performs the operation HL=D*E
  push hl
  push bc
  push af
  ld hl,0
  ld b,d ;limite
  ld d,0 ;on nettoire d pour avoir de=e
  ld c,0 ;on créer le compteur
.Multiply_for
  add hl,de
  inc c
  ld a,c
  cp b
  jp nz,.Multiply_for
  ld d,h
  ld e,l
  pop af
  pop bc
  pop hl
  ret




        ENDC
