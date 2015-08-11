#ifndef ROOM_H
#define ROOM_H

#include <stdlib.h>
#include <rand.h>

#include "const.h"
#include "cell.h"

typedef struct
{
	unsigned int width;
	unsigned int height;

	unsigned int map[ROOM_MAX_SIDE][ROOM_MAX_SIDE];
	unsigned int sistersNumber;
} Room;

void Room_create(Room *room);
const unsigned int Room_putDoor(Room *room, const unsigned int sister);
const unsigned int Room_getCellAt(Room *room, const unsigned int x, const unsigned int y);
const int Room_isCellPassableAt(Room *room, const unsigned int x, const unsigned int y);
const unsigned int Room_areAllRoomsLinked(Room *room, const unsigned int roomsNumber);


#endif
