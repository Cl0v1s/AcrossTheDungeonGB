#ifndef RENDER_H
#define RENDER_H

#include <gb/gb.h>

#include "helper.h"
#include "activeroom.h"
#include "entities/entity.h"

unsigned char register_sprite();
void focus_canvas(unsigned char x, unsigned char y);
void draw_room(struct ActiveRoom* active);
void draw_entity(struct Entity* entity);
void draw_int(unsigned char x, unsigned char y, char val);
void clear_bkg();
void clear_sprites();

#endif
