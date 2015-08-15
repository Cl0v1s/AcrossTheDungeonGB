#include "player.h"

void Player_create(struct Player* player, struct ActiveRoom* active)
{
	player->active = active;
	player->life = PLAYER_INIT_LIFE;
	//paramétrage de la position x et y
	player->x =(random(1, active->room->width -1)*16);
	player->y =(random(1, active->room->height -1)*16);
	while(ActiveRoom_isCellPassable(active, player->x, player->y) == false)
	{
		player->x =(random(1, active->room->width -1)*16);
		player->y = (random(1, active->room->height -1)*16);
	}
	player->frame = 0;

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

int Player_move(struct Player *player, unsigned int x, unsigned int y)
{
	//TODO: à vérifier lorsque le dessin de la salle sera effectif
	if(ActiveRoom_isCellPassable(player->active, ((player->x+x) >> 4),((player->y+y) >> 4) ) )
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

unsigned int Player_moveDown(struct Player* player)
{
	unsigned int r;
	player->dir = 0;
	r = Player_move(player, 0, PLAYER_MOVING_SPEED);
	return r;
}

unsigned int Player_moveUp(struct Player* player)
{
	unsigned int r;
	player->dir = 2;
	r= Player_move(player, 0, 0-PLAYER_MOVING_SPEED);
	return r;
}

unsigned int Player_moveLeft(struct Player* player)
{
	unsigned int r;
	player->dir = 3;
	r = Player_move(player, 0-PLAYER_MOVING_SPEED, 0);
	return r;
}

unsigned int Player_moveRight(struct Player* player)
{
	unsigned int r;
	player->dir = 1;
	r = Player_move(player, PLAYER_MOVING_SPEED, 0);
	return r;
}
