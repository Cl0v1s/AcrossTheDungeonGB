#include "helper.h"

unsigned int random(const unsigned int min, const unsigned int max)
{
  return (rand() % (max-min)) + min;
}
