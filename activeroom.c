#include "activeroom.h"

void ActiveRoom_create(struct ActiveRoom* active, struct Room* room)
{
  int h = room->height;
  unsigned int i,u;
  unsigned int cell;
  //affectation de la salle de base
  active->room = room;
  //TODO: ajouter ici le code relatif aux biomes
  //initialisation primaire de la salle
  for(i = 0; i != room->width; i++)
  {
    for(u = 0; u != room->height; u++)
    {
      cell = CELL_GROUND;
      if(u == 0 || i == 0 || i == room->width -1 )
      {
        cell = CELL_WALL;
      }
      active->map[i+u*room->width] = cell;
    }
  }
  //WTF: repassage suite à une bug etrange relatif à u et room->height
  h = h - 1;
  for(i = 0; i != room->width; i++)
  {
    active->map[i+h*room->width] = CELL_WALL;
  }
}

unsigned int ActiveRoom_isCellPassable(struct ActiveRoom* active, const unsigned int x, const unsigned int y)
{
  unsigned int r = active->map[x+y*active->room->width] >> 7;
  if(r == 1)
    return false;
  else
    return true;
}
