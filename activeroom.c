#include "activeroom.h"

void ActiveRoom_create(struct ActiveRoom* active, struct Room* room)
{
  unsigned int i,u;
  //affectation de la salle de base
  active->room = room;
  //TODO: ajouter ici le code relatif aux biomes
  //initialisation primaire de la salle
  for(i = 0; i != room->width; i++)
  {
    for(u = 0; u != room->height; u++)
    {
      active->map[i][u] = CELL_GROUND;
      active->map[0][u] = CELL_WALL;
      active->map[room->width][u] = CELL_WALL;
      active->map[i][0] = CELL_WALL;
      active->map[i][room->height] = CELL_WALL;
    }
  }
}

unsigned int ActiveRoom_isCellPassable(struct ActiveRoom* active, const unsigned int x, const unsigned int y)
{
  unsigned int r = active->map[x][y] >> 7;
  if(r == 1)
    return false;
  else
    return true;
}
