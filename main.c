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

struct World world;
struct ActiveRoom activeRoom;


void initGame()
{
		initrand(time(NULL)+10000);
		initWorld(&world);
		initActiveRoom(&world, &activeRoom);
		puts("done.");
}


void main(void)
{
	initGame();
}
