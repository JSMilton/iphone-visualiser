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
    UInt64 sampleCount;
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
    
    result =    ExtAudioFileGetProperty (
                                         audioFileObject,
                                         kExtAudioFileProperty_FileLengthFrames,
                                         sizeof (totalFrames),
                                         &totalFrames
                                         );
    
    if (noErr != result) {
        NSLog(@"Error: ExtAudioFileGetProperty");
        return;
    }
    
    AudioStreamBasicDescription fileAudioFormat = {0};
    
    result =    ExtAudioFileGetProperty (
                                         audioFileObject,
                                         kExtAudioFileProperty_FileDataFormat,
                                         sizeof (fileAudioFormat),
                                         &fileAudioFormat
                                         );
    
    channelCount = fileAudioFormat.mChannelsPerFrame;
    
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
                                         sizeof (importFormat),
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
    
    sampleCount = 0;
    ExtAudioFileDispose (audioFileObject);
}

@end
