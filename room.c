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
}

void Room_addDoor(struct Room* room, const unsigned int other)
{
	if(room->sisters & 0x1 == 0)
	{
		room->doorPos[room->sisters] = random(2, room->width-2);
	}
	else
		room->doorPos[room->sisters] = random(2, room->height - 2);

	room->doorTar[room->sisters] = other;
	room->sisters = room->sisters + 1;
}
