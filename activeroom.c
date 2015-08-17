#include "activeroom.h"

void ActiveRoom_create(struct ActiveRoom* active, struct Room* room)
{
  unsigned int i,u;
  unsigned int cell;
  unsigned int height = room->height; //utilisation d'une variable intermdiaire suite à un bug étrange
  height -= 1;
  //affectation de la salle de base
  active->room = room;
  //TODO: ajouter ici le code relatif aux biomes
  //initialisation primaire de la salle
  for(i = 0; i != room->width; i++)
  {
    for(u = 0; u != room->height+1; u++) //on va plus loin pour corriger un bug étrange
    {
      cell = CELL_GROUND;
      if(u == 0 || i == 0 || i == room->width -1 || u == height)
      {
        cell = CELL_WALL;
      }
      active->map[i+u*room->width] = cell;
    }
  }

}

unsigned char ActiveRoom_isCellPassable(struct ActiveRoom* active, const unsigned char x, const unsigned char y)
{
  unsigned char* q = 0xDEA0;
  unsigned char r = active->map[x+y*active->room->width] >> 7;

  if(r == 1)
    return false;
  else
    return true;
}
