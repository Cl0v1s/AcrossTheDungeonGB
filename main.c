#include <stdio.h>
#include <stdlib.h>
#include <gb/gb.h>
#include <rand.h>
#include <time.h>
#include "sound.h"

#include "helper.h"
#include "room.h"
#include "entity.h"
#include "gen.h"
#include "activeroom.h"
#include "render.h"
#include "dialog.h"

#include "dialogs/welcome.h"

struct World world;
struct ActiveRoom activeRoom;
struct Entity player;


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
		player.spriteId = 0;
		Entity_create(&player, &activeRoom);

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


void manageTp()
{

	struct Room* room;
	unsigned char last;
	unsigned char tmp[2];
	unsigned char size[2];
	if(activeRoom.markedForTpTo != -1)
	{
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


		wait_vbl_done();
		clearBackground();
		drawRoom(&activeRoom);
		updateHud();
	}
}

void updateGame()
{
	initRender();
	clearBackground();
	drawRoom(&activeRoom);
	focusRender(player.x, player.y);

	updateHud();
	while(1)
	{
		wait_vbl_done();
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
