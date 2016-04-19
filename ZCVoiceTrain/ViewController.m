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
#import "ZCVoiceHUD.h"

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
    
//    [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];//普通状态
//    [_recordBtn setTitle:@"松开 发送" forState:UIControlStateHighlighted];//按下状态
//    [_recordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];//普通状态颜色
//    [_recordBtn setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateHighlighted];//按下状态颜色
//    [_recordBtn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];//按下并且按住
//    [_recordBtn addTarget:self action:@selector(btnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];//释放
//    [_recordBtn addTarget:self action:@selector(btnTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];//手指离开按钮范围
//    [_recordBtn addTarget:self action:@selector(btnTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];//在范围外释放
//    [_recordBtn addTarget:self action:@selector(btnTouchDragInside:) forControlEvents:UIControlEventTouchDragInside];//返回到按钮范围
    
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

    float averagePower = pow(10, (0.05 * [_voiceRecorder averagePowerForChannel:0]));
    
    NSLog(@"22--%f--",averagePower);
    
    int any0 = (int)(averagePower * 100);
    int any1 = MIN(any0, 6);
    int any2 = MAX(any1, 1);
	NSInteger level = any2;

	NSLog(@"up_show_level_%d",level);
    [ZCVoiceHUD showLevel:level];
	[self performSelector:@selector(updatePowerLevel) withObject:nil afterDelay:0.25];
}

- (IBAction)recordAct:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"停止"]) {
		_isRecording = NO;
        [ZCVoiceHUD disMiss];
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
        _voiceRecorder.meteringEnabled = YES;
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
