//
//  Particle.hpp
//  mySketch
//
//  Created by James Milton on 03/02/2016.
//
//

#ifndef Particle_hpp
#define Particle_hpp

#include <stdio.h>
#include "ofMain.h"

class Particle {
public:
    Particle(ofVec3f pos, ofVec3f vel):position(pos), velocity(vel){};
    
    ofVec3f position;
    ofVec3f velocity;
};

#endif /* Particle_hpp */
