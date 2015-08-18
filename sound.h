#ifndef SOUND_H
#define SOUND_H

#include <gb/gb.h>
#include <gb/hardware.h>

#define SOUND_EFFECT_OFF 0x00;

//Power on sound card
#define SOUND_ON 	NR52_REG = 0x80
//select wich channel to use (max volume too)
#define SOUND_CHANNEL_1 NR51_REG = 0x11;NR50_REG = 0x77
#define SOUND_CHANNEL_2 NR51_REG = 0x22;NR50_REG = 0x77
#define SOUND_CHANNEL_3 NR51_REG = 0x44;NR50_REG = 0x77
#define SOUND_CHANNEL_4 NR51_REG = 0x88;NR50_REG = 0x77

//channel 1
//duration (3bits): 0sweepoff, 7max  direction (1bit): 1 up, 0 down  amount (3bits): 0sweepoff, 7max 
#define SOUND_CHANNEL_1_SWEEP(direction,duration, amount) NR10_REG = duration << 4 | direction << 3 | amount
//volume (4bits) 0:no sound F:max, direction (1bit) 0: down, 1: up, duration (3bits): 0:off 7:max
#define SOUND_CHANNEL_1_ENVELOPE(volume, direction, duration) NR12_REG = volume << 4 | direction << 3 | duration
//frequency (3bits) 0:min 7:max
#define SOUND_CHANNEL_1_PLAY(frequency) 	NR13_REG=frequency;NR14_REG = 0x80U | frequency


#endif
