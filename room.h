#ifndef ROOM_H
#define ROOM_H

#include <stdlib.h>
#include <stdio.h>
#include <rand.h>
#include <gb/gb.h>
#include <types.h>

#include "helper.h"
#include "cell.h"

struct Room
{
	unsigned int width;
	unsigned int height;
	unsigned int doorsPos[4];
	unsigned int doorsTar[4];
	unsigned int sistersNumber;
};

void Room_create(struct Room* room);
unsigned int Room_putDoor(struct Room* room, const unsigned int sister);
unsigned int Room_doorAvailable(struct Room* room);
unsigned int Room_areAllRoomsLinked(struct Room* room, const unsigned int number);


#endif
