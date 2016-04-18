//
//  SomeVoiceController.m
//  ZCVoiceTrain
//
//  Created by 张三弓 on 16/4/17.
//  Copyright © 2016年 张三弓. All rights reserved.
//

#import "SomeVoiceController.h"
#import "VoiceShowCell.h"

@interface SomeVoiceController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSArray * _dataArr;
}
@end

@implementation SomeVoiceController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (![self.navigationController.viewControllers containsObject:self]) {
        [[ZCVoicePlayer shareVoicePlayer] playStr:@""];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSError * error = nil;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    _dataArr = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    NSLog(@"%@",_dataArr);
    NSMutableArray * muArr = [NSMutableArray array];
    for (NSString * inStr in _dataArr) {
        if (![inStr hasPrefix:@".D"]) {
            [muArr addObject:inStr];
        }
    }
    _dataArr = [muArr copy];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MAIN_SCREEN_W, MAIN_SCREEN_H - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"VoiceShowCell" bundle:nil] forCellReuseIdentifier:@"VoiceShowCell"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoiceShowCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"VoiceShowCell"];
    cell.pathTwo = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row]];
    return cell;
}

@end
