//
//  Parameter.hpp
//  mySketch
//
//  Created by James Milton on 27/03/2016.
//
//

#ifndef Parameter_hpp
#define Parameter_hpp

#include <stdio.h>

class Parameter {
public:
    Parameter(){};
    Parameter(float accel, float maxVal, float minVal);
    
    void update(float nextValue);
    
    float value;
    
private:
    float velocity;
    float acceleration;
    float maxValue;
    float minVale;
};

#endif /* Parameter_hpp */
