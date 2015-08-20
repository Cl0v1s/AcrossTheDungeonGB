#ifndef ACTIVEROOM_H
#define ACTIVEROOM_H

#include "room.h"
#include "cell.h"
#include "entitiesmanager.h"

struct ActiveRoom
{
  struct Room* room;
  unsigned char map[ROOM_MAX_SIDE*ROOM_MAX_SIDE];
  char markedForTpTo;
};

void ActiveRoom_create(struct ActiveRoom* active, struct Room* room);
unsigned char ActiveRoom_getId(struct ActiveRoom* active);
unsigned char ActiveRoom_isCellPassable(struct ActiveRoom* active, const unsigned char x, const unsigned char y);
unsigned char ActiveRoom_getCellAt(struct ActiveRoom* active, const unsigned char x, const unsigned char y);
void ActiveRoom_getDoorTo(struct ActiveRoom* active, unsigned char room, unsigned char* tab);
void ActiveRoom_getSize(struct ActiveRoom* active, unsigned char* tab);

unsigned char ActiveRoom_getEntitiesType(struct ActiveRoom* active);
unsigned char ActiveRoom_getEntityNumber(struct ActiveRoom* active);



#endif
