#include "render.h"

void initRender()
{
  disableDisplay();

  SPRITES_8x8;

  canvasX = 0;
  canvasY = 0;
  loadFont();
  loadBackground();
  loadSprites();


  move_win(7,120);

  SHOW_BKG;
  SHOW_WIN;
  SHOW_SPRITES;

  enableDisplay();
}

void disableDisplay()
{
  disable_interrupts();
  DISPLAY_OFF;
}

void enableDisplay()
{
  DISPLAY_ON;
  enable_interrupts();
}

void loadBackground()
{
  DISPLAY_OFF;
  SWITCH_ROM_MBC1(3);
  set_bkg_data(0,13,tileset);
  SWITCH_ROM_MBC1(1);
}

void loadSprites()
{
  DISPLAY_OFF;
  SWITCH_ROM_MBC1(3);
  //chargement du sprite du joueur
  set_sprite_data(0,14,spriteplayer);
  SWITCH_ROM_MBC1(1);
}

void loadFont()
{
  unsigned char* source = 0x9300;
  unsigned char* target = 0x8800;
  puts("Loading font"); //chargement du texte en mémoire
  DISPLAY_OFF;
  //copie des nombres de 0 à 9
  while(source != 0x93A0)
  {
    (*target) = (*source);
    target++;
    source++;
  }
  source = 0x9610;
  //copies des lettres de a à z
  while(source != 0x97B0)
  {
    (*target) = (*source);
    target++;
    source++;
  }
  //copie de quelques caractères spéciaux
  source = 0x9210; //!
  while(source != 0x9220)
  {
    (*target) = (*source);
    target++;
    source++;
  }
  source = 0x93F0; //?
  while(source != 0x9400)
  {
    (*target) = (*source);
    target++;
    source++;
  }
  source = 0x92E0; //.
  while(source != 0x92F0)
  {
    (*target) = (*source);
    target++;
    source++;
  }
  source = 0x9270;//'
  while(source != 0x9280)
  {
    (*target) = (*source);
    target++;
    source++;
  }
  source = 0x9200;//'
  while(source != 0x9210)
  {
    (*target) = (*source);
    target++;
    source++;
  }
  source = 0x92D0;//-
  while(source != 0x92E0)
  {
    (*target) = (*source);
    target++;
    source++;
  }
  source = 0x93A0;//:
  while(source != 0x93B0)
  {
    (*target) = (*source);
    target++;
    source++;
  }
}

void clearBackground()
{
  unsigned int x, y;
  unsigned char empty[] = {1,1};
  DISPLAY_OFF;
  //effacement du fond
  for(x = 0; x != 32; x++)
  {
    for(y = 0; y != 32; y++)
    {
      set_bkg_tiles(x,y,1,1,empty);
    }
  }
  DISPLAY_ON;
}

void clearWindow()
{
  unsigned int x, y;
  unsigned char empty[] = {1,1};
  DISPLAY_OFF;
  //effacement du HUD
  for(x = 0; x != 32; x++)
  {
    for(y = 0; y != 32; y++)
    {
      set_win_tiles(x,y,1,1,empty);
    }
  }
  DISPLAY_ON;
}

void moveCanvas(const unsigned int x, const unsigned int y)
{
  setCanvasPos(canvasX+x, canvasY+y);
}

void setCanvasPos(const unsigned int x, const unsigned int y)
{
  canvasX = x;
  canvasY = y;
}

void focusRender(const unsigned int x, const unsigned int y)
{
  setCanvasPos(x-(HARDWARE_WIDTH/2), y-(HARDWARE_HEIGHT/2));
}

void updateRender()
{
  move_bkg(canvasX, canvasY);
}

