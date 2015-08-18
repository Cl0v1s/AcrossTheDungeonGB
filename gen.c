#include "gen.h"

void initWorld(struct World* world)
{
  unsigned int i,u;
  world->roomsNumber =random(2, WORLD_MAX_ROOMS);
  for(i = 0; i != world->roomsNumber; i++)
  {
    //déclaration explicite pour éviter un bug de déférancement
    world->rooms[i].width = 12;
    world->rooms[i].height = 12;
    world->rooms[i].sisters = 12;
    for(u = 0; u!=4; u++)
  	{
  		world->rooms[i].doorPos[u] = -1;
  		world->rooms[i].doorTar[u] = -1;
  	}
    Room_create(&world->rooms[i]);
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
      try -= 50;
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
    //si on a du arreter, on recommence la génération
    initWorld(world);
  }
  else
  {
    //sinon on continue
    initBiomes(world);
  }


}

void initBiomes(struct World* world)
{

}
