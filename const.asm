        IF      !DEF(CONST_ASM)
CONST_ASM  SET  1

INCLUDE "include/Hardware.inc"

;Définition des variables de direction
_DIR_LEFT EQU 0
_DIR_UP EQU 1
_DIR_RIGHT EQU 2
_DIR_DOWN EQU 3

;Définition des variables relatives au pad
_PAD_LEFT EQU $CD
_PAD_RIGHT EQU $CE
_PAD_UP EQU $CB
_PAD_DOWN EQU $C7


;Sprite Ram, point de départ pour le stockage des sprites
_SRAM EQU _VRAM+$0800
_SINVX EQU $20 ;code permettant d'inverser un sprite sur l'axe des x
_SNORM EQU 0

;BG Map DATA 1
_BG1RAM EQU _VRAM+$1800
;BG MAP DATA 2
_BG2RAM EQU _VRAM+$1C00

;Variable temporaire permettant de réaliser des calculs dans les fonctions nécessitant plus de trois registres
; A noter que _TEMP+1 est aussi réservé (pour les calculs d'adresse)
_TEMP EQU $C000
; Compteur d'input
_INPUT_COUNTER EQU $C002


;INFORMATIONS CONCERNANT LE JOUEUR
; A noter que les 4 premiers sprites de l'OAM sont réservés au joueur

;Points de vie du joueur
_PLAYER_LIFE EQU $C003
;Informations concernant l'animation du joueur bit 0->direction, bit 1->moved, bit 2->inversion
; Ce qui nous donne pour la direction le schéma suivant (une fois ANIMATION and DIRECTION)
; 0 -> down (0 vertical)
; 1 -> up (inversion de down)
; 4 -> left (0 horizontal)
; 5 -> right (inversion de left)
_PLAYER_ANIMATION EQU $C007
_PLAYER_MOVED EQU %10
_PLAYER_DIRECTION EQU %101
;Adresse de l'index de frame du joueur
_PLAYER_FRAME EQU $C004
;X et Y du joueur (x=_PLAYER_POS et y=_PLAYER_POS) $C006 est réservé
_PLAYER_POS EQU $C005
;Vitesse du joueur
_PLAYER_MOVE_SPEED EQU 2
;index du premier sprite du joueur
_PLAYER_SPRITE_INDEX EQU $80

        ENDC
