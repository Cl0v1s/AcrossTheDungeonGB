#ifndef PLAYER_H
#define PLAYER_H

#include "sound.h"
#include "helper.h"
#include "activeroom.h"
#include "room.h"



struct Entity
{
	struct ActiveRoom* active;
	unsigned char x;
	unsigned char y;
	unsigned char frame;
	unsigned char dir;
	unsigned char life;
	char moving;
	//TODO: ajouter les autres attributs du joueur
};

void Entity_create(struct Entity *entity,struct ActiveRoom *active);
void Entity_fromSave(struct Entity* entity, struct ActiveRoom *active, const unsigned int life, const unsigned int x, const unsigned int y);
void Entity_setPos(struct Entity *entity, const unsigned int x, const unsigned int y);
int Entity_isAlive(struct Entity *entity);
void Entity_activateCellAt(struct Entity *entity, const unsigned int x, const unsigned int y);
void Entity_moveDown(struct Entity* entity);
void Entity_moveUp(struct Entity* entity);
void Entity_moveLeft(struct Entity* entity);
void Entity_moveRight(struct Entity* entity);
void Entity_update(struct Entity* entity);

#endif
