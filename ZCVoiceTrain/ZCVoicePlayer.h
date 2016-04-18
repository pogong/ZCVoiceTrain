//
//  ZCVoicePlayer.h
//  ZCVoiceTrain
//
//  Created by 张三弓 on 16/4/17.
//  Copyright © 2016年 张三弓. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger)
{
    ZCPlayStateNone=1,//未加载
    ZCPlayStatePlaying,//正在播放
    ZCPlayStatePause,//暂停
}ZCPlayState;

@interface ZCVoicePlayer : NSObject

@property(copy,nonatomic)NSString * curStr;
@property(assign,nonatomic)ZCPlayState state;

+(instancetype)shareVoicePlayer;
-(void)stop;
-(void)playStr:(NSString *)str;

@end
