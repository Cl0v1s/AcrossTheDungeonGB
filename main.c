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

struct World world;
struct ActiveRoom activeRoom;
struct Player player;


void initGame()
{
		initrand(time(NULL)+10000);
		initWorld(&world);
		activeRoom.room = 0x00; //"fixation" en mémoire de la pièce active, juste pour être sûr
		initActiveRoom(&world, &activeRoom);
		delay(1500);
		player.life = 0; //"fixation" en mémoire du joueur
		Player_create(&player, &activeRoom);

}

void updateInput()
{
	unsigned int input;
	input = joypad();
	if(input & J_DOWN)
	{
		if(Player_moveDown(&player) == true)
			moveCanvas(0,PLAYER_MOVING_SPEED);
	}
	else if(input & J_UP)
	{
		if(Player_moveUp(&player) == true)
			moveCanvas(0,-PLAYER_MOVING_SPEED);
	}
	else if(input & J_LEFT)
	{
		if(Player_moveLeft(&player) == true)
			moveCanvas(-PLAYER_MOVING_SPEED,0);
	}
	else if(input & J_RIGHT)
	{
		if(Player_moveRight(&player) == true)
			moveCanvas(PLAYER_MOVING_SPEED,0);
	}
}

void updateGame()
{
	int a = 102;
	initRender();
	clearBackground();
	drawRoom(&activeRoom);
	focusRender(player.x, player.y);
	drawInt(0,0, a);
	//drawText(0,0,"hehe ! je suis un   beau sprite non ?");
	while(1)
	{
		wait_vbl_done();

			updateInput();
			updateRender();
			drawPlayer(&player);

	}
}


void main(void)
{
	disableDisplay();
	initGame();
	updateGame();
}
