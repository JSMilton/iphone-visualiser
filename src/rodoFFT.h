//
//  FFT.h
//  mySketch
//
//  Created by Willis on 27/03/2016.
//
//

#import <Foundation/Foundation.h>

@interface rodoFFT : NSObject

@property (strong, nonatomic) NSArray *frequencyBands;

- (instancetype)initWithFFTSize:(int)fftSize
                     windowSize:(int)windowSize
                        hopSize:(int)hopSize;

- (void)processSample:(Float32)sample;
- (void)organiseFrequencyBands;

@end
