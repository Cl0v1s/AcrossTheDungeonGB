#include "blob.h"

void Blob_create(struct Entity* entity, struct ActiveRoom* active)
{
  Entity_create(entity, active);
  entity->flag = 0x03;
  entity->life = 6;
  entity->spriteId = 1;
}
