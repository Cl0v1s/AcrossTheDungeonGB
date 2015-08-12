#include "room.h"

void Room_create(struct Room* room)
{
	//détermination de la taille de la salle
	room->width = random(ROOM_MIN_SIDE, ROOM_MAX_SIDE);
	room->height = random(ROOM_MIN_SIDE, ROOM_MAX_SIDE);
	//initialisation du nombre de soeurs
	room->sistersNumber = 0;
}

unsigned int Room_putDoor(struct Room* room, const unsigned int sister)
{
	unsigned int max = room->width;
	if(room->sistersNumber==4)
		return false;
	if(room->sistersNumber != 2 && room->sistersNumber != 0)
	{
		max = room->height;
	}
	room->doorsPos[room->sistersNumber] = random(2, max - 2);
	room->doorsTar[room->sistersNumber] = sister;
	room->sistersNumber++;
}

unsigned int Room_doorAvailable(struct Room* room)
{
	if(room->sistersNumber ==4)
		return false;
	return true;
}

unsigned int Room_areAllRoomsLinked(struct Room *room, const unsigned int number)
{

	unsigned int good = true;
	unsigned int i = 0;
	while(i != number && good == true)
	{
		if(room->sistersNumber == 0)
			good = false;
		i++;
		room++;
	}
	return good;
}
