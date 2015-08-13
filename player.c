#include "player.h"

void Player_create(struct Player* player, struct ActiveRoom* active)
{
	player->active = active;
	player->life = PLAYER_INIT_LIFE;
	//paramétrage de la position x et y
	player->x =random(1, active->room->width -1);
	player->y = random(1, active->room->height -1);
	while(ActiveRoom_isCellPassable(active, player->x, player->y))
	{
		player->x =random(1, active->room->width -1);
		player->y = random(1, active->room->height -1);
	}
	printf("player in %d/%d\n", player->x, player->y);
}

void Player_fromSave(struct Player* player, struct ActiveRoom *active, const unsigned int life, const unsigned int x, const unsigned int y)
{

}

void Player_setPos(struct Player *player, const unsigned int x, const unsigned int y)
{
	//TODO: 2ventuellement rajouter un test de possibilité afin que le njoueur ne se retrouve pas dans un obstacle
	player->x = x;
	player->y = y;
}

int Player_move(struct Player *player, const unsigned int x, const unsigned int y)
{
	if(ActiveRoom_isCellPassable(player->active, player->x+x, player->y+y))
	{
			Player_setPos(player, player->x+x, player->y+y);
			return true;
	}
	return false;
}


int Player_isAlive(struct Player *player)
{
	if(player->life != 0)
		return true;
	return false;
}

void Player_activateCellAt(struct Player *player, const unsigned int x, const unsigned int y)
{
	//TODO: Définir les actions du joueurs en fonction de la case qu'il vient d'activer
}
