//
//  MathUtility.hpp
//  mySketch
//
//  Created by James Milton on 24/01/2016.
//
//

#ifndef MathUtility_hpp
#define MathUtility_hpp

#include <stdio.h>
#include <math.h>

namespace MathUtility {
    static float Gaussian(float x, float mean, float variance) {
        float dx = x - mean;
        return (1.f / sqrtf(M_PI * 2 * variance)) * expf(-(dx * dx) / (2 * variance));
    }
}

#endif /* MathUtility_hpp */
