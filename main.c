#include <stdio.h>
#include <stdlib.h>
#include <gb/gb.h>
#include <rand.h>
#include <time.h>

#include "helper.h"
#include "room.h"
#include "player.h"
#include "gen.h"
#include "activeroom.h"
#include "render.h"
#include "dialog.h"

#include "dialogs/welcome.h"

struct World world;
struct ActiveRoom activeRoom;
struct Player player;


void initGame()
{
		struct Room* room;
		initrand(time(NULL)+10000);
		SWITCH_ROM_MBC1(2);
		initWorld(&world);
		SWITCH_ROM_MBC1(1);
		activeRoom.room = 0x00; //"fixation" en mémoire de la pièce active, juste pour être sûr
		//sélection d'une salle au hasard
		room = &(world.rooms[random(0, world.roomsNumber)]);
		//Lancement de la matérialisation de la salle
		ActiveRoom_create(&activeRoom, room);
		player.life = 0; //"fixation" en mémoire du joueur
		player.x = 0;
		player.y = 0;
		Player_create(&player, &activeRoom);

}

void updateInput()
{
	unsigned int input;
	unsigned char i;
	input = joypad();
	if(input & J_DOWN)
	{
		Player_moveDown(&player);
	}
	else if(input & J_UP)
	{
		Player_moveUp(&player);
	}
	else if(input & J_LEFT)
	{
		Player_moveLeft(&player);
	}
	else if(input & J_RIGHT)
	{
		Player_moveRight(&player);
	}

}

void updateGame()
{
	initRender();
	clearBackground();
	drawRoom(&activeRoom);
	focusRender(player.x, player.y);
	while(1)
	{
		wait_vbl_done();

		updateInput();
		Player_update(&player);
		updateRender();
		drawPlayer(&player);
		focusRender(player.x, player.y);
	}
}


void main(void)
{
	disableDisplay();
	initGame();
	updateGame();
}
