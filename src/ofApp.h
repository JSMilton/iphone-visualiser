#pragma once

#include "ofxiOS.h"
#include "Constants.h"
#include "ParticleGroup.hpp"
#include "ofxMaxim.h"
#include "ofxGui.h"
#import "AudioFile.h"

static const size_t numFrequencyBands = 18;
static const size_t fftSize = 1024;
static const size_t bufferSize = 512;
static const size_t sampleRate = 44100;
static const size_t outputChannels = 2;
static const float smoothingConstant = 0.00007;
static const float outputScaling = 1.5;

typedef enum {
    ColorModeRed = 0,
    ColorModeGreen,
    ColorModeBlue
}ColorMode;

class ofApp : public ofxiOSApp {
public:
    void setup();
    void update();
    void draw();
    void exit();

    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);

    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);

    void audioOut(ofSoundBuffer &buffer);

    void populateFrequencies();
    void changeColor();
    
    ofImage particleImage;
    ofShader shader;
    vector<ParticleGroup> groups;

    ofEasyCam camera;

    maxiFFT fft;
    
    float frequencies[numFrequencyBands];
    float smoothingValue;
    int frequencyBands[numFrequencyBands];
    
    bool playing;
    
    ofVec3f colorMax;
    ofVec3f colorMin;
    float colorScaling = 0.0;
    float colorTimestamp = 0.0;
    int colorMode = ColorModeRed;
    
    AudioFile *aFile;
    
    ofxPanel gui;
    ofxFloatSlider slider;
    
    
};


