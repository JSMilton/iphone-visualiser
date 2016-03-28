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
#include "ofMath.h"

class Parameter {
public:
    Parameter(){};
    Parameter(float smoothing, float minVal, float maxVal);
    
    void update(float nextValue);
    
    float value;
    
private:
    float smoothingValue;
    float maxValue;
    float minValue;
};

#endif /* Parameter_hpp */
