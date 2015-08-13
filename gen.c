#include "gen.h"

void initWorld(struct World* world)
{
  unsigned int i;

  puts("initWorld");
  world->roomsNumber =random(2, WORLD_MAX_ROOMS);
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

void initActiveRoom(struct World* world, struct ActiveRoom* active)
{
  //sélection d'une salle au hasard
  struct Room* room = &(world->rooms[random(0, world->roomsNumber)]);
  puts("initActiveRoom");
  //Lancement de la matérialisation de la salle
  ActiveRoom_create(active, room);
}
