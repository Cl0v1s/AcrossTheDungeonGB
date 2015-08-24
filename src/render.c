#include "render.h"

unsigned char render_spriteNumber = 0;

unsigned char register_sprite()
{
  unsigned char n = render_spriteNumber;
  render_spriteNumber ++;
  return n;
}


void focus_canvas(unsigned char x, unsigned char y)
{
  unsigned char* u = 0xFF42;
  unsigned char* c = 0xFF43;
  (*u) = y-(HARDWARE_HEIGHT/2);
  (*c) = x-(HARDWARE_WIDTH/2);
}

void draw_entity(struct Entity* entity)
{
  unsigned char frame = 0;
  unsigned char start = entity->spriteId*0x0E;
  unsigned char downL[] = {start+1,start+2,start+1,start+3};
  unsigned char downR[] = {start+1,start+3,start+1,start+2};
  unsigned char side[] = {start+6,start+8,start+6,start+8};
  unsigned char upL[] = {start+11,start+12,start+11,start+13};
  unsigned char upR[] = {start+11,start+13,start+11,start+12};

  unsigned char topL = 0+(entity->spriteNumber << 2);
  unsigned char topR = 1+(entity->spriteNumber << 2);
  unsigned char botL = 2+(entity->spriteNumber << 2);
  unsigned char botR = 3+(entity->spriteNumber << 2);

  unsigned char* canvasY = 0xFF42;
  unsigned char* canvasX = 0xFF43;
  //gestion des frames
  if(entity->moving != 0 || entity->flag & 1)
  {
    entity->frame+=2;
    if(entity->frame == 40)
      entity->frame = 0;
    frame = entity->frame/10;
  }

  //gestion de la tête
  if(entity->dir == 0)
  {
    set_sprite_tile(topL, start);
    set_sprite_tile(topR, start);
    if(get_sprite_prop(topL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(topL, 0x00U);
    if(get_sprite_prop(topR) !=  S_FLIPX) //si le prop est celui par défaut
      set_sprite_prop(topR, S_FLIPX);
  }
  else if(entity->dir == 3 && get_sprite_tile(topL) != start + 4)
  {
    set_sprite_tile(topL, start + 4);
    set_sprite_tile(topR, start + 5);
    if(get_sprite_prop(topL) != 0x00U) //Si le prop n'est pas celui par défaut
      set_sprite_prop(topL, 0x00U); //On remet celui par défaut
    if(get_sprite_prop(topR) != 0x00U) //Si le prop n'est celui par défaut
      set_sprite_prop(topR, 0x00U); //On remt celui par defautt
  }
  else if(entity->dir == 1 && get_sprite_tile(topL) != start + 5)
  {
    set_sprite_tile(topL, start + 5);
    set_sprite_tile(topR, start + 4);
    if(get_sprite_prop(topL) == 0x00U) //Si le prop n'est pas celui par défaut
      set_sprite_prop(topL, S_FLIPX); //On remet celui par défaut
    if(get_sprite_prop(topR) == 0x00U) //Si le prop n'est pas celui par défaut
      set_sprite_prop(topR, S_FLIPX); //On remet celui par défaut
  }
  if(entity->dir == 2 && get_sprite_tile(topL) != start + 10)
  {
    set_sprite_tile(topL, start + 10);
    set_sprite_tile(topR, start + 10);
    if(get_sprite_prop(topL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(topL, 0x00U);
    if(get_sprite_prop(topR) == 0x00U) //si le prop est celui par défaut
      set_sprite_prop(topR, S_FLIPX);
  }

  //gestion du corps
  if(entity->dir == 0)
  {
    set_sprite_tile(botL, downL[frame]);
    set_sprite_tile(botR, downR[frame]);
    if(get_sprite_prop(botL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(botL, 0x00U);
    if(get_sprite_prop(botR) != S_FLIPX) //si le prop est celui par défaut
      set_sprite_prop(botR, S_FLIPX);
  }
  else if(entity->dir == 2)
  {
    set_sprite_tile(botL, upL[frame]);
    set_sprite_tile(botR, upR[frame]);
    if(get_sprite_prop(botL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(botL, 0x00U);
    if(get_sprite_prop(botR) == 0x00U) //si le prop est celui par défaut
      set_sprite_prop(botR, S_FLIPX);
  }
  else if(entity->dir == 3)
  {
    set_sprite_tile(botL, side[frame]);
    set_sprite_tile(botR, side[frame]+1);
    if(get_sprite_prop(botL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(botL, 0x00U);
    if(get_sprite_prop(botR) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(botR, 0x00U);
  }
  else if(entity->dir == 1)
  {
    set_sprite_tile(botL, side[frame]+1);
    set_sprite_tile(botR, side[frame]);
    if(get_sprite_prop(botL) == 0x00U) //si le prop est celui par défaut
      set_sprite_prop(botL, S_FLIPX);
    if(get_sprite_prop(botR) == 0x00U) //si le prop est celui par défaut
      set_sprite_prop(botR, S_FLIPX);
  }
  move_sprite(topL, entity->x+8-(*canvasX), entity->y+16-8-(*canvasY));
  move_sprite(topR, entity->x+8+8-(*canvasX), entity->y+16-8-(*canvasY));
  move_sprite(botL, entity->x+8-(*canvasX), entity->y+16-(*canvasY));
  move_sprite(botR, entity->x+8+8-(*canvasX), entity->y+16-(*canvasY));
}


void draw_room(struct ActiveRoom* active)
{
  unsigned char x,y;
  unsigned char current[4] = {1,1};
  for(x = 0; x != active->room->width; x++)
  {
    for(y = 0; y != active->room->height; y++)
    {
      current[0] = 0;
      current[1] = 0;
      current[2] = 0;
      current[3] = 0;
      if(active->map[x+y*active->room->width] >> 6 == 1) //si il s'agit d'une porte
      {
        current[0] = 1; //vers le bas
        current[1] = 1;
        current[2] = 9;
        current[3] = 9;
        if(x == 0) //vers la droite
        {
          current[0] = 1;
          current[1] = 0xC;
          current[2] = 1;
          current[3] = 0xC;
        }
        else if(x == active->room->width - 1) //vers la gauche
        {
          current[0] = 0xA;
          current[1] = 1;
          current[2] = 0xA;
          current[3] = 1;
        }
        else if(y == active->room->height - 1) //vers le haut
        {
          current[0] = 0xB;
          current[1] = 0xB;
          current[2] = 1;
          current[3] = 1;
        }
        set_bkg_tiles(x << 1,y << 1,2,2, current);
      }
      else
      {
        switch(active->map[x+y*active->room->width])
        {
          case CELL_WALL:
            current[0] = 2;
            current[1] = 2;
            current[2] = 2;
            current[3] = 2;
            if(active->map[x+(y+1)*active->room->width] != CELL_WALL)
            {
              current[0] = 7;
              current[1] = 7;
              current[2] = 8;
              current[3] = 8;
            }
            set_bkg_tiles(x << 1,y << 1,2,2, current);
          break;
          case CELL_GROUND:
            current[0] = 0;current[1] = 0;current[2] = 0;current[3] = 0;
            set_bkg_tiles(x << 1,y << 1,2,2, current);
          break;
        }
      }
    }
  }
}

void draw_int(const unsigned char x, const unsigned char y, char val)
{
  unsigned char i = 0;
  unsigned char xp = 0;
  unsigned char t[2];
  char comp[3];
  //supression du signe (valeur absolue)
  unsigned char value = 0;
  if(val < 0)
    value = val *-1;
  else
    value = val;
  //décomposition du nombre et conversion en tuile
  comp[0] = value / 100;
  value -= comp[0] * 100;
  if(comp[0] == 0)
    comp[0] = -1;
  comp[1] = value / 10;
  value -= comp[1] * 10;
  if(comp[0] == -1 && comp[1] == 0)
    comp[1] = -1;
  comp[2] = value;
  if(val < 0)
  {
    t[0] = 0x80+0x29;
    t[1] = 0x80+0x29;
    set_win_tiles(x+xp, y, 1,1, t);
    xp++;
  }
  for(i=0; i !=3;i++)
  {
    if(comp[i] != -1)
    {
      comp[i] += 0x80;
      t[0] = comp[i];
      t[1] = comp[i];
      set_win_tiles(x+xp, y, 1,1, t);
      xp++;

    }
  }

}
