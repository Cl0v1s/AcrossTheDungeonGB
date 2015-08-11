#ifndef PLAYER_H
#define PLAYER_H

#include "const.h"
#include "room.h"

typedef struct Player
{
	Room *room;
	unsigned int x;
	unsigned int y;
	unsigned int life;
	//TODO: ajouter les autres attributs du joueur 
}Player; 

void Player_createPlayer(Player *player, Room *room, const unsigned int life, const unsigned int x, const unsigned int y);
const int Player_move(Player *player, const unsigned int x, const unsigned int y);
void Player_setPos(Player *player, const unsigned int x, const unsigned int y);
const int Player_isAlive(Player *player);
void Player_activateCellAt(Player *player, const unsigned int x, const unsigned int y);

#endif
