#include "room.h"

void Room_create(Room *room)
{
	unsigned int width = rand() % (ROOM_MAX_SIDE - ROOM_MIN_SIDE) + ROOM_MIN_SIDE;
	unsigned int height = rand() % (ROOM_MAX_SIDE - ROOM_MIN_SIDE) + ROOM_MIN_SIDE;
	unsigned int i = 0;
	unsigned int u = 0;
	room->width = width;
	room->height = height;
	for(i = 0; i< room->width; i++)
	{
		for(u = 0; u<room->height; u++)
		{
			room->map[i][u] = CELL_EMPTY;
			room->map[0][u] = CELL_WALL;
			room->map[width][u] = CELL_WALL;
			room->map[i][0] = CELL_WALL;
			room->map[i][height] = CELL_WALL;		
		}
	}
	room->sistersNumber = 0;
}

const unsigned int Room_putDoor(Room *room, const unsigned int sister)
{

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
	return true;
}

const unsigned int Room_getCellAt(Room* room, const unsigned int x, const unsigned int y)
{
	return room->map[x][y];
}

const int Room_isCellPassableAt(Room *room, const unsigned int x, const unsigned int y)
{
	int v = room->map[x][y];
	if(v < 128)
		return 0;
	return 1;
}

const unsigned int Room_areAllRoomsLinked(Room *room, const unsigned int roomsNumber)
{
	unsigned int good = true;
	unsigned int i = 0;
	while(i<roomsNumber && good == true)
	{
		if((room+i)->sistersNumber > 0)
			good = false;
	}
	return good;
}







