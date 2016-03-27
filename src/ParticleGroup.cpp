//
//  ParticleGroup.cpp
//  mySketch
//
//  Created by James Milton on 16/01/2016.
//
//

#include "ParticleGroup.hpp"
#include "MathUtility.hpp"

ParticleGroup::ParticleGroup(ofVec3f startPos, ofVec3f endPos, float rndNumber) {
    
    float mod = 5;
    float start = -5;
    float end = 2;
    float maxValue = MathUtility::Gaussian(0, 0, mod);
    float minValue = MathUtility::Gaussian(-5, 0, mod);
    
    for (size_t i = 0; i < NUM_PARTICLES; i++){
        float offset = (float)i / NUM_PARTICLES;
        ofVec3f interp = startPos;
        particles.emplace_back(ofVec3f(interp.interpolate(endPos, offset)), ofVec3f(0));
        vboMesh.addVertex(particles.back().position);
        
        float x = ofMap(i, 0, NUM_PARTICLES, start, end);
        float y = MathUtility::Gaussian(x, 0, mod);
        float scale = ofMap(y, minValue, maxValue, 0, 1.0);
        scalingConstants.emplace_back(scale);
    }
    
    startPosition = startPos;
    randomNumber = rndNumber;
    
    vboMesh.setUsage(GL_DYNAMIC_DRAW);
    vboMesh.setMode(OF_PRIMITIVE_POINTS);
    
    random2 = rand() / RAND_MAX;
    
    color = ofVec3f(0.95,0.5,0.5);
    
    timeOffset = 0;
}

void ParticleGroup::updatePositions(float elapsedTime) {
    float combinedAmp = amplitudeModifierBass;// (amplitudeModifierBass+amplitudeModifierMid+amplitudeModifierTreble) / 3;
    for (size_t i = 0; i < NUM_PARTICLES; i++){
        float noise = ofNoise((float)i/NUM_PARTICLES+timeOffset, randomNumber) * combinedAmp * scalingConstants[i];
        ofVec3f pos = ofVec3f(particles[i].position.x, particles[i].position.y, 0).getScaled(startPosition.length()+noise);
        pos.z = particles[i].position.z;
        particles[i].position.set(pos);
        vboMesh.getVertices()[i].set(particles[i].position);
    }
}

void ParticleGroup::updateAmplitude(float bass, float mid, float treble) {
//    amplitudeModifierBass += bass;
//    amplitudeModifierMid += mid;
//    amplitudeModifierTreble += treble;
//    amplitudeModifierBass *= 0.95;
//    amplitudeModifierMid *= 0.95;
//    amplitudeModifierTreble *= 0.95;
//    amplitudeModifierBass = ofClamp(amplitudeModifierBass, MIN_MOVEMENT, MAX_MOVEMENT);
//    amplitudeModifierMid = ofClamp(amplitudeModifierMid, MIN_MOVEMENT, MAX_MOVEMENT);
//    amplitudeModifierTreble = ofClamp(amplitudeModifierTreble, MIN_MOVEMENT, MAX_MOVEMENT);
}

void ParticleGroup::updateNoise(float freqPower){
    timeOffset += ofMap(freqPower, 0, MAX_DECIBEL_INPUT, MIN_NOISE_TIMESTEP, MAX_NOISE_TIMESTEP);
    amplitudeModifierBass += freqPower*0.1;
    amplitudeModifierBass *= 0.965;
    amplitudeModifierBass = ofClamp(amplitudeModifierBass, MIN_MOVEMENT, MAX_MOVEMENT);
}

void ParticleGroup::draw() {
    vboMesh.draw();
}

