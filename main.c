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
		initActiveRoom(&world, &activeRoom);
		delay(1500);
		Player_create(&player, &activeRoom);
}

void updateInput()
{
	unsigned int input;
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
	clearDisplay();
	initRender();
	wait_vbl_done();
	drawRoom(&activeRoom);
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
	enableDisplay();
	updateGame();
}
