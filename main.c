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
		Player_create(&player, &activeRoom);
		puts("done.");
}

void updateGame()
{
	clearDisplay();
	initRender();
	while(1)
	{
		updateRender();
		
		drawPlayer(&player);
		delay(15);
	}
}


void main(void)
{
	disableDisplay();
	initGame();
	enableDisplay();
	updateGame();
}
