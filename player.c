#include "player.h"

void Player_create(Player* player, Room *room, const unsigned int life, const unsigned int x, const unsigned int y)
{
	player->room = room;
	player->life = life;
	player->x =x ;
	player->y = y;
}

void Player_setPos(Player *player, const unsigned int x, const unsigned int y)
{
	//TODO: 2ventuellement rajouter un test de possibilité afin que le njoueur ne se retrouve pas dans un obstacle 
	player->x = x;
	player->y = y;
}

const int Player_move(Player *player, const unsigned int x, const unsigned int y)
{
	if(Room_isCellPassableAt(player->room, player->x+x,player->y+y))
	{
		Player_setPos(player, player->x+x, player->y+y);
		return true;
	}
	return false;
}


const int Player_isAlive(Player *player)
{
	if(player->life != 0)
		return true;
	return false;
}

void Player_activateCellAt(Player *player, const unsigned int x, const unsigned int y)
{
	//TODO: Définir les actions du joueurs en fonction de la case qu'il vient d'activer
}
