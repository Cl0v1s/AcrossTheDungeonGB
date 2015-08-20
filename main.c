#include <stdio.h>
#include <stdlib.h>
#include <gb/gb.h>
#include <rand.h>
#include <time.h>
#include "sound.h"

#include "helper.h"
#include "room.h"
#include "gen.h"
#include "activeroom.h"
#include "render.h"
#include "dialog.h"

#include "dialogs/welcome.h"

#include "entities/entity.h"
#include "entities/player.h"
#include "entities/blob.h"


typedef struct Entity Entities[ROOM_MAX_ENTITIES];

struct World world;
struct ActiveRoom activeRoom;
struct Entity player;
Entities entities;


void initGame()
{
		struct Room* room;
		initrand(time(NULL));
		SWITCH_ROM_MBC1(2);
		initWorld(&world);
		SWITCH_ROM_MBC1(1);
		activeRoom.room = 0x00; //"fixation" en mémoire de la pièce active, juste pour être sûr
		//sélection d'une salle au hasard
		room = &(world.rooms[random(0, world.roomsNumber)]);
		//Lancement de la matérialisation de la salle
		ActiveRoom_create(&activeRoom, room);
		Player_create(&player, &activeRoom);
		player.spriteNumber = registerSprite();

}

void updateInput()
{
	unsigned int input;
	unsigned char i;
	input = joypad();
	if(input & J_DOWN)
	{
		Entity_moveDown(&player);
	}
	else if(input & J_UP)
	{
		Entity_moveUp(&player);
	}
	else if(input & J_LEFT)
	{
		Entity_moveLeft(&player);
	}
	else if(input & J_RIGHT)
	{
		Entity_moveRight(&player);
	}

}

void updateHud()
{
	drawText(12,2,"salle:");
	drawInt(18,2, ActiveRoom_getId(&activeRoom));
}

void populateActiveRoom()
{
	unsigned char type = ActiveRoom_getEntitiesType(&activeRoom);
	unsigned char number = ActiveRoom_getEntityNumber(&activeRoom);
	unsigned char i = 0;
	for(i = 0; i!=number; i++)
	{
		if(type == 1)
		{
			Blob_create(&entities[i], &activeRoom);
			entities[i].spriteNumber = registerSprite();
		}
	}
}


void manageTp()
{

	struct Room* room;
	unsigned char last;
	unsigned char tmp[2];
	unsigned char size[2];
	if(activeRoom.markedForTpTo != -1)
	{
		clearSprites();
		last = ActiveRoom_getId(&activeRoom);
		room = &world.rooms[activeRoom.markedForTpTo];
		ActiveRoom_create(&activeRoom, room);
		ActiveRoom_getDoorTo(&activeRoom, last, tmp);
		//mise à jour de la position du joueur
		ActiveRoom_getSize(&activeRoom, size);
		if(tmp[1] == 1)
			player.dir = 0;
		else if(tmp[0] == 1)
			player.dir = 1;
		else if(tmp[1] + 2 == size[1])
			player.dir = 2;
		else if(tmp[0] + 2 == size[0])
			player.dir = 3;

		player.x = tmp[0] << 4;
		player.y = tmp[1] << 4;
		player.spriteNumber = registerSprite();

		populateActiveRoom();

		wait_vbl_done();
		clearBackground();
		drawRoom(&activeRoom);
		updateHud();
	}
}

void updateGame()
{
	unsigned char entitiesNumber;
	unsigned char i = 0;
	initRender();
	clearBackground();
	drawRoom(&activeRoom);
	focusRender(player.x, player.y);

	updateHud();
	while(1)
	{
		wait_vbl_done();
		entitiesNumber = ActiveRoom_getEntityNumber(&activeRoom);
		for(i = 0; i != entitiesNumber; i++)
		{
			Entity_update(&entities[i]);
			drawEntity(&entities[i]);
		}


		manageTp();
		updateInput();
		Entity_update(&player);
		updateRender();
		drawEntity(&player);
		focusRender(player.x, player.y);
	}
}


void main(void)
{
	SOUND_ON;
	disableDisplay();
	initGame();
	updateGame();
}
