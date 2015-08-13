#ifndef HELPER_H
#define HELPER_H

#include <rand.h>

//définition de true et false (non prit en charge par c)
#define true 1
#define false 0

//définition du coté maximum d'une salle
#define ROOM_MAX_SIDE 19
#define ROOM_MIN_SIDE 5

//définition du nombre maximum de salles par étage
#define WORLD_MAX_ROOMS 10


//définition des fonctions usuelles
unsigned int random(const unsigned int min, const unsigned int max);

#endif
