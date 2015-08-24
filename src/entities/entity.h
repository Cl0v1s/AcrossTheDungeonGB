#ifndef ENTITY_H
#define ENTITY_H

#include "../helper.h"
#include "../activeroom.h"



struct Entity
{
	struct ActiveRoom* active;
	unsigned char x;
	unsigned char y;
	unsigned char frame;
	unsigned char dir;
	unsigned char life;
	unsigned char moving;
	//ensemble de 8 bits paramétrant le comportement de l'entité
	//1.static animated
	unsigned char flag;
	unsigned char spriteId;
	unsigned char spriteNumber;
	//TODO: ajouter les autres attributs du joueur
};

void Entity_create(struct Entity *entity,struct ActiveRoom *active);
void Entity_setPos(struct Entity *entity, const unsigned int x, const unsigned int y);
void Entity_moveDown(struct Entity* entity);
void Entity_moveUp(struct Entity* entity);
void Entity_moveLeft(struct Entity* entity);
void Entity_moveRight(struct Entity* entity);
void Entity_update(struct Entity* entity);

#endif
