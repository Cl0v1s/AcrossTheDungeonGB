#include "dialog.h"

void show_dialog(char* start)
{
    unsigned int i = 0;
    char line[40];
    char done = false;
    unsigned char currentLine = 0x00;
    SWITCH_ROM_MBC1(3);
    while(done == false)
    {
      //lecture du texte présent dans RMB3
      i = 0;
      line[i] = (*(start+i+currentLine*40));
      while(i != 40 && line[i] != 0x00)
      {
        i++;
        line[i] = (*(start+i+currentLine*40));
        //si la ligne contient le caractère de fin de dialogue ~ (0x7e) alors on ne cherchera pas àa afficher de prochaine ligne
        if(line[i] == 0x7e)
        {
          line[i] = 0x00;
          done = true;
        }
      }
      //si le dernier caratcère n'est pas un caractère de fin alors on le remplace par un caractère de fin
      if(i == 40)
        line[39] = 0x00;
      //on affiche le texte lu et on attends
      drawText(0,1,line);
      waitpad(J_A | J_B | J_START | J_SELECT);
      //effacement du texte précédant dans la zone
      for(i = 0; i != 40; i++)
      {
        line[i] = 0xFF;
      }
      drawText(0,1,line);
      delay(250);
      currentLine = currentLine + 1;
    }
    SWITCH_ROM_MBC1(1);
}
