dialog:

; Initialise un nouveau dialogue
; bc: dialog content address
; de: next adress
.create:
  call lcd.window_on
  ld hl, DIALOG_NEXT_ADDR
  ld [hl], d
  inc hl 
  ld [hl], e
  ld hl, DIALOG_INDEX 
  ld [hl], 0
  ; copie du dialogue dans le buffer
  ; ld bc, bc
  ld de, DIALOG_CONTENT_SIZE
  ld hl, DIALOG_CONTENT
  call memory.copy 
ret 

; Gère les étapes dans dialogues 
.update: 
  ld a, [DIALOG_INDEX]
  cp $FF 
  jr z, .update_done_finish ; Si pas de texte, on saute  

  cp 24 
  jr c, .update_done_running ; si le texte est encore en cours d'écriture, on saute 

  call input.listen_actions ; on double call pour éviter le bug d'input

  bit 0, a 
  jr nz, .update_done_running ; on regarde si le bouton a est pressé 

  call lcd.window_off
  ld a, $FE ; on marque le dialogue comme à effacer  
  ld [DIALOG_INDEX], a 

  ld hl, .update_done_running 
  push hl ; on trompe le prochain ret 
  ld a, [DIALOG_NEXT_ADDR] ; on récupère le DIALOG_NEXT_ADDR
  cp 0 
  jr z, .update_done_running ; si l'adresse est invalide (8 bits hauts à 0), alors on n'y va pas 
  ld h, a 
  ld a, [DIALOG_NEXT_ADDR+1]
  ld l, a 
  jp hl 
  .update_done_running:
  ld a, 1
  ret
  .update_done_finish: 

  ld a, 0
ret 

; Efface le dialogue à l'écran
.draw_reset:
  ld hl, VRAM_WINDOWMAP_START
  ld de, 32*2
  .draw_reset_loop:
    ld a, 0
    ldi [hl], a
    dec de
    ld a, e
    or d ; vaut 0 si de = 0
    cp 0
    jr nz, .draw_reset_loop
  ld a, $FF 
  ld [DIALOG_INDEX], a 
  ld a, 1
ret

; Dessine une lettre dans la fenêtre du dialogue 
.draw:
  ld a, [DIALOG_INDEX]
  cp DIALOG_CONTENT_SIZE
  jr nc, .draw_buffer_sup_content_size

  .draw_start:
  ld b, a ; sauvegarde dialog_index
  M_memory_index_to_address DIALOG_CONTENT
  ld a, [hl] 
  ld c, a ; sauvegarde content 
  ld a, b ; restauration dialog_index
  cp 20
  jr c, .draw_do
  sub 20 
  add 32
  .draw_do: 
  M_memory_index_to_address VRAM_WINDOWMAP_START
  ld a, c ; restauration content 
  ld [hl], a

  ld a, b ; restauration dialog_index 
  add 1 
  ld [DIALOG_INDEX], a 
  ld a, 1 
  ret 
  .draw_buffer_sup_content_size:
  jr z, .draw_done
  cp $FE 
  jr z, .draw_reset
  .draw_done:
  ld a, 0
ret