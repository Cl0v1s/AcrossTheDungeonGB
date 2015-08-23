#ifndef ROOM_H
#define ROOM_H

#include "cell.h"

struct Room
{
	unsigned char width;
	unsigned char height;
	unsigned char sisters;
	char doorPos[4];
	char doorTar[4];
	unsigned char id;
	unsigned char entitiesNumber;
	unsigned char entitiesType;
};

void Room_create(struct Room* room, unsigned char id);
void Room_addDoor(struct Room* room, const unsigned char other);



#endif
