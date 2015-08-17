#ifndef ACTIVEROOM_H
#define ACTIVEROOM_H

#include "room.h"
#include "cell.h"

struct ActiveRoom
{
  struct Room* room;
  unsigned char map[ROOM_MAX_SIDE*ROOM_MAX_SIDE];
};

void ActiveRoom_create(struct ActiveRoom* active, struct Room* room);
unsigned char ActiveRoom_isCellPassable(struct ActiveRoom* active, const unsigned char x, const unsigned char y);




#endif
