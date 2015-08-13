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
  unsigned int try = 0;

  puts("initLinks");
  //génération primaire des liens
  while(done == false && try != 150)
  {
    try++;
    first = random(0, world->roomsNumber);
    second = random(0, world->roomsNumber);
    if(world->rooms[first].sisters != 4 && world->rooms[second].sisters != 4)
    {
      Room_addDoor(&world->rooms[first], second);
      Room_addDoor(&world->rooms[second], first);
      printf("linked %d and %d\n", first, second);
      try = 0;
    }
    i = 0;
    done = true;
    while(i != world->roomsNumber && done ==true)
    {
      if(world->rooms[i].sisters == 0)
        done = false;
      i++;
    }
  }
  //vérification des liens
  if(try == 150)
  {
    for(i = 0; i != world->roomsNumber; i++)
    {
      //si on trouve une pièce non reliée
      if(world->rooms[i].sisters == 0)
      {
        //alors on la relie de force
        try = 0;
        while(try != world->roomsNumber && try != 100)
        {
          if(try != i && world->rooms[try].sisters != 0 && world->rooms[try].sisters != 4)
          {
            Room_addDoor(&world->rooms[i], try);
            Room_addDoor(&world->rooms[try], i);
            printf("flinked %d and %d\n", first, second);
            try = 100;
          }
          try++;
        }
        if(try != 100) //si on arrive pas à la relier de force on recommence la génération de 0
        {
          i = world->roomsNumber;
          initWorld(world);
        }
      }
    }
  }



}

void initBiomes(struct World* world)
{

}

void initPlayer(struct World* world)
{

}
