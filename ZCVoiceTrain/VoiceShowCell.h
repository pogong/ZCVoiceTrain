//
//  VoiceShowCell.h
//  ZCVoiceTrain
//
//  Created by 张三弓 on 16/4/17.
//  Copyright © 2016年 张三弓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceShowCell : UITableViewCell

@property(nonatomic,copy)NSString * pathTwo;

@property (weak, nonatomic) IBOutlet UIImageView *animationIM;
@property (weak, nonatomic) IBOutlet UIImageView *staticIM;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@end
