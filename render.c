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
  set_sprite_data(0,4,spriteplayer);
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
  //affichage du sprite du joueur
  move_sprite(SPRITE_PLAYER_TOPL, player->x+8, player->y-8+16); //le +8 et +16 est là pour corriger un curieux probleme de positionnement de la gameboy (0,0) est en (8,16)
  move_sprite(SPRITE_PLAYER_BOTL, player->x+8, player->y+16);
  move_sprite(SPRITE_PLAYER_TOPR, player->x+8+8, player->y-8+16); //le +8 et +16 est là pour corriger un curieux probleme de positionnement de la gameboy (0,0) est en (8,16)
  move_sprite(SPRITE_PLAYER_BOTR, player->x+8+8, player->y+16);
  if(frameCounter == 0)
    player->frame += 1;
  switch(player->frame)
  {
    case 0:
    set_sprite_tile(SPRITE_PLAYER_BOTL, 2);
    set_sprite_tile(SPRITE_PLAYER_BOTR, 3);
    break;
    case 1:
    set_sprite_tile(SPRITE_PLAYER_BOTL, 1);
    set_sprite_tile(SPRITE_PLAYER_BOTR, 1);
    break;
    case 2:
    set_sprite_tile(SPRITE_PLAYER_BOTL, 3);
    set_sprite_tile(SPRITE_PLAYER_BOTR, 2);
    break;
    case 3:
    set_sprite_tile(SPRITE_PLAYER_BOTL, 1);
    set_sprite_tile(SPRITE_PLAYER_BOTR, 1);
    break;
    default:
    player->frame = 0;
    break;
  }
}
