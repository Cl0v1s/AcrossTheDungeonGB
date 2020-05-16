input:

.listen_directions:
  ld a, [JOYPAD]
  set 5, a
  res 4, a
  ld [JOYPAD], a
  ret

.listen_actions:
  ld a, [JOYPAD]
  set 4, a
  res 5, a
  ld [JOYPAD], a
  ret