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

void Player_update(struct Player* player)
{
	unsigned char* p = 0XDE90;
	unsigned char cell;
	//analyse des mouvements
	if(player->moving != 0)
	{
		if(player->dir == 0)
			player->y = player->y + 1;
		else if(player->dir == 2)
			player->y = player->y - 1;
		else if(player->dir == 3)
			player->x = player->x - 1;
		else if(player->dir == 1)
			player->x = player->x + 1;
		player->moving--;
		if(player->moving  == 0 || player->moving == 0-PLAYER_MOVING_SPEED)
		{
			player->x = (player->x >> 4) << 4;
			player->y = (player->y >> 3) << 3;
			player->moving = 0;
		}
	}
	else
	{
		cell = ActiveRoom_getCellAt(player->active, player->x >> 4, player->y >> 4);
		(*p) = cell;
		if((cell >> 6) == 1 )
		{
			player->active->markedForTpTo = cell - CELL_DOOR;
		}
	}


}

void Player_moveDown(struct Player* player)
{
	if(player->moving != 0)
		return;
	player->dir = 0;
	if(ActiveRoom_isCellPassable(player->active, player->x >> 4, (player->y+16) >> 4))
	{
		player->moving = 16;
	}
	else
	{
		SOUND_CHANNEL_1;
		SOUND_CHANNEL_1_ENVELOPE(5,0,2);
		SOUND_CHANNEL_1_PLAY(0x02);
	}
}

void Player_moveUp(struct Player* player)
{
	if(player->moving != 0)
		return;
	player->dir = 2;
	if(ActiveRoom_isCellPassable(player->active, player->x >> 4, (player->y-16) >> 4) && player->moving == 0)
	{
		player->moving = 16;
	}
	else
	{
		SOUND_CHANNEL_1;
		SOUND_CHANNEL_1_ENVELOPE(5,0,2);
		SOUND_CHANNEL_1_PLAY(0x02);
	}
}

void Player_moveLeft(struct Player* player)
{
	if(player->moving != 0)
		return;
	player->dir = 3;
	if(ActiveRoom_isCellPassable(player->active, (player->x-16) >> 4, (player->y) >> 4) && player->moving == 0)
	{
		player->moving = 16;
	}
	else
	{
		SOUND_CHANNEL_1;
		SOUND_CHANNEL_1_ENVELOPE(5,0,2);
		SOUND_CHANNEL_1_PLAY(0x02);
	}
}

void Player_moveRight(struct Player* player)
{
	if(player->moving != 0)
		return;
	player->dir = 1;
	if(ActiveRoom_isCellPassable(player->active, (player->x+16) >> 4, (player->y) >> 4) && player->moving == 0)
	{
		player->moving = 16;
	}
	else
	{
		SOUND_CHANNEL_1;
		SOUND_CHANNEL_1_ENVELOPE(5,0,2);
		SOUND_CHANNEL_1_PLAY(0x02);
	}
}
