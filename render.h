#ifndef RENDER_H
#define RENDER_H

#include <gb/gb.h>
#include <gb/drawing.h>

#include "activeroom.h"
#include "entities/entity.h"
#include "cell.h"

#include "sprites/spriteplayer.h"
#include "sprites/spriteblob.h"
#include "sprites/tileset.h"

unsigned int canvasX = 0;
unsigned int canvasY = 0;

void initRender();

void updateRender();

void moveCanvas(const unsigned int x, const unsigned int y);

void setCanvasPos(const unsigned int x, const unsigned int y);

void clearBackground();

void clearWindow();

void disableDisplay();

void enableDisplay();

void focusRender(const unsigned int x, const unsigned int y);

void loadBackground();

void loadSprites();

void loadFont();

void drawText(const unsigned int x, const unsigned int y, char* text);

void drawInt(const unsigned int x, const unsigned int y, int val);

void drawRoom(struct ActiveRoom* active);

void drawEntity(struct Entity* entity);

#endif
