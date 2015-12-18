;-----> Generate a random number
; ouput a=answer 0<=a<=255
; all registers are preserved except: af
random:
        push    hl
        push    de
        ld      hl,[$FE00]
        ld      a,1
        ld      d,a
        ld      e,(hl)
        add     hl,de
        add     a,l
        xor     h
        ld      [$FE00],hl
        pop     de
        pop     hl
        ret
