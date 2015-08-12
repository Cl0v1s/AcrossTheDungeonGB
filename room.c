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
/*
	unsigned int x = 0;
	unsigned int y = 0;
	if(room->sistersNumber>4)
		return false;
	switch(room->sistersNumber)
	{
		case 0:	//mur de gauche
			y = rand()%(room->height-4)+2;
		break;
		case 1:	//mur du haut
			x = rand()%(room->width-4)+2;
		break;
		case 2: //mur de droite
			x = room->width;
			y = rand()%(room->height-4)+2;
		break;
		case 3:	//mur du bas
			x = rand()%(room->width-4)+2;
			y = room->height;
		break;
	}
	//placement de la porte
	room->map[x][y] = CELL_DOOR + sister;
	room->sistersNumber += 1;
	return true;*/
}

unsigned int Room_areAllRoomsLinked(struct Room *room, const unsigned int roomsNumber)
{
	/*
	unsigned int good = true;
	unsigned int i = 0;
	while(i<roomsNumber && good == true)
	{
		if((room+i)->sistersNumber > 0)
			good = false;
	}
	return good;*/
}
