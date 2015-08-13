#ifndef GEN_H
#define GEN_H

#include "room.h"
#include "helper.h"

typedef struct Room Rooms[WORLD_MAX_ROOMS];

struct World
{
  Rooms rooms;
  unsigned int roomsNumber;
};

void initWorld(struct World* world);
void initLinks(struct World* world);
void initBiomes(struct World* world);
void initPlayer(struct World* world);

#endif
