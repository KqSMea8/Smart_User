//
//  RepairDetailViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by jiaop on 2018/5/14.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "RepairDetailViewController.h"

@interface RepairDetailViewController ()
//设备名
@property (retain, nonatomic) UILabel *deviceLab;
@property (retain, nonatomic) UILabel *deviceNameLab;
//设备位置
@property (retain, nonatomic) UILabel *loactionLab;
@property (retain, nonatomic) UILabel *deviceLoactionLab;
//故障说明
@property (retain, nonatomic) UILabel *malfunctionLab;
@property (retain, nonatomic) UILabel *malfunctionInfoLab;
//维修进度
@property (retain, nonatomic) UILabel *progressLab;
@property (retain, nonatomic) UILabel *repairProgressLab;
@property (retain, nonatomic) UIImageView *schedleView;
@property (retain, nonatomic) UIImageView *completeView;

@end

@implementation RepairDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self initView];
    
    [self loadData];
}

-(void)_initNavItems
{
    self.title = @"报修详情";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

-(void)_leftBarBtnItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView
{
    _deviceLab = [self createLabWithTitle:@"故障设备:" lineNum:1 frameRect:CGRectMake(9.5, 29.5, 74, 20) titleFont:17 titleColor:[UIColor blackColor]];
    
    _deviceNameLab = [self createLabWithTitle:@"-" lineNum:1 frameRect:CGRectMake(_deviceLab.right+10, _deviceLab.frame.origin.y, self.view.width-_deviceLab.right-30, 20) titleFont:17 titleColor:[UIColor colorWithHexString:@"#616161"]];
    
    _loactionLab = [self createLabWithTitle:@"设备位置:" lineNum:1 frameRect:CGRectMake(9.5, _deviceLab.bottom+27.5, 74, 20) titleFont:17 titleColor:[UIColor blackColor]];
    
    _deviceLoactionLab = [self createLabWithTitle:@"-" lineNum:1 frameRect:CGRectMake(_loactionLab.right+10, _deviceLab.bottom+27.5, self.view.width-_deviceLab.right-30, 20) titleFont:17 titleColor:[UIColor colorWithHexString:@"#616161"]];
    
    _malfunctionLab = [self createLabWithTitle:@"故障说明:" lineNum:1 frameRect:CGRectMake(9.5, _loactionLab.bottom+25.5, 74, 20) titleFont:17 titleColor:[UIColor blackColor]];
    _malfunctionInfoLab = [self createLabWithTitle:@"-" lineNum:0 frameRect:CGRectMake(_malfunctionLab.right+10, _malfunctionLab.frame.origin.y, self.view.width-_deviceLab.right-30, 20) titleFont:17 titleColor:[UIColor colorWithHexString:@"#616161"]];
    
    _progressLab = [self createLabWithTitle:@"维修进度:" lineNum:1 frameRect:CGRectMake(9.5, _malfunctionInfoLab.bottom+35.5, 74, 20) titleFont:17 titleColor:[UIColor blackColor]];
    _repairProgressLab = [self createLabWithTitle:@"-" lineNum:0 frameRect:CGRectMake(_progressLab.right+10, _progressLab.frame.origin.y, self.view.width-_deviceLab.right-30, 20) titleFont:17 titleColor:[UIColor colorWithHexString:@"#616161"]];
    
    _schedleView = [[UIImageView alloc] initWithFrame:CGRectMake(_progressLab.right+40, _malfunctionInfoLab.bottom+22.5, 74.5, 74.5)];
    _schedleView.hidden = YES;
    [self.view addSubview:_schedleView];
    
    _completeView = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, _schedleView.bottom+7.5, self.view.width-19, 232)];
    _completeView.hidden = YES;
    [self.view addSubview:_completeView];
    
    self.model = _model;
}

-(UILabel*)createLabWithTitle:(NSString *)title lineNum:(int)num frameRect:(CGRect)rect titleFont:(int)size titleColor:(UIColor *)color
{
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = rect;
    lab.font = [UIFont systemFontOfSize:size];
    lab.text = title;
    lab.textColor = color;
    lab.numberOfLines = num;
    lab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lab];
    return lab;
}

-(void)loadData{
    NSString *urlStr = [NSString stringWithFormat:@"%@/deviceAlarm/alarmOrderByAlarmId/%@",MainUrl,_model.alarmId];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSDictionary *dataDic = responseObject[@"responseData"];
            NSDictionary *handleLogDic = dataDic[@"handleLog"];
            
            _deviceNameLab.text = [NSString stringWithFormat:@"%@",_model.deviceName];
            
            _deviceLoactionLab.text = [NSString stringWithFormat:@"%@",_model.alarmLocation];
            
            _malfunctionInfoLab.text = [NSString stringWithFormat:@"%@",_model.alarmInfo];
            CGSize size = [_model.alarmInfo sizeForFont:[UIFont systemFontOfSize:17] size:CGSizeMake(self.view.width-_deviceLab.right-30, MAXFLOAT) mode:NSLineBreakByCharWrapping];
            _malfunctionInfoLab.size = size;
            
            _progressLab.frame = CGRectMake(9.5, _malfunctionInfoLab.bottom+35.5, 74, 20);
            _repairProgressLab.frame = CGRectMake(_progressLab.right+10, _progressLab.frame.origin.y, self.view.width-_deviceLab.right-30, 20);
            
            if ([_model.alarmState isEqualToString:@"0"]||[_model.alarmState isEqualToString:@"3"]) {
                _repairProgressLab.text = [NSString stringWithFormat:@"待处理"];
            }
            if ([_model.alarmState isEqualToString:@"1"]){
                _repairProgressLab.text = [NSString stringWithFormat:@"维修中"];
            }
            if ([_model.alarmState isEqualToString:@"2"]){
                _repairProgressLab.text = [NSString stringWithFormat:@"已完成"];
                _schedleView.hidden = NO;
                _schedleView.image = [UIImage imageNamed:@"completed"];
                if (![handleLogDic[@"handleImage"] isKindOfClass:[NSNull class]]&&handleLogDic[@"handleImage"] != nil) {
                    _completeView.hidden = NO;
                    [_completeView sd_setImageWithURL:[NSURL URLWithString:handleLogDic[@"handleImage"]]];
                }
            }
            
            if ([_model.alarmState isEqualToString:@"9"]) {
                _repairProgressLab.text = [NSString stringWithFormat:@"故障已被忽略，如仍有问题可再次报修"];
                CGSize progressSize = [_repairProgressLab.text sizeForFont:[UIFont systemFontOfSize:17] size:CGSizeMake(self.view.width-_deviceLab.right-30, MAXFLOAT) mode:NSLineBreakByCharWrapping];
                _repairProgressLab.frame = CGRectMake(_progressLab.right+10, _progressLab.frame.origin.y, self.view.width-_deviceLab.right-30, progressSize.height);
                _schedleView.hidden = NO;
                _schedleView.image = [UIImage imageNamed:@"completed"];
                if (![handleLogDic[@"handleImage"] isKindOfClass:[NSNull class]]&&handleLogDic[@"handleImage"] != nil) {
                    _completeView.hidden = NO;
                    [_completeView sd_setImageWithURL:[NSURL URLWithString:handleLogDic[@"handleImage"]]];
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)setModel:(RepairModel *)model
{
    _model = model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
