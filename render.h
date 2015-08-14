#ifndef RENDER_H
#define RENDER_H

#include <gb/gb.h>
#include <gb/drawing.h>

#include "activeroom.h"
#include "player.h"

#include "sprites/spriteplayer.h"

#define SPRITE_PLAYER_TOPL 0
#define SPRITE_PLAYER_TOPR 1
#define SPRITE_PLAYER_BOTL 2
#define SPRITE_PLAYER_BOTR 3

unsigned int frameCounter = 0;

void initRender();

void updateRender();

void clearDisplay();

void disableDisplay();

void enableDisplay();

void loadBackground();

void loadSprites();

void drawRoom(struct ActiveRoom* active);

void drawPlayer(struct Player* player);

#endif