void drawInt(const unsigned int x, const unsigned int y, int val)
{
  unsigned int i = 0;
  unsigned int xp = 0;
  unsigned char t[2];
  int comp[3];
  //supression du signe (valeur absolue)
  unsigned int value = 0;
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

void drawText(const unsigned int x, const unsigned int y, char* text)
{
  //TODO: à eventuellement améliorer pour limiter les accès à la mémoire vidéo
  unsigned int i = 0;
  unsigned int o = 0;
  unsigned int p = 0;
  unsigned int v;
  unsigned char t[2];
  char* q = 0xDe80;
  while(text[i] != 0x00)
  {
    (*q) = text[i];
    q++;
    v = text[i];
    //traitement et conversion
    if(v == 0x2E)//. placement du point en premier (pas optimal) suite à un bug étrange
          v = 0x26;
    else if(v >0x60 && v<0x7B) //a-z
      v = v-0x61+0xA;
    else if(v>0x29 && v<0x3A) //0-9
      v -= 0x30;
    else if(v == 0x3F)//?
        v = 0x25;
    else if(v == 0x21)//!
        v = 0x24;
    else if(v == 0x27)//'
        v = 0x27;
    else if(v == 0x2D)//-
      v = 0x29;
    else if(v == 0x3A)//:
      v = 0x2A;
    else
        v = 0x28; //tout le reste et  espaces
    //affichage
    t[0] = 0x80+v;
    t[1] = 0x80 + v;
    set_win_tiles(x+o, y+p, 1,1, t);
    o++;
    if(o==20)
    {
      o = 0;
      p++;
    }
    i++;
  }
}

void drawRoom(struct ActiveRoom* active)
{
  unsigned char x,y;
  unsigned char current[4] = {1,1};
  DISPLAY_OFF;
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
  DISPLAY_ON;
}

void drawPlayer(struct Player* player)
{
  unsigned char frame = 0;
  unsigned int downL[] = {1,2,1,3};
  unsigned int downR[] = {1,3,1,2};
  unsigned int side[] = {6,8,6,8};
  unsigned int upL[] = {11,12,11,13};
  unsigned int upR[] = {11,13,11,12};
  //TODO: ajouter code pour le bas
  //gestion des frames
  if(player->moving != 0)
  {
    player->frame+=2;
    if(player->frame == 40)
      player->frame = 0;
    frame = player->frame/10;
  }

  //gestion de la tête
  if(player->dir == 0)
  {
    set_sprite_tile(SPRITE_PLAYER_TOPL, 0);
    set_sprite_tile(SPRITE_PLAYER_TOPR, 0);
    if(get_sprite_prop(SPRITE_PLAYER_TOPL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_TOPL, 0x00U);
    if(get_sprite_prop(SPRITE_PLAYER_TOPR) !=  S_FLIPX) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_TOPR, S_FLIPX);
  }
  else if(player->dir == 3 && get_sprite_tile(SPRITE_PLAYER_TOPL) != 4)
  {
    set_sprite_tile(SPRITE_PLAYER_TOPL, 4);
    set_sprite_tile(SPRITE_PLAYER_TOPR, 5);
    if(get_sprite_prop(SPRITE_PLAYER_TOPL) != 0x00U) //Si le prop n'est pas celui par défaut
      set_sprite_prop(SPRITE_PLAYER_TOPL, 0x00U); //On remet celui par défaut
    if(get_sprite_prop(SPRITE_PLAYER_TOPR) != 0x00U) //Si le prop n'est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_TOPR, 0x00U); //On remt celui par defautt
  }
  else if(player->dir == 1 && get_sprite_tile(SPRITE_PLAYER_TOPL) != 5)
  {
    set_sprite_tile(SPRITE_PLAYER_TOPL, 5);
    set_sprite_tile(SPRITE_PLAYER_TOPR, 4);
    if(get_sprite_prop(SPRITE_PLAYER_TOPL) == 0x00U) //Si le prop n'est pas celui par défaut
      set_sprite_prop(SPRITE_PLAYER_TOPL, S_FLIPX); //On remet celui par défaut
    if(get_sprite_prop(SPRITE_PLAYER_TOPR) == 0x00U) //Si le prop n'est pas celui par défaut
      set_sprite_prop(SPRITE_PLAYER_TOPR, S_FLIPX); //On remet celui par défaut
  }
  if(player->dir == 2 && get_sprite_tile(SPRITE_PLAYER_TOPL) != 10)
  {
    set_sprite_tile(SPRITE_PLAYER_TOPL, 10);
    set_sprite_tile(SPRITE_PLAYER_TOPR, 10);
    if(get_sprite_prop(SPRITE_PLAYER_TOPL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_TOPL, 0x00U);
    if(get_sprite_prop(SPRITE_PLAYER_TOPR) == 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_TOPR, S_FLIPX);
  }

  //gestion du corps
  if(player->dir == 0)
  {
    set_sprite_tile(SPRITE_PLAYER_BOTL, downL[frame]);
    set_sprite_tile(SPRITE_PLAYER_BOTR, downR[frame]);
    if(get_sprite_prop(SPRITE_PLAYER_BOTL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTL, 0x00U);
    if(get_sprite_prop(SPRITE_PLAYER_BOTR) == 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTR, S_FLIPX);
  }
  else if(player->dir == 2)
  {
    set_sprite_tile(SPRITE_PLAYER_BOTL, upL[frame]);
    set_sprite_tile(SPRITE_PLAYER_BOTR, upR[frame]);
    if(get_sprite_prop(SPRITE_PLAYER_BOTL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTL, 0x00U);
    if(get_sprite_prop(SPRITE_PLAYER_BOTR) == 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTR, S_FLIPX);
  }
  else if(player->dir == 3)
  {
    set_sprite_tile(SPRITE_PLAYER_BOTL, side[frame]);
    set_sprite_tile(SPRITE_PLAYER_BOTR, side[frame]+1);
    if(get_sprite_prop(SPRITE_PLAYER_BOTL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTL, 0x00U);
    if(get_sprite_prop(SPRITE_PLAYER_BOTR) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTR, 0x00U);
  }
  else if(player->dir == 1)
  {
    set_sprite_tile(SPRITE_PLAYER_BOTL, side[frame]+1);
    set_sprite_tile(SPRITE_PLAYER_BOTR, side[frame]);
    if(get_sprite_prop(SPRITE_PLAYER_BOTL) == 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTL, S_FLIPX);
    if(get_sprite_prop(SPRITE_PLAYER_BOTR) == 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTR, S_FLIPX);
  }


  move_sprite(SPRITE_PLAYER_TOPL, player->x+8-canvasX, player->y+16-8-canvasY);
  move_sprite(SPRITE_PLAYER_TOPR, player->x+8+8-canvasX, player->y+16-8-canvasY);
  move_sprite(SPRITE_PLAYER_BOTL, player->x+8-canvasX, player->y+16-canvasY);
  move_sprite(SPRITE_PLAYER_BOTR, player->x+8+8-canvasX, player->y+16-canvasY);



}
