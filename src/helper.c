#include "helper.h"

unsigned char random(const unsigned int min, const unsigned int max)
{
  return (rand() % (max-min)) + min;
}
