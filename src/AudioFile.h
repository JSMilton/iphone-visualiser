//
//  AudioFile.h
//  mySketch
//
//  Created by Willis on 27/03/2016.
//
//

#import <Foundation/Foundation.h>

@interface AudioFile : NSObject

@property (nonatomic, getter=isStereo) BOOL stereo;

- (void)loadFile:(NSString *)filename;
- (Float32)playLeft;
- (Float32)playRight;

@end
