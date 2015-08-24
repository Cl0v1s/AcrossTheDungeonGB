#ifndef HELPER_H
#define HELPER_H

#include <rand.h>

//définition de true et false (non prit en charge par c)
#define true 1
#define false 0

//Définition des variables harware
#define HARDWARE_WIDTH 160
#define HARDWARE_HEIGHT 140

//définition du coté maximum d'une salle
#define ROOM_MAX_SIDE 12
#define ROOM_MIN_SIDE 6
#define ROOM_MAX_ENTITIES 4

//définition du nombre maximum de salles par étage
#define DUNGEON_MAX_ROOMS 10

//déifinition des stats de base du joueur
#define PLAYER_INIT_LIFE 20
#define PLAYER_MOVING_SPEED 2

//définitions des informations relatives aux entités
#define ENTITY_TYPE_NUMBER 1


//définition des fonctions usuelles
unsigned char random(const unsigned int min, const unsigned int max);


#endif
