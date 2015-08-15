#ifndef RENDER_H
#define RENDER_H

#include <gb/gb.h>
#include <gb/drawing.h>

#include "activeroom.h"
#include "player.h"
#include "cell.h"

#include "sprites/spriteplayer.h"
#include "sprites/tileset.h"

#define SPRITE_PLAYER_TOPL 0
#define SPRITE_PLAYER_TOPR 1
#define SPRITE_PLAYER_BOTL 2
#define SPRITE_PLAYER_BOTR 3

unsigned int canvasX = 0;
unsigned int canvasY = 0;
unsigned int frameCounter = 0;

void initRender();

void updateRender();

void moveCanvas(const unsigned int x, const unsigned int y);

void setCanvasPos(const unsigned int x, const unsigned int y);

void clearDisplay();

void disableDisplay();

void enableDisplay();

void focusRender(const unsigned int x, const unsigned int y);

void loadBackground();

void loadSprites();

void drawRoom(struct ActiveRoom* active);

void drawPlayer(struct Player* player);

#endif
