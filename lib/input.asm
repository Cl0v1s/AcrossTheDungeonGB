input:

.listen_directions:
  ld a, $FF
  res 4, a
  ld [JOYPAD], a
  ld a, [JOYPAD]
  ld a, [JOYPAD]
  ret

.listen_actions:
  ld a, $FF
  res 5, a
  ld [JOYPAD], a
  ld a, [JOYPAD]
  ld a, [JOYPAD]
  ret

.reset 
  ld a, $FF
  ld [JOYPAD],a 
  ret 