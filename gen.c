#include "gen.h"

void initWorld(struct World* world)
{
  unsigned int i;

  puts("initWorld");
  world->roomsNumber = random(2, WORLD_MAX_ROOMS);
  for(i = 0; i != world->roomsNumber; i++)
  {
    Room_create(&world->rooms[i]);
    printf("room %d: %dx%d %d\n",i, world->rooms[i].width, world->rooms[i].height, world->rooms[i].sisters);
  }
  initLinks(world);
}

void initLinks(struct World* world)
{
  unsigned int i;
  unsigned int done = false;
  unsigned int first;
  unsigned int second;

  puts("initLinks");
  while(done == false)
  {
    first = random(0, world->roomsNumber);
    second = random(0, world->roomsNumber);
    if(world->rooms[first].sisters != 4 && world->rooms[second].sisters != 4)
    {
      Room_addDoor(&world->rooms[first], second);
      Room_addDoor(&world->rooms[second], first);
      printf("linked %d and %d\n", first, second);
    }

  }
}

void initBiomes(struct World* world)
{

}

void initPlayer(struct World* world)
{

}
