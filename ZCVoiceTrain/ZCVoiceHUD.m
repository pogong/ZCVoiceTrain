//
//  ZCVoiceHUD.m
//  ZCVoiceTrain
//
//  Created by 张三弓 on 16/4/18.
//  Copyright © 2016年 张三弓. All rights reserved.
//

#import "ZCVoiceHUD.h"

@interface ZCVoiceHUD()
@property (weak, nonatomic) IBOutlet UILabel *downLB;

@end

@implementation ZCVoiceHUD

+ (ZCVoiceHUD*)sharedView {
    static dispatch_once_t once;
    static ZCVoiceHUD * sharedView;
    dispatch_once(&once, ^ {
        NSArray * nibs = [[NSBundle mainBundle] loadNibNamed:@"ZCVoiceHUD"owner:nil options:nil];
        sharedView = [nibs objectAtIndex:0];
        sharedView.backgroundColor = [UIColor clearColor];
        sharedView.frame = [AppDelegate shareAppDelegate].window.bounds;
        [[AppDelegate shareAppDelegate].window addSubview:sharedView];
    });
    return sharedView;
}

+(void)disMiss
{
    [self sharedView].alpha = 0.0;
}

+(void)showLevel:(NSInteger)level
{
    [self show];
    [self sharedView].downLB.text = [NSString stringWithFormat:@"音量%d",level];
}

+(void)showFail
{
    [self show];
    [self sharedView].downLB.text = @"录制出错";
}

+(void)showWillSend
{
    [self show];
    [self sharedView].downLB.text = @"松开手指,取消发送";
}

+(void)show
{
    [self sharedView].alpha = 1.0;
}

@end
