#include "main.h"

void main()
{
	init();
	DISPLAY_OFF;
	disable_interrupts();
	SPRITES_8x8;
	HIDE_SPRITES;
	HIDE_BKG;
	HIDE_WIN;
	init_graphics();
	SHOW_SPRITES;
	SHOW_BKG;
	SHOW_WIN;
	enable_interrupts();
	DISPLAY_ON;
	init_dungeon();
	//boucle de jeu
	while(1)
	{

	}
}

void init_dungeon()
{
	unsigned char i;
	dungeon_roomNumber = random(2, DUNGEON_MAX_ROOMS);
	for(i = 0; i != dungeon_roomNumber; i++)
	{
		//fixation des valeurs en mémoire
		/*dungeon_rooms[i].width = 12;
		dungeon_rooms[i].height = 12;
		dungeon_rooms[i].sisters = 12;
		for(u = 0; u!=4; u++)
		{
			world->rooms[i].doorPos[u] = -1;
			world->rooms[i].doorTar[u] = -1;
		}*/
		Room_create(&dungeon_rooms[i], i);
	}
}

void init()
{
	//initialisation de l'aléatoire
	UWORD seed;
	seed = DIV_REG;
	wait_vbl_done();
	seed |= (UWORD)DIV_REG << 8;
	initrand(seed);
}

void init_graphics()
{
	//loading sprites
	SWITCH_ROM_MBC1(3);
	set_sprite_data(0,14,spriteplayer);
	set_sprite_data(14,14,spriteblob);
	//loading tilesets
	set_bkg_data(0,13,tileset);
	//chargement de la police
	set_win_data(0x80, 43, font);
}
