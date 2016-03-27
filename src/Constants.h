//
//  Constants.h
//  mySketch
//
//  Created by James Milton on 16/01/2016.
//
//

#ifndef Constants_h
#define Constants_h

#define STRAND_SIZE 2
#define NUM_GROUPS 36
#define NUM_PARTICLES 300
#define MAX_PARTICLE_SIZE 8
#define MIN_PARTICLE_SIZE 2
#define MAX_MOVEMENT 50.0
#define MIN_MOVEMENT 5.0
#define MAX_NOISE_TIMESTEP 0.01
#define MIN_NOISE_TIMESTEP 0.005
#define FIELD_SPEED 200.0
#define AMPLITUDE_VELOCITY 5.0
#define MIN_COLOR 0.2
#define MID_COLOR 0.5
#define MAX_COLOR 1
#define MAX_DECIBEL_INPUT 40
#define COLOR_TIMER 10 //seconds

#define RandBell(scale) (scale * (1.0f - (rand() + rand() + rand()) / ((float) RAND_MAX * 1.5f)))

#endif /* Constants_h */
