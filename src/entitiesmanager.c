#include "entitiesmanager.h"

Entities entities;
unsigned char entitiesNumber = 0;
struct Entity* playerRef;

void Entities_setPlayer(struct Entity* player)
{
	playerRef = player;
}

void Entities_populateActiveRoom(struct ActiveRoom* active, const unsigned char type, const unsigned char number)
{
	unsigned char i = 0;
  entitiesNumber = number;
	for(i = 0; i!=number; i++)
	{
		if(type == 1)
		{
			Blob_create(&entities[i], active);
			entities[i].spriteNumber = registerSprite();
		}
	}
}

void Entities_update()
{
  unsigned char i;
  for(i = 0; i != entitiesNumber; i++)
  {
    Entity_update(&entities[i]);
    drawEntity(&entities[i]);
  }
}

unsigned char Entities_interact(const unsigned char x, const unsigned char y)
{
  unsigned char i, done;
  unsigned char xe, ye;
  done = true;
  i = 0;
  while( i!= entitiesNumber && done == true)
  {
    xe = ((entities[i].x) >> 4);
    ye = ((entities[i].y) >> 4);
    if(x == xe && y == ye)
    {
      done = false;
    }
		if(entities[i].moving != 0) //si l'entité se déplace on prend aussi en compte sa destination
		{
			if(entities[i].dir == 0)
			{
				ye+=1;
			}
			else if(entities[i].dir == 1)
			{
				xe += 1;
			}
			else if(entities[i].dir == 2)
			{
				ye -= 1;
			}
			else
			{
				xe -= 1;
			}
			if(x == xe && y == ye)
	    {
	      done = false;
	    }
		}
    i++;
  }
	if(done == true) //on vérifie avec le joueur
	{
		xe = ((playerRef->x) >> 4);
    ye = ((playerRef->y) >> 4);
    if(x == xe && y == ye)
    {
      done = false;
    }
		if(playerRef->moving != 0) //si l'entité se déplace on prend aussi en compte sa destination
		{
			if(playerRef->dir == 0)
			{
				ye+=1;
			}
			else if(playerRef->dir == 1)
			{
				xe += 1;
			}
			else if(playerRef->dir == 2)
			{
				ye -= 1;
			}
			else
			{
				xe -= 1;
			}
			if(x == xe && y == ye)
	    {
	      done = false;
	    }
		}
	}
  return done;
}
