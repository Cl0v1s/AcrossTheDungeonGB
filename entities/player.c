#include "player.h"


void Player_create(struct Entity *entity,struct ActiveRoom *active)
{
  Entity_create(entity, active);
  entity->life = PLAYER_INIT_LIFE;
  entity->flag = 0x00;
  entity->spriteId = 0;
}
