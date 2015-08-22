#ifndef ENTITIESMANAGER_H
#define ENTITIESMANAGER_H

#include "helper.h"
#include "render.h"
#include "entities/entity.h"
#include "entities/blob.h"

typedef struct Entity Entities[ROOM_MAX_ENTITIES];

struct ActiveRoom;

void Entities_setPlayer(struct Entity* player);
void Entities_populateActiveRoom(struct ActiveRoom* active, const unsigned char type, const unsigned char number);
void Entities_update();
unsigned char Entities_interact(const unsigned char x, const unsigned char y);

#endif
