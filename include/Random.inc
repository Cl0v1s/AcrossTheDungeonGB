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

        ENDC
