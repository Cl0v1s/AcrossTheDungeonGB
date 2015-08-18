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

unsigned char Player_moveDown(struct Player* player)
{
	unsigned char r;
	unsigned char cx,cy,cw;
	player->dir = 0;
	cx = (player->x+1) >> 4;
	cy = (player->y+PLAYER_MOVING_SPEED+8) >> 4;
	cw = (player->x + 15) >> 4;
	r = ActiveRoom_isCellPassable(player->active, cx, cy);
	if(r == false)
		return r;
	r = ActiveRoom_isCellPassable(player->active, cw, cy);
	if(r == true)
	{
		Player_setPos(player, player->x, player->y+PLAYER_MOVING_SPEED);
	}
	return r;
}

unsigned char Player_moveUp(struct Player* player)
{
	unsigned char r;
	unsigned char cx,cy,cw;
	player->dir = 2;
	cx = (player->x+1) >> 4;
	cy = (player->y-PLAYER_MOVING_SPEED) >> 4;
	cw = (player->x + 15) >> 4;
	r = ActiveRoom_isCellPassable(player->active, cx, cy);
	if(r == false)
	{
		return r;
	}
	r = ActiveRoom_isCellPassable(player->active, cw, cy);
	if(r == true)
	{
		Player_setPos(player, player->x, player->y-PLAYER_MOVING_SPEED);
	}
	return r;
}

unsigned char Player_moveLeft(struct Player* player)
{
	unsigned char r;
	unsigned char cy,cx,ch;
	player->dir = 3;
	cx = (player->x-PLAYER_MOVING_SPEED) >> 4;
	cy = (player->y+1) >> 4;
	ch = (player->y + 7) >> 4;
	r = ActiveRoom_isCellPassable(player->active, cx, cy);
	if(r == false)
		return r;
	r = ActiveRoom_isCellPassable(player->active, cx, ch);
	if(r == true)
	{
		Player_setPos(player, player->x-PLAYER_MOVING_SPEED, player->y);
	}
	return r;
}

unsigned char Player_moveRight(struct Player* player)
{
	unsigned char r;
	unsigned char cy,cx,ch;
	player->dir = 1;
	cx = (player->x+PLAYER_MOVING_SPEED+16) >> 4;
	cy = (player->y+1) >> 4;
	ch = (player->y + 7) >> 4;
	r = ActiveRoom_isCellPassable(player->active, cx, cy);
	if(r == false)
		return r;
	r = ActiveRoom_isCellPassable(player->active, cx, ch);
	if(r == true)
	{
		Player_setPos(player, player->x+PLAYER_MOVING_SPEED, player->y);
	}
	return r;
}
