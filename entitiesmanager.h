#ifndef ENTITIESMANAGER_H
#define ENTITIESMANAGER_H

#include "helper.h"
#include "render.h"
#include "entities/entity.h"
#include "entities/blob.h"

typedef struct Entity Entities[ROOM_MAX_ENTITIES];

struct ActiveRoom;

void populateActiveRoom(struct ActiveRoom* active, const unsigned char type, const unsigned char number);
void updateEntities();
unsigned char itIsEntityFreeAt(const unsigned char x, const unsigned char y);

#endif
