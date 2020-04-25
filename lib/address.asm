; Premiers 32ko du ROM de la cartouche
ROM_START equ $0000
ROM_END equ $7FFF

; 8ko de VRAM
VRAM_START equ $8000
VRAM_END equ $9FFF

VRAM_BACKGROUNDMAP_START equ $9800
VRAM_BACKGROUNDMAP_END equ $9BFF
VRAM_WINDOWMAP_START equ $9C00
VRAM_WINDOWMAP_END equ $9FFF

; 8ko de RAM interne à la cartouche (pour les sauvegardes, si il y en a)
CARDRAM_START equ $A000
CARDRAM_END equ $BFFF

; 8ko de RAM de travail
RAM_START equ $C000
RAM_END equ $DFFF	

; Echo des 8ko de RAM précedents (mirroir)
; $E000
; $FDFF

; OAM (sorte de VRAM supplémentaire)
OAM_START equ $FE00
OAM_END equ $FE9F

; Registres de configuration pour le GPU et l'APU
GPU equ $FF00
LCD_CONTROL equ $FF40
LCD_STATUS equ $FF41
LCD_Y equ $FF44
APU equ $FF7F

; Petit morceau de RAM supplémentaire (HRAM)
HRAM_START equ $FF80
HRAM_END equ $FFFE

; Registre spécial concernant les interruptions
IRQ equ $FFFF 
	

	
	
	