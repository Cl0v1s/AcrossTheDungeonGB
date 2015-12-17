        IF      !DEF(SPRITE_ASM)
SPRITE_ASM  SET  1

INCLUDE "include/Hardware.inc"
INCLUDE "const.asm"

SECTION "Sprite",HOME

; SPRITE_CREATE
; Créer une nouvelle entrée dans l'OAM pour un nouveau sprite
; Paramètres 
; a-> index du sprite dans l'OAM
; b-> position x du sprite
; c-> position y du sprite
; d -> index de la tuile correspondant au sprite dans la tile table
SPRITE_CREATE::
	ld h,0
	ld l,a ;Récupération de l'index réel du sprite en terme du byte dans l'OAM
	sla16 hl,2
	ld a,h
	ld [_TEMP],a
	ld a,l
	ld [_TEMP+1],a
	ld hl,_OAMRAM
	ld a,[_TEMP]
	add a,h
	ld h,a
	ld a,[_TEMP+1]
	add a,l
	ld l,a
	ld a,c ;Enregistrement position y
	add a,16
	ld [hl],a
	ld a,b; Enregistrement position x
	add a,8
	inc hl
	ld [hl],a
	inc hl ;Enregistrement index du sprite
	ld [hl],d
	inc hl ;Enregistrement meta data sprites
	ld [hl], $00
	ret
	
;SPRITE_SET_META
; Change les meta donnees d'un sprite
; paramètre
; a -> index du sprite à changer 
; b-> (voir byte3 des prite pandoc)
SPRITE_SET_META::
	ld h,0
	ld l,a ;Récupération de l'index réel du sprite en terme du byte dans l'OAM
	sla16 hl,2
	ld a,h
	ld [_TEMP],a
	ld a,l
	ld [_TEMP+1],a
	ld hl,_OAMRAM
	ld a,[_TEMP]
	add a,h
	ld h,a
	ld a,[_TEMP+1]
	add a,l
	add a,3
	ld l,a
	ld a,b
	ld [hl],a
	ret
	
;SPRITE_SET_TILE
; Change la tuile de référence pour un sprite
; paramètres 
; a -> index sprite
; b-> nouvel index de sprite
SPRITE_SET_TILE::
	ld h,0
	ld l,a ;Récupération de l'index réel du sprite en terme du byte dans l'OAM
	sla16 hl,2
	ld a,h
	ld [_TEMP],a
	ld a,l
	ld [_TEMP+1],a
	ld hl,_OAMRAM
	ld a,[_TEMP]
	add a,h
	ld h,a
	ld a,[_TEMP+1]
	add a,l
	add a,2
	ld l,a
	ld a,b
	ld [hl],b
	ret
	
;SPRITE_SET_POS
; Change la position d'un sprite
; paramètres:
; a-> index du sprite à modifier
; b-> nouvelle position x
; c -> nouvelle position y
SPRITE_SET_POS::
	ld h,0
	ld l,a ;Récupération de l'index réel du sprite en terme du byte dans l'OAM
	sla16 hl,2
	ld a,h
	ld [_TEMP],a
	ld a,l
	ld [_TEMP+1],a
	ld hl,_OAMRAM
	ld a,[_TEMP]
	add a,h
	ld h,a
	ld a,[_TEMP+1]
	add a,l
	ld l,a
	
	ld a,c
	add 16
	ld [hl],a
	ld a,l
	add 1
	ld l,a
	ld a,b
	add 8
	ld [hl],a
	ret


		ENDC
