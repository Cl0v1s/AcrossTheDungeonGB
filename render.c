#include "render.h"

void initRender()
{
  disableDisplay();

  SPRITES_8x8;

  canvasX = 0;
  canvasY = 0;
  frameCounter = 0;
  loadBackground();
  loadSprites();
  loadFont();

  move_win(0,120);

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
  set_bkg_data(0,9,tileset);
}

void loadSprites()
{
  //chargement du sprite du joueur
  set_sprite_data(0,14,spriteplayer);
}

void loadFont()
{
  set_win_data(0x80,0x5e, font);
}

void clearDisplay()
{
  unsigned int x, y;
  unsigned char empty[] = {1,1};
  //effacement du texte
  for(x = 0; x != 32; x++)
  {
    for(y = 0; y != 32; y++)
    {
      set_bkg_tiles(x,y,1,1,empty);
    }
  }
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
  frameCounter += 1;
  if(frameCounter == 20)
    frameCounter = 0;
  move_bkg(canvasX, canvasY);
}

void drawRoom(struct ActiveRoom* active)
{
  unsigned int x,y;
  unsigned char current[4] = {1,1};
  for(x = 0; x != active->room->width; x++)
  {
    for(y = 0; y != active->room->height; y++)
    {
      current[0] = 0;
      current[1] = 0;
      current[2] = 0;
      current[3] = 0;
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

void drawPlayer(struct Player* player)
{
  unsigned int downL[] = {1,2,1,3};
  unsigned int downR[] = {1,3,1,2};
  unsigned int side[] = {6,8,6,8};
  unsigned int upL[] = {11,12,11,13};
  unsigned int upR[] = {11,13,11,12};
  //TODO: ajouter code pour le bas
  //gestion des frames
  if(frameCounter == 0)
    player->frame = player->frame + 1;
  if(player->frame == 4)
    player->frame = 0;

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
    set_sprite_tile(SPRITE_PLAYER_BOTL, downL[player->frame]);
    set_sprite_tile(SPRITE_PLAYER_BOTR, downR[player->frame]);
    if(get_sprite_prop(SPRITE_PLAYER_BOTL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTL, 0x00U);
    if(get_sprite_prop(SPRITE_PLAYER_BOTR) == 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTR, S_FLIPX);
  }
  else if(player->dir == 2)
  {
    set_sprite_tile(SPRITE_PLAYER_BOTL, upL[player->frame]);
    set_sprite_tile(SPRITE_PLAYER_BOTR, upR[player->frame]);
    if(get_sprite_prop(SPRITE_PLAYER_BOTL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTL, 0x00U);
    if(get_sprite_prop(SPRITE_PLAYER_BOTR) == 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTR, S_FLIPX);
  }
  else if(player->dir == 3)
  {
    set_sprite_tile(SPRITE_PLAYER_BOTL, side[player->frame]);
    set_sprite_tile(SPRITE_PLAYER_BOTR, side[player->frame]+1);
    if(get_sprite_prop(SPRITE_PLAYER_BOTL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTL, 0x00U);
    if(get_sprite_prop(SPRITE_PLAYER_BOTR) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_BOTR, 0x00U);
  }
  else if(player->dir == 1)
  {
    set_sprite_tile(SPRITE_PLAYER_BOTL, side[player->frame]+1);
    set_sprite_tile(SPRITE_PLAYER_BOTR, side[player->frame]);
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
