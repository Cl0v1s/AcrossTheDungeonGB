SECTION "game_player",rom0

game_player:

  ; Gère les déplacements du joueur
  ; a: PLAYER_MOVING  
  .move:
  sub 1 
  ld [PLAYER_MOVING], a
  ld a, [PLAYER_DIR]

  cp 0
  call z, player.move_down
  cp 1 
  call z, player.move_left
  cp 2
  call z, player.move_up
  cp 3 
  call z, player.move_right 
  jp .move_done

  .move_done:
  ret 

  ; Gère la mise à jour du joueur 
  .update: 
    ld a, [PLAYER_MOVING]
    cp 0 
    call nz, .move
    call z, .input
  ret

  ; Gère les inputs 
  .input: 
    ld a, [PLAYER_X]
    ld b, a 
    ld a, [PLAYER_Y]
    ld c, a 

    call input.listen_directions
    bit 3, a 
    jr z, .input_down
    bit 2, a 
    jr z, .input_up
    bit 1, a
    jr z, .input_left
    bit 0, a 
    jr z, .input_right 
    jp .input_done

    .input_up: 
      ld a, 2 
      ld [PLAYER_DIR], a

      ld a, c 
      sub 8
      ld c, a 
      call entity.can_walk
      cp 0 
      jr nz, .input_done
      jp .input_dir_done
      

    .input_down:
      ld a, 0 
      ld [PLAYER_DIR], a
      ld a, c 
      add 8
      ld c, a 
      call entity.can_walk
      cp 0 
      jr nz, .input_done
      jp .input_dir_done

    .input_left:
      ld a, 1
      ld [PLAYER_DIR], a
      ld a, b 
      sub 16
      ld b, a 
      call entity.can_walk
      cp 0 
      jr nz, .input_done
      jp .input_dir_done

    .input_right:
      ld a, 3 
      ld [PLAYER_DIR], a
      ld a, b 
      add 16 
      ld b, a 
      call entity.can_walk
      cp 0 
      jr nz, .input_done
      ; jp .input_dir_done

    .input_dir_done: 
      ld a, 16
      ld [PLAYER_MOVING], a
    .input_done:
  ret  