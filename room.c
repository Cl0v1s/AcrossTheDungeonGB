#include "room.h"

void Room_create(struct Room* room)
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
}

void Room_addDoor(struct Room* room, const unsigned int other)
{
	if(room->sisters%2 == 0)
	{
		room->doorPos[room->sisters] = random(2, room->width-2);
	}
	else
		room->doorPos[room->sisters] = random(2, room->height - 2);

	room->doorTar[room->sisters] = other;
	room->sisters = room->sisters + 1;
}
