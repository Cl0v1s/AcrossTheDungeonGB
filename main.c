#include <stdio.h>
#include <stdlib.h>
#include <gb/gb.h>
#include <rand.h>
#include <time.h>

#include "const.h"
#include "room.h"
#include "player.h"

typedef Room Rooms[WORLD_MAX_ROOMS];
Rooms world;
unsigned int roomsNumber = 0;
Room *current_room;
Player player;


void initWorld()
{
	//déclartationdu cdompteur de salle
	unsigned int i = 0;
	//déclaration des variables de couple utilisé pour les portes
	unsigned int first = rand()%roomsNumber;
	unsigned int second = rand()%roomsNumber;
	//nombre de salles
	roomsNumber = rand() % (WORLD_MAX_ROOMS -1) +1;



	//génération primaire des salles

	for(i = 0; i< roomsNumber; i++)
	{
		Room_create(&world[i]);
	};
	//génération des portes
	while(Room_areAllRoomsLinked(&world[0], roomsNumber) == false)
	{
		//récupération d'un couple de salles
		while(first == second || Room_putDoor(&world[first], second) == false)
		{
			first = rand()%roomsNumber;
		};
		Room_putDoor(&world[second], first);
	}
	//séléction de la salle courante
	current_room = &world[rand()%roomsNumber];
}

void initGame()
{
	initarand(time(NULL));
	//création du monde 
	initWorld();
}


void initPlayer()
{

}

void playgame()
{


}

void main(void)
{
	puts("starting Game...");
	disable_interrupts();
  	DISPLAY_OFF;
	initGame();
	enable_interrupts();
	DISPLAY_ON;
	playgame();

}
