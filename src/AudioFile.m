//
//  AudioFile.m
//  mySketch
//
//  Created by Willis on 27/03/2016.
//
//

#import "AudioFile.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AudioFile
{
    Float32 *leftData;
    Float32 *rightData;
    int channelCount;
    UInt64 totalFrames;
    UInt64 sampleCountLeft;
    UInt64 sampleCountRight;
}

- (instancetype)init
{
    if (self = [super init]){
        leftData = 0;
        rightData = 0;
        channelCount = 0;
        totalFrames = 0;
        sampleCountLeft = 0;
        sampleCountRight = 0;
    }
    return self;
}

- (void)loadFile:(NSString *)filename
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    if (!url){
        NSLog(@"no file named %@ found", filename);
        return;
    }
    
    ExtAudioFileRef audioFileObject = 0;
    OSStatus result = ExtAudioFileOpenURL ((CFURLRef)url, &audioFileObject);
    
    if (noErr != result) {
        NSLog(@"Error: Failed to read audio file at url");
        return;
    }
    
    totalFrames = 0;
    UInt32 frameLengthPropertySize = sizeof (totalFrames);
    
    result =    ExtAudioFileGetProperty (
                                         audioFileObject,
                                         kExtAudioFileProperty_FileLengthFrames,
                                         &frameLengthPropertySize,
                                         &totalFrames
                                         );
    
    
    if (noErr != result) {
        NSLog(@"Error: ExtAudioFileGetProperty");
        return;
    }
    
    AudioStreamBasicDescription fileAudioFormat = {0};
    UInt32 formatSize = sizeof(fileAudioFormat);
    
    result =    ExtAudioFileGetProperty (
                                         audioFileObject,
                                         kExtAudioFileProperty_FileDataFormat,
                                         &formatSize,
                                         &fileAudioFormat
                                         );
    
    channelCount = fileAudioFormat.mChannelsPerFrame;
    self.stereo = channelCount == 2;
    
    AudioStreamBasicDescription importFormat = {0};
    importFormat.mFormatID          = kAudioFormatLinearPCM;
    importFormat.mFormatFlags       = kAudioFormatFlagIsFloat | kAudioFormatFlagIsNonInterleaved | kAudioFormatFlagIsPacked;
    importFormat.mBytesPerPacket    = 4;
    importFormat.mFramesPerPacket   = 1;
    importFormat.mBytesPerFrame     = 4;
    importFormat.mChannelsPerFrame  = 1;
    importFormat.mBitsPerChannel    = 32;
    importFormat.mSampleRate        = 44100;
    
    leftData = (Float32 *) calloc (totalFrames, sizeof (Float32));
    if (channelCount == 2){
        rightData = (Float32 *) calloc (totalFrames, sizeof (Float32));
        importFormat.mChannelsPerFrame = 2;
    }
    
    result =    ExtAudioFileSetProperty (
                                         audioFileObject,
                                         kExtAudioFileProperty_ClientDataFormat,
                                         &formatSize,
                                         &importFormat
                                         );
    
    AudioBufferList *bufferList;
    
    bufferList = (AudioBufferList *) malloc (
                                             sizeof (AudioBufferList) + sizeof (AudioBuffer) * (channelCount - 1)
                                             );
    
    bufferList->mNumberBuffers = channelCount;
    
    AudioBuffer emptyBuffer = {0};
    size_t arrayIndex;
    for (arrayIndex = 0; arrayIndex < channelCount; arrayIndex++) {
        bufferList->mBuffers[arrayIndex] = emptyBuffer;
    }
    
    bufferList->mBuffers[0].mNumberChannels  = 1;
    bufferList->mBuffers[0].mDataByteSize    = totalFrames * sizeof (Float32);
    bufferList->mBuffers[0].mData            = leftData;
    
    if (2 == channelCount) {
        bufferList->mBuffers[1].mNumberChannels  = 1;
        bufferList->mBuffers[1].mDataByteSize    = totalFrames * sizeof (Float32);
        bufferList->mBuffers[1].mData            = rightData;
    }
    
    UInt32 numberOfPacketsToRead = (UInt32)totalFrames;
    
    result = ExtAudioFileRead (
                               audioFileObject,
                               &numberOfPacketsToRead,
                               bufferList
                               );
    
    free (bufferList);
    
    if (noErr != result) {
        free (leftData);
        leftData = 0;
        if (2 == channelCount) {
            free (rightData);
            rightData = 0;
        }
        
        ExtAudioFileDispose (audioFileObject);
        return;
    }
    
    sampleCountLeft = 0;
    sampleCountRight = 0;
    ExtAudioFileDispose (audioFileObject);
}

- (Float32)playLeft
{
    Float32 sample = leftData[sampleCountLeft];
    sampleCountLeft++;
    if (sampleCountLeft == totalFrames){
        sampleCountLeft = 0;
    }
    return sample;
}

- (Float32)playRight
{
    Float32 sample = rightData[sampleCountRight];
    sampleCountRight++;
    if (sampleCountRight == totalFrames){
        sampleCountRight = 0;
    }
    return sample;
}

@end
