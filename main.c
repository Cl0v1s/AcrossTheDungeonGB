#include <stdio.h>
#include <stdlib.h>
#include <gb/gb.h>
#include <rand.h>

#include "helper.h"
#include "room.h"
#include "player.h"

typedef struct Room Rooms[10];
Rooms world;
unsigned int roomsNumber = 0;
struct Room* current_room;
struct Player player;

void initWorld()
{

	//déclartationdu cdompteur de salle
	unsigned int i = 0;
	//déclaration des variables de couple utilisé pour les portes
	unsigned int first;
	unsigned int second;
	//nombre de salles
	roomsNumber = random(2, WORLD_MAX_ROOMS);

	printf("Generating %d rooms\n", roomsNumber);

	//génération primaire des salles
	for(i = 0; i != roomsNumber; i++)
	{
		Room_create(&world[i]);
	};

	//génération des portes
	while(Room_areAllRoomsLinked(&world[0], roomsNumber) == false)
	{
		//récupération d'un couple de salles
		first = rand()%roomsNumber;
		second = rand()%roomsNumber;
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
	initrand(1000000);
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
	initGame();
	enable_interrupts();
	DISPLAY_ON;
	playgame();

}
