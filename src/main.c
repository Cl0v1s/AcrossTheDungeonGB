#include "main.h"

void main()
{
	unsigned char keys;
	init();
	DISPLAY_OFF;
	disable_interrupts();
	SPRITES_8x8;
	HIDE_SPRITES;
	HIDE_BKG;
	HIDE_WIN;
	clear_bkg();
	//initialisation de l'affichage
	init_graphics();
	//génération du donjon
	init_dungeon();
	//affichage de la salle actuelle
	draw_room(&activeRoom);
	SHOW_SPRITES;
	SHOW_BKG;
	SHOW_WIN;
	enable_interrupts();
	DISPLAY_ON;
	//boucle de jeu
	while(1)
	{
		wait_vbl_done();
		//gestion des entrées
		keys = joypad();
		if(keys & J_DOWN)
			Entity_moveDown(&player);
		else if(keys & J_UP)
			Entity_moveUp(&player);
		else if(keys & J_RIGHT)
			Entity_moveRight(&player);
		else if(keys & J_LEFT)
			Entity_moveLeft(&player);

		//mise à jour du joueur
		Entity_update(&player);
		//déplacement du canvas sur le joueur
		focus_canvas(player.x, player.y);
		//déssin du joueur
		draw_entity(&player);
		//procédure de changement de salle
		manage_tp();
	}
}

void manage_tp()
{
	struct Room* room;
	unsigned char last;
	unsigned char pos[2];
	if(activeRoom.markedForTpTo != -1)
	{
		DISPLAY_OFF;
		disable_interrupts();
		clear_bkg();
		//récupération de l'id de la salle que le joueur quitte
		last=ActiveRoom_getId(&activeRoom);
		//generation de la nouvelle salle active
		room = &dungeon_rooms[activeRoom.markedForTpTo];
		ActiveRoom_create(&activeRoom, room);
		//positionnement du joueur
		ActiveRoom_getDoorTo(&activeRoom, last, pos);
		if(pos[0] == 1)
			player.dir = 1;
		else if(pos[0] == (activeRoom.room->width-1))
			player.dir = 3;
		if(pos[1] == 1)
			player.dir = 0;
		else if(pos[1] == (activeRoom.room->height-1))
			player.dir = 2;
		player.x = pos[0] << 4;player.y = pos[1] << 4;
		//dessin de la nouvelle salle
		draw_room(&activeRoom);
		//effacement des sprites
		clear_sprites();
		//réenregistrement du joueur
		player.spriteNumber = register_sprite();
		enable_interrupts();
		DISPLAY_ON;
	}
}

void init_dungeon()
{
	unsigned char i;
  unsigned int done = false;
  unsigned int first;
  unsigned int second;
  unsigned int try = 0;
	struct Room* room;
	//génération des salles
	dungeon_roomNumber = random(2, DUNGEON_MAX_ROOMS);
	for(i = 0; i != dungeon_roomNumber; i++)
	{
		Room_create(&dungeon_rooms[i], i);
	}
	//génération des liens etre les salles
  while(done == false && try != 150)
  {
    try++;
    first = random(0, dungeon_roomNumber);
    second = random(0, dungeon_roomNumber);
    if(dungeon_rooms[first].sisters != 4 && dungeon_rooms[second].sisters != 4 && first !=  second)
    {
      Room_addDoor(&dungeon_rooms[first], second);
      Room_addDoor(&dungeon_rooms[second], first);
      try = 0;
    }
    i = 0;
    done = true;
    while(i != dungeon_roomNumber && done ==true)
    {
      if(dungeon_rooms[i].sisters == 0)
        done = false;
      i++;
    }
  }
  //vérification des liens
  if(try == 150)
  {
    //si on a du arreter, on recommence la génération
    init_dungeon();
  }
	//TODO: ajouter ici la génération des biomes

	//création de la salle active
	room = &dungeon_rooms[random(0,dungeon_roomNumber)];
	ActiveRoom_create(&activeRoom, room);
	//création du joueur
	Player_create(&player, &activeRoom);
	player.spriteNumber = register_sprite();
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
	//déplacement du HUD
	move_win(7,120);
}
