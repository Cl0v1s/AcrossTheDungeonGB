        IF      !DEF(CONST_ASM)
CONST_ASM  SET  1

INCLUDE "include/Hardware.inc"

;Sprite Ram, point de départ pour le stockage des sprites
_SRAM EQU _VRAM+$0800
_SINVX EQU $20 ;code permettant d'inverser un sprite sur l'axe des x

;BG Map DATA 1
_BG1RAM EQU _VRAM+$1800
;BG MAP DATA 2
_BG2RAM EQU _VRAM+$1C00

;Variable temporaire permettant de réaliser des calculs dans les fonctions nécessitant plus de trois registres
; A noter que _TEMP+1 est aussi réservé (pour les calculs d'adresse)
_TEMP EQU $C000


;INFORMATIONS CONCERNANT LE JOUEUR
; A noter que les 4 premiers sprites de l'OAM sont réservés au joueur

;Points de vie du joueur
_PLAYER_LIFE EQU $C002
;Index de frame du joueur
_PLAYER_FRAME EQU $C003
;X et Y du joueur (x=_PLAYER_POS et y=_PLAYER_POS)
_PLAYER_POS EQU $C004
;index du premier sprite du joueur
_PLAYER_SPRITE_INDEX EQU $80

        ENDC
