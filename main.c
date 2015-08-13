#include <stdio.h>
#include <stdlib.h>
#include <gb/gb.h>
#include <rand.h>
#include <time.h>

#include "helper.h"
#include "room.h"
#include "player.h"
#include "gen.h"

struct World world;

void initGame()
{
		initrand(time(NULL)+10000);
		initWorld(&world);
		puts("done.");
}


void main(void)
{
	initGame();
}
