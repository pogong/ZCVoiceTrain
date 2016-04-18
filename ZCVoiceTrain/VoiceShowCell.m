//
//  VoiceShowCell.m
//  ZCVoiceTrain
//
//  Created by 张三弓 on 16/4/17.
//  Copyright © 2016年 张三弓. All rights reserved.
//

#import "VoiceShowCell.h"

@implementation VoiceShowCell

-(NSArray *)animationByTargetImageArr
{
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 1; i<=3; i++) {
        NSString * name = [NSString stringWithFormat:@"voice_bytarget_ animation_%d",i];
        UIImage * image = [UIImage imageNamed:name];
        [arr addObject:image];
        [arr addObject:image];
        [arr addObject:image];
    }
    return arr;
}

- (void)awakeFromNib {
    // Initialization code
    
    _staticIM.image = [UIImage imageNamed:@"voice_bytarget_static"];
    
    _animationIM.animationImages = [self animationByTargetImageArr];
    
    _animationIM.hidden = YES;
    
    [[ZCVoicePlayer shareVoicePlayer] addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAct)];
    [self.contentView addGestureRecognizer:tap];
    
}

-(void)tapAct
{
    if ([ZCVoicePlayer shareVoicePlayer].state == ZCPlayStatePlaying) {
        if ([[ZCVoicePlayer shareVoicePlayer].curStr isEqualToString:_titleLB.text]) {
            [[ZCVoicePlayer shareVoicePlayer] stop];
        }else{
            [[ZCVoicePlayer shareVoicePlayer] playStr:_titleLB.text];
        }
    }else{
       [[ZCVoicePlayer shareVoicePlayer] playStr:_titleLB.text];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        [self updateShowState];
    }
}

-(void)updateShowState
{
    if ([ZCVoicePlayer shareVoicePlayer].state == ZCPlayStatePlaying) {
        if ([[ZCVoicePlayer shareVoicePlayer].curStr isEqualToString:_titleLB.text]) {
            [self isPlaying:YES];
        }else{
            [self isPlaying:NO];
        }
    }else{
         [self isPlaying:NO];
    }
}

-(void)isPlaying:(BOOL)yesORno
{
    if (yesORno) {
        _staticIM.hidden = YES;
        _animationIM.hidden = NO;
        [_animationIM startAnimating];
    }else{
        _staticIM.hidden = NO;
        [_animationIM stopAnimating];
         _animationIM.hidden = YES;
    }
}

-(void)setPathTwo:(NSString *)pathTwo
{
    _pathTwo = pathTwo;
    _titleLB.text = _pathTwo;
    [self updateShowState];
}

-(void)dealloc
{
    [[ZCVoicePlayer shareVoicePlayer] removeObserver:self forKeyPath:@"state"];
}

@end
