//
//  ZCVoicePlayer.m
//  ZCVoiceTrain
//
//  Created by 张三弓 on 16/4/17.
//  Copyright © 2016年 张三弓. All rights reserved.
//

#import "ZCVoicePlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ZCVoicePlayer()<AVAudioPlayerDelegate>

@end

@implementation ZCVoicePlayer
{
    AVAudioPlayer * _voicePlayer;
    NSString * _pathOne;
}
+(instancetype)shareVoicePlayer{
    static id one = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        one = [[self alloc]init];
    });
    return one;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _pathOne = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        _state = ZCPlayStatePause;
    }
    return self;
}

-(void)stop
{
    [_voicePlayer stop];
    self.curStr = @"";
    self.state = ZCPlayStatePause;
}

-(void)realPlayStr:(NSString *)str
{
    self.curStr = str;
    NSString * inPath = [NSString stringWithFormat:@"%@/%@",_pathOne,str];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    _voicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:inPath] error:nil];
    _voicePlayer.delegate = self;
    [_voicePlayer play];
    self.state = ZCPlayStatePlaying;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.curStr = @"";
    self.state = ZCPlayStatePause;
}

-(void)playStr:(NSString *)str
{
    if (str.length <= 0) {
        [self stop];
        return;
    }
    
    if (_state == ZCPlayStatePlaying) {
        [_voicePlayer stop];
        self.state = ZCPlayStatePause;
        
        [self realPlayStr:str];
    }else{
        [self realPlayStr:str];
    }
}

@end
