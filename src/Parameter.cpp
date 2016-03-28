//
//  Parameter.cpp
//  mySketch
//
//  Created by James Milton on 27/03/2016.
//
//

#include "Parameter.hpp"

Parameter::Parameter(float smoothing, float minVal, float maxVal){
    smoothingValue = smoothing;
    minValue = minVal;
    maxValue = maxVal;
}

void Parameter::update(float nextValue){
    value += (nextValue-value)*smoothingValue;
    value = ofClamp(value, minValue, maxValue);
}
