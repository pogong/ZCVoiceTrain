//
//  ViewController.m
//  ZCVoiceTrain
//
//  Created by 张三弓 on 16/4/17.
//  Copyright © 2016年 张三弓. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SomeVoiceController.h"

@interface ViewController ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer * _voicePlayer;
    AVAudioRecorder * _voiceRecorder;
    
    NSDictionary * _recordSet;
    NSString * _inPath;
	BOOL _isRecording;
}
@end

@implementation ViewController

-(void)xxAct
{
    SomeVoiceController * some =[[SomeVoiceController alloc]init];
    [self.navigationController pushViewController:some animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"xx" style:UIBarButtonItemStylePlain target:self action:@selector(xxAct)];
    
    NSString * pathOne = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSLog(@"%@",pathOne);
    
    _recordSet = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                nil];
    
}

- (void)updatePowerLevel
{
	if (_isRecording == NO) {
		return;
	}
	[_voiceRecorder updateMeters];
	CGFloat levelMeter = ([_voiceRecorder peakPowerForChannel:0]+160)/160.0;
	NSInteger level = 0;
	if(levelMeter <= 0.2)
	{
		level = 1;
	}
	else if(levelMeter <=0.4 &&levelMeter >0.2)
	{
		level = 2;
	}
	else if(levelMeter <=0.6 &&levelMeter >0.4)
	{
		level = 3;
	}
	else if(levelMeter <=0.8 &&levelMeter >0.6)
	{
		level = 4;
	}
	else if(levelMeter >0.8)
	{
		level = 5;
	}
	NSLog(@"up_show_level_%d",level);
	[self performSelector:@selector(updatePowerLevel) withObject:nil afterDelay:0.25];
}

- (IBAction)recordAct:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"停止"]) {
		_isRecording = NO;
        [_voiceRecorder pause];
        NSInteger howl = _voiceRecorder.currentTime;
        NSLog(@"---%d",howl);
        [_voiceRecorder stop];
        [sender setTitle:@"录音" forState:UIControlStateNormal];
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }else{
        NSString * pathOne = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        _inPath = [NSString stringWithFormat:@"%@/%d.wav",pathOne,(int)[[NSDate date] timeIntervalSince1970]];
        _voiceRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:_inPath]
                                                    settings:_recordSet
                                                       error:nil];
        if ([_voiceRecorder prepareToRecord]){
            
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            
            //开始录音
            if ([_voiceRecorder record]){
				_isRecording = YES;
				[self updatePowerLevel];
                [sender setTitle:@"停止" forState:UIControlStateNormal];
            }
        }
    }
}

- (IBAction)playAct:(UIButton *)sender {
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    _voicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_inPath] error:nil];
    _voicePlayer.delegate = self;
    [_voicePlayer play];
}

#pragma mark play delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"play successfully");
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

@end
