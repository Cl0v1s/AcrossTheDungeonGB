#include <stdio.h>
#include <stdlib.h>
#include <gb/gb.h>
#include <rand.h>
#include <time.h>

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
	printf("generating %d rooms\n", roomsNumber);
	//génération primaire des salles
	for(i = 0; i != roomsNumber; i++)
	{
		Room_create(&world[i]);
	};
	//génération des portes
	puts("generating doors");
	while(Room_areAllRoomsLinked(&world[0], roomsNumber) == false)
	{
		//récupération d'un couple de salles
		first = random(0,roomsNumber-1);
		second = random(0, roomsNumber-1);
		while(first == second || Room_doorAvailable(&world[first]) == false || Room_doorAvailable(&world[second]) == false)
		{
			first = random(0,roomsNumber-1);
			second = random(0, roomsNumber-1);
			printf("trying %d and %d.\n", first, second);

		};
		Room_putDoor(&world[first], second);
		Room_putDoor(&world[second], first);
		printf("%d and %d linked.\n", first, second);
	}
	//séléction de la salle courante
	current_room = &world[rand()%roomsNumber];
}

void initGame()
{
	int tps = time(NULL);
	initrand(tps+100000);
	//création du monde
	printf("generating world...\n");
	initWorld();
	printf("done.\n%d rooms created.", roomsNumber);
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
