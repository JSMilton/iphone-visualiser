#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofEnableBlendMode(OF_BLENDMODE_ADD);
    ofSetBackgroundColor(0);
    particleImage = ofImage("particle2.png");
    
    float distance = ofGetWidth();
    
    float halfSize = STRAND_SIZE/2;
    for (size_t i = 0; i < NUM_GROUPS; i++){
        float offset = ofMap(i, 0, NUM_GROUPS, 0, TWO_PI);
        ofVec3f startPos = ofVec3f(halfSize*cos(offset), halfSize*sin(offset), 0);
        ofVec3f endPos = ofVec3f(startPos.x,startPos.y,distance);
        groups.emplace_back(startPos, endPos, rand() % 10);
    }
    
    shader.load("shader");
    
    force = 0.0;
    velocity = MIN_MOVEMENT;
    
    camera.setDrag(0);
    camera.setDistance(distance/1.5);
    camera.setTarget(ofVec3f(0,0,0));
    
    ofVec3f initialPosition = camera.getPosition().getRotated(2, ofVec3f(0.5,1,1));
    
    camera.setPosition(initialPosition);
    camera.lookAt(ofVec3f(0));
    
    fft.setup(fftSize, bufferSize, bufferSize/2);
    ofxMaxiSettings::setup(sampleRate, outputChannels, bufferSize);
    ofSoundStreamSetup(outputChannels, 0, sampleRate, bufferSize, 4);
    
    smoothingValue =  powf(smoothingConstant,
                          (float)(bufferSize) /
                          (float)(sampleRate));
    
    frequencyBands[0] = 0;
    for (size_t i = 1; i < numFrequencyBands; i++){
        frequencyBands[i] = round(pow(2, log2(bufferSize)*(i/(float)numFrequencyBands)));
    }
    
    playing = false;
    touchInterval = 0;
    
    colorMax = ofVec3f(MAX_COLOR, MID_COLOR, MID_COLOR);
    colorMin = ofVec3f(MAX_COLOR, MIN_COLOR, MIN_COLOR);
    
    colorScaling = 1;
    colorMode = ColorModeBlue;
    
    aFile = [AudioFile new];
    [aFile loadFile:@"liszt.mp3"];
}

void ofApp::changeColor() {
    if (ofGetElapsedTimef() > colorTimestamp+COLOR_TIMER){
        colorTimestamp = ofGetElapsedTimef();
        colorMode++;
        if (colorMode > 2){
            colorMode = 0;
        }
        
        colorScaling = 0.0;
    }
    
    if (colorScaling <= 1){
        float newMax = ofMap(colorScaling, 0, 1, MID_COLOR, MAX_COLOR);
        float oldMax = ofMap(1-colorScaling, 0, 1, MID_COLOR, MAX_COLOR);
        float newMin = ofMap(colorScaling, 0, 1, MIN_COLOR, MAX_COLOR);
        float oldMin = ofMap(1-colorScaling, 0, 1, MIN_COLOR, MID_COLOR);
        switch (colorMode) {
            case ColorModeRed:
                colorMax.set(newMax, MID_COLOR, oldMax);
                colorMin.set(newMin, MIN_COLOR, oldMin);
                break;
            case ColorModeGreen:
                colorMax.set(oldMax, newMax, MID_COLOR);
                colorMin.set(oldMin, newMin, MIN_COLOR);
                break;
            case ColorModeBlue:
                colorMax.set(MID_COLOR, oldMax, newMax);
                colorMin.set(MIN_COLOR, oldMin, newMin);
                break;
            default:
                break;
        }
        
        colorScaling += 0.005;
    }
}

//--------------------------------------------------------------
void ofApp::update(){

    changeColor();
    
    //if (playing){
        //updateVelocity();
        
        //float freqMod = ofMap(touchEvent.x, 0, ofGetWidth(), MIN_FREQUENCY, MAX_FREQUENCY);
        float amplitudeBass = (frequencies[0]+frequencies[1]+frequencies[2]+frequencies[3]) / 4;
    float amplitudeMid = (frequencies[4]+frequencies[5]+frequencies[6]+frequencies[7]+frequencies[8]+frequencies[9]+frequencies[10]+frequencies[11]) / 8;
    float amplitudeTreble = (frequencies[12]+frequencies[13]+frequencies[14]+frequencies[15]+frequencies[16]+frequencies[17]) / 6;
    
        
        for (size_t i = 0; i < groups.size(); i++){
            ParticleGroup &g = groups[i];
            float freq = frequencies[i%numFrequencyBands];
            g.particleSize = ofMap(freq, 0, MAX_DECIBEL_INPUT, MIN_PARTICLE_SIZE, MAX_PARTICLE_SIZE);
            
            float red = ofMap(freq, 0, MAX_DECIBEL_INPUT, colorMin.x, colorMax.x);
            float green = ofMap(freq, 0, MAX_DECIBEL_INPUT, colorMin.y, colorMax.y);
            float blue = ofMap(freq, 0, MAX_DECIBEL_INPUT, colorMin.z, colorMax.z);
            g.color = ofVec3f(red, green, blue);
            //g.color = ofVec3f(0.4, 0.4, 1);
            g.updateAmplitude(amplitudeBass,amplitudeMid,amplitudeTreble);
            g.updateNoise(freq);
            g.updatePositions(ofGetElapsedTimef());
        }

    //}
}

//--------------------------------------------------------------
void ofApp::draw(){
    camera.begin();
    shader.begin();
    particleImage.bind();
    
    for (auto &g: groups){
        shader.setUniform3f("color", g.color);
        shader.setUniform1f("pointSize", g.particleSize);
        g.draw();
    }
    particleImage.unbind();
    shader.end();
    camera.end();
}

void ofApp::updateVelocity() {
    velocity += force;
    velocity = MIN(MAX_MOVEMENT, velocity);
    velocity = MAX(MIN_MOVEMENT, velocity);
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

void ofApp::audioOut(ofSoundBuffer &buffer){
    //if (playing){
        for (size_t i = 0; i < buffer.size(); i+=2){
            float sampleLeft = [aFile playLeft];
            float sampleRight = aFile.isStereo ? [aFile playRight] : sampleLeft;
            buffer[i] = sampleLeft;
            buffer[i+1] = sampleRight;
            
//            buffer[i] = 0;
//            buffer[i+1] = 0;
            
            fft.process(sampleLeft+sampleRight);
        }
        
        populateFrequencies();
//    } else {
//        memset(&buffer, 0, buffer.size());
//    }
}

void ofApp::populateFrequencies() {
    fft.magsToDB();
    size_t frequencyIndex = 0;
    float maxPower = 0.0;
    for (size_t i = 0; i < fft.bins; i++){
        if (fft.magnitudesDB[i] > maxPower){
            maxPower = fft.magnitudesDB[i];
        }
        
        if (i == frequencyBands[frequencyIndex]){
            frequencies[frequencyIndex] = frequencies[frequencyIndex] * smoothingValue + (maxPower * outputScaling * (1.0-smoothingValue));
            maxPower = 0.0;
            frequencyIndex++;
        }
    }
}
