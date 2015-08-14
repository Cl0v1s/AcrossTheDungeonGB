#include "render.h"

void initRender()
{
  disableDisplay();

  SPRITES_8x8;

  loadBackground();
  loadSprites();

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

}

void loadSprites()
{
  set_sprite_data(0,10,spriteplayer);
  //chargement en mémoire video du sprite du joueur
  set_sprite_tile(SPRITE_PLAYER_TOPL, 0);
  set_sprite_tile(SPRITE_PLAYER_TOPR, 0);
  set_sprite_prop(SPRITE_PLAYER_TOPR, S_FLIPX);
  set_sprite_tile(SPRITE_PLAYER_BOTL, 1);
  set_sprite_tile(SPRITE_PLAYER_BOTR, 1);
  set_sprite_prop(SPRITE_PLAYER_BOTR, S_FLIPX);




}

void clearDisplay()
{
  box(-8,-8,160,144, SOLID);
}

void updateRender()
{
  frameCounter += 1;
  if(frameCounter == 20)
    frameCounter = 0;
}

void drawRoom(struct ActiveRoom* active)
{

}

void drawPlayer(struct Player* player)
{
  unsigned int downL[] = {1,2,1,3};
  unsigned int downR[] = {1,3,1,2};
  unsigned int side[] = {6,8,6,8};
  unsigned int upL[] = {10};
  unsigned int upR[] = {10};
  //TODO: ajouter code pour le bas

  player->dir = 1;
  //gestion des frames
  if(frameCounter == 0)
    player->frame = player->frame + 1;
  if(player->frame == 4)
    player->frame = 0;

  //gestion de la tête
  if(player->dir == 0 && get_sprite_tile(SPRITE_PLAYER_TOPL) != 0)
  {
    set_sprite_tile(SPRITE_PLAYER_TOPL, 0);
    set_sprite_tile(SPRITE_PLAYER_TOPR, 0);
    if(get_sprite_prop(SPRITE_PLAYER_TOPL) != 0x00U) //si le prop est celui par défaut
      set_sprite_prop(SPRITE_PLAYER_TOPL, 0x00U);
    if(get_sprite_prop(SPRITE_PLAYER_TOPR) == 0x00U) //si le prop est celui par défaut
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


  move_sprite(SPRITE_PLAYER_TOPL, player->x+8, player->y+16-8);
  move_sprite(SPRITE_PLAYER_TOPR, player->x+8+8, player->y+16-8);
  move_sprite(SPRITE_PLAYER_BOTL, player->x+8, player->y+16);
  move_sprite(SPRITE_PLAYER_BOTR, player->x+8+8, player->y+16);



}
