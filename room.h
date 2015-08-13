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
	unsigned int sisters;
	int doorPos[4];
	int doorTar[4];
};

void Room_create(struct Room* room);

void Room_addDoor(struct Room* room, const unsigned int other);


#endif
