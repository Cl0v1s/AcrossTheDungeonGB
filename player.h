#ifndef PLAYER_H
#define PLAYER_H

#include "helper.h"
#include "activeroom.h"
#include "room.h"



struct Player
{
	struct ActiveRoom* active;
	unsigned char x;
	unsigned char y;
	unsigned int frame;
	unsigned int dir;
	unsigned int life;
	//TODO: ajouter les autres attributs du joueur
};

void Player_create(struct Player *player,struct ActiveRoom *active);
void Player_fromSave(struct Player* player, struct ActiveRoom *active, const unsigned int life, const unsigned int x, const unsigned int y);
int Player_move(struct Player *player, char x, char y);
void Player_setPos(struct Player *player, const unsigned int x, const unsigned int y);
int Player_isAlive(struct Player *player);
void Player_activateCellAt(struct Player *player, const unsigned int x, const unsigned int y);
unsigned int Player_moveDown(struct Player* player);
unsigned int Player_moveUp(struct Player* player);
unsigned int Player_moveLeft(struct Player* player);
unsigned int Player_moveRight(struct Player* player);

#endif
