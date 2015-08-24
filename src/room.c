#include "room.h"

void Room_create(struct Room* room, unsigned char id)
{
	unsigned int i;
	//détermination de la taille de la salle
	room->width = random(ROOM_MIN_SIDE, ROOM_MAX_SIDE);
	room->height = random(ROOM_MIN_SIDE, ROOM_MAX_SIDE);
	room->sisters = 0;
	for(i = 0; i!=4; i++)
	{
		room->doorPos[i] = -1;
		room->doorTar[i] = -1;
	}
	room->id = id;
	room->entitiesNumber = random(0, ROOM_MAX_ENTITIES);
	room->entitiesNumber = random(0, ROOM_MAX_ENTITIES);
	room->entitiesType = random(1, ENTITY_TYPE_NUMBER+1);
}

void Room_addDoor(struct Room* room, const unsigned char other)
{
	unsigned char order = random(0,4);
	while(room->doorPos[order] != -1)
		order = random(0,4);
	if(order & 0x1 == 0)
	{
		room->doorPos[order] = random(2, room->width-2);
	}
	else
		room->doorPos[order] = random(2, room->height - 2);

	room->doorTar[order] = other;
	room->sisters = room->sisters + 1;
}
