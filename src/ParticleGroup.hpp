//
//  ParticleGroup.hpp
//  mySketch
//
//  Created by James Milton on 16/01/2016.
//
//

#ifndef ParticleGroup_hpp
#define ParticleGroup_hpp

#include <stdio.h>
#include "ofMain.h"
#include "Constants.h"
#include "Particle.hpp"
#include "Parameter.hpp"

class ParticleGroup {
public:
    ParticleGroup(){};
    ParticleGroup(ofVec3f startPos, ofVec3f endPos, float rndNumber);
    
    void draw();
    void updatePositions(float elapsedTime);
    void updateParameters(float value);
    
    vector<Particle>particles;
    
    ofVec3f color;
    
    Parameter amplitude;
    Parameter noise;
    float particleSize;
    
private:
    float startZ = 200.0;
    float startY;
    ofVec3f startPosition;
    float randomNumber;
    float random2;
    float reverseModifier = 1.0;
    float amplitudeModifierBass = MIN_MOVEMENT;
    float amplitudeModifierMid = MIN_MOVEMENT;
    float amplitudeModifierTreble = MIN_MOVEMENT;
    float timeOffset;
    float velocity;
    float target;
    
    ofVboMesh vboMesh;
    vector<float>scalingConstants;
};

#endif /* ParticleGroup_hpp */
