#include <gb/gb.h>
#include <rand.h>
#include <stdio.h>

#include "helper.h"
#include "room.h"


//inclusion des ressources graphiques
//police
#include "data/font/font.h"
//tilesets
#include "data/tilesets/tileset.h"
//sprites
#include "data/sprites/spriteplayer.h"
#include "data/sprites/spriteblob.h"

typedef struct Room Rooms[DUNGEON_MAX_ROOMS];

struct ActiveRoom activeRoom;
struct Entity player;

//définition des variables relatives à la structure du donjon
Rooms dungeon_rooms;
unsigned char dungeon_roomNumber;

void main();
void init();
void init_graphics();
void init_dungeon();
