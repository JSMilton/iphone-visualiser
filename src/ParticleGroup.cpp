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
    
    float mod = 4;
    float start = -5;
    float end = 0;
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
    target = 0;
    velocity = 0;
    
    amplitude = Parameter(0.05, MIN_MOVEMENT, MAX_MOVEMENT);
    noise = Parameter(0.0025, MIN_NOISE_TIMESTEP, MAX_NOISE_TIMESTEP);
}

void ParticleGroup::updatePositions(float elapsedTime) {
    for (size_t i = 0; i < NUM_PARTICLES; i++){
        float noise = ofNoise((float)i/NUM_PARTICLES+timeOffset, randomNumber) * amplitude.value * scalingConstants[i];
        ofVec3f pos = ofVec3f(particles[i].position.x, particles[i].position.y, 0).getScaled(startPosition.length()+noise);
        pos.z = particles[i].position.z;
        particles[i].position.set(pos);
        vboMesh.getVertices()[i].set(particles[i].position);
    }
}

void ParticleGroup::updateParameters(float value){
    amplitude.update(value);
    noise.update(value);
    particleSize = ofMap(value, 0, MAX_DECIBEL_INPUT, MIN_PARTICLE_SIZE, MAX_PARTICLE_SIZE);
    
    timeOffset += noise.value;
}


void ParticleGroup::draw() {
    vboMesh.draw();
}

