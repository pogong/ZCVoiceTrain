//
//  ZCVoiceHUD.h
//  ZCVoiceTrain
//
//  Created by 张三弓 on 16/4/18.
//  Copyright © 2016年 张三弓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCVoiceHUD : UIView

+(void)disMiss;
+(void)showLevel:(NSInteger)level;
+(void)showFail;
+(void)showWillSend;

@end
