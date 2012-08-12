//
//  VelovManager.m
//  QuickVelov
//
//  Created by AW2P on 10/08/12.
//  Copyright (c) 2012 AW2P. All rights reserved.
//

#import "VelovManager.h"

@implementation VelovManager

@synthesize stations = _stations;

- (id)init
{
    if (self = [super init])
    {
        _stations = [[NSMutableArray alloc] init];
        
        _values = [[NSMutableArray alloc] init];
        for (int i=0; i<=kMaxNumbers; i++)
        {
            [_values addObject:[self loadSound:[NSString stringWithFormat:@"%d", i]]];
        }
        [_values addObject:[self loadSound:@"X"]];
        
        _sounds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeAllStations
{
    [_stations removeAllObjects];
}

- (NSDictionary*)addStation:(int)stationId name:(NSString*)name
{
    NSString* urlString = [NSString stringWithFormat:@"http://www.velov.grandlyon.com/velovmap/zhp/inc/DispoStationsParId.php?id=%d", stationId];
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", str);
    
    int freeIndex = [str rangeOfString:@"<free>"].location;
    int freeValue = [[str substringFromIndex:freeIndex + 6] intValue];
    
    int availableIndex = [str rangeOfString:@"<available>"].location;
    int availableValue = [[str substringFromIndex:availableIndex + 11] intValue];
    
    NSMutableDictionary* station = [[NSMutableDictionary alloc] init];
    
    [station setObject:name forKey:@"name"];
    [station setObject:[NSNumber numberWithInt:freeValue] forKey:@"free"];
    [station setObject:[NSNumber numberWithInt:availableValue] forKey:@"available"];
    
    [station setObject:[self loadSound:name] forKey:@"sound"];
    
    [_stations addObject:station];
    
    return station;
}

- (void)startTalking
{
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    _wasPlaying = musicPlayer.playbackState == MPMusicPlaybackStatePlaying;
    _oldVolume = musicPlayer.volume;
    [musicPlayer pause];
    
    musicPlayer.volume = 1.0;
    
    [_sounds removeAllObjects];
    for (NSDictionary* station in _stations)
    {
        AVAudioPlayer* sound = (AVAudioPlayer*)[station objectForKey:@"sound"];
        assert(sound != nil);
        
        [_sounds addObject:sound];
        
        int free = [[station objectForKey:@"free"] intValue];
        sound = [_values objectAtIndex:MIN(free, kMaxNumbers + 1)];
        [_sounds addObject:sound];
    }
    
    [self playNextSound];
}

- (void)stopTalking
{
    [_sounds removeAllObjects];
    
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    musicPlayer.volume = _oldVolume;
    if (_wasPlaying)
    {
        [musicPlayer play];
    }
}

- (void)playNextSound
{
    if ([_sounds count])
    {
        AVAudioPlayer* sound = [_sounds objectAtIndex:0];
        [_sounds removeObjectAtIndex:0];
        
        [sound play];

        [self performSelector:@selector(playNextSound) withObject:nil afterDelay:sound.duration];
    }
    else
    {
        [self stopTalking];
    }
}

- (AVAudioPlayer*)loadSound:(NSString*)name
{
    NSString* fileName = [NSString stringWithFormat:@"%@.m4a", name];
    NSString* filePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:fileName];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    AVAudioPlayer* sound = [[AVAudioPlayer alloc] initWithData:data error:nil];
    sound.volume = 1.0f;
    return sound;
}


@end
