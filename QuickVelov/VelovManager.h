//
//  VelovManager.h
//  QuickVelov
//
//  Created by AW2P on 10/08/12.
//  Copyright (c) 2012 AW2P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <MediaPlayer/MPMusicPlayerController.h>

#define kMaxNumbers    5

@interface VelovManager : NSObject
{
    NSMutableArray* _stations;
    NSMutableArray* _values;
    NSMutableArray* _sounds;
    
    float _oldVolume;
    BOOL _wasPlaying;
}

@property (readonly, strong) NSMutableArray* stations;

- (void)removeAllStations;
- (NSDictionary*)addStation:(int)stationId name:(NSString*)name;
- (void)startTalking;
- (void)stopTalking;

- (void)playNextSound;
- (AVAudioPlayer*)loadSound:(NSString*)name;

@end
