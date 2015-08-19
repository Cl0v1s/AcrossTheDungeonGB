#include "entity.h"

void Entity_create(struct Entity* entity, struct ActiveRoom* active)
{
	entity->active = active;
	entity->life = PLAYER_INIT_LIFE;
	//paramétrage de la position x et y
	entity->x =(random(1, active->room->width -1)*16);
	entity->y =(random(1, active->room->height -1)*16);
	while(ActiveRoom_isCellPassable(active, entity->x, entity->y) == false)
	{
		entity->x =(random(1, active->room->width -1)*16);
		entity->y = (random(1, active->room->height -1)*16);
	}
	entity->frame = 0;

}

void Entity_fromSave(struct Entity* entity, struct ActiveRoom *active, const unsigned int life, const unsigned int x, const unsigned int y)
{

}

void Entity_setPos(struct Entity *entity, const unsigned int x, const unsigned int y)
{
	//TODO: 2ventuellement rajouter un test de possibilité afin que le njoueur ne se retrouve pas dans un obstacle
	entity->x = x;
	entity->y = y;
}


int Entity_isAlive(struct Entity *entity)
{
	if(entity->life != 0)
		return true;
	return false;
}

void Entity_activateCellAt(struct Entity *entity, const unsigned int x, const unsigned int y)
{
	//TODO: Définir les actions du joueurs en fonction de la case qu'il vient d'activer
}

void Entity_update(struct Entity* entity)
{
	unsigned char* p = 0XDE90;
	unsigned char cell;
	//analyse des mouvements
	if(entity->moving != 0)
	{
		if(entity->dir == 0)
			entity->y = entity->y + 1;
		else if(entity->dir == 2)
			entity->y = entity->y - 1;
		else if(entity->dir == 3)
			entity->x = entity->x - 1;
		else if(entity->dir == 1)
			entity->x = entity->x + 1;
		entity->moving--;
		if(entity->moving  == 0 || entity->moving == 0-PLAYER_MOVING_SPEED)
		{
			entity->x = (entity->x >> 4) << 4;
			entity->y = (entity->y >> 3) << 3;
			entity->moving = 0;
		}
	}
	else
	{
		cell = ActiveRoom_getCellAt(entity->active, entity->x >> 4, entity->y >> 4);
		(*p) = cell;
		if((cell >> 6) == 1 )
		{
			entity->active->markedForTpTo = cell - CELL_DOOR;
		}
	}


}

void Entity_moveDown(struct Entity* entity)
{
	if(entity->moving != 0)
		return;
	entity->dir = 0;
	if(ActiveRoom_isCellPassable(entity->active, entity->x >> 4, (entity->y+16) >> 4))
	{
		entity->moving = 16;
	}
	else
	{
		SOUND_CHANNEL_1;
		SOUND_CHANNEL_1_ENVELOPE(5,0,2);
		SOUND_CHANNEL_1_PLAY(0x02);
	}
}

void Entity_moveUp(struct Entity* entity)
{
	if(entity->moving != 0)
		return;
	entity->dir = 2;
	if(ActiveRoom_isCellPassable(entity->active, entity->x >> 4, (entity->y-16) >> 4) && entity->moving == 0)
	{
		entity->moving = 16;
	}
	else
	{
		SOUND_CHANNEL_1;
		SOUND_CHANNEL_1_ENVELOPE(5,0,2);
		SOUND_CHANNEL_1_PLAY(0x02);
	}
}

void Entity_moveLeft(struct Entity* entity)
{
	if(entity->moving != 0)
		return;
	entity->dir = 3;
	if(ActiveRoom_isCellPassable(entity->active, (entity->x-16) >> 4, (entity->y) >> 4) && entity->moving == 0)
	{
		entity->moving = 16;
	}
	else
	{
		SOUND_CHANNEL_1;
		SOUND_CHANNEL_1_ENVELOPE(5,0,2);
		SOUND_CHANNEL_1_PLAY(0x02);
	}
}

void Entity_moveRight(struct Entity* entity)
{
	if(entity->moving != 0)
		return;
	entity->dir = 1;
	if(ActiveRoom_isCellPassable(entity->active, (entity->x+16) >> 4, (entity->y) >> 4) && entity->moving == 0)
	{
		entity->moving = 16;
	}
	else
	{
		SOUND_CHANNEL_1;
		SOUND_CHANNEL_1_ENVELOPE(5,0,2);
		SOUND_CHANNEL_1_PLAY(0x02);
	}
}
