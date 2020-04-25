input:

.listen_directions:
  ld a, [JOYPAD]
  set 5, a
  res 4, a
  ld [JOYPAD], a
  ret