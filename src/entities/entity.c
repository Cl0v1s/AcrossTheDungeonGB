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
	entity->spriteNumber = 0;
}

void Entity_setPos(struct Entity *entity, const unsigned int x, const unsigned int y)
{
	//TODO: 2ventuellement rajouter un test de possibilité afin que le njoueur ne se retrouve pas dans un obstacle
	entity->x = x;
	entity->y = y;
}

void Entity_update(struct Entity* entity)
{
	unsigned char cell;
	//mouvement aléatoire
	if((entity->flag & 0x02) == 0x02 && entity->moving == 0)
	{
		cell = random(0,100);
		if(cell == 1)
			Entity_moveRight(entity);
		else if(cell == 0)
			Entity_moveDown(entity);
		else if(cell == 2)
			Entity_moveUp(entity);
		else if(cell == 3)
			Entity_moveLeft(entity);
	}
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
	else if((entity->flag & 0x02) != 0x02)
	{
		cell = ActiveRoom_getCellAt(entity->active, entity->x >> 4, entity->y >> 4);
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

}
