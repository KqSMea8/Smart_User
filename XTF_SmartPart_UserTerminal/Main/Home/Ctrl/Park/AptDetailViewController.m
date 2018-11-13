//
//  AptDetailViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "AptDetailViewController.h"
#import "CancelReservViewController.h"

@interface AptDetailViewController ()
{
    __weak IBOutlet UILabel *_topMsgLabel;
    
    __weak IBOutlet UILabel *_minuteLabel;
    __weak IBOutlet UILabel *_secondLabel;
    
    __weak IBOutlet UIButton *_navBt;
    __weak IBOutlet UIButton *_cancelBt;
    __weak IBOutlet UIButton *_inParkBt;
    
    __weak IBOutlet UILabel *_parkNameLabel;
    __weak IBOutlet UILabel *_codeLabel;
    __weak IBOutlet UILabel *_timeLabel;
    
    NSInteger _aptTime; // 单位秒
}
@end

@implementation AptDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _aptTime = 1800;
    
    [self _initView];
    
    [self _startTime];
}

- (void)_initView {
    self.title = @"预约详情";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    _navBt.layer.cornerRadius = 4;
    
    _cancelBt.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    _cancelBt.layer.borderWidth = 0.8;
    _cancelBt.layer.cornerRadius = 4;
    
    _inParkBt.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    _inParkBt.layer.borderWidth = 0.8;
    _inParkBt.layer.cornerRadius = 4;
}
- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_startTime {
    [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        _aptTime --;
        NSString *minStr = [NSString stringWithFormat:@"%ld", _aptTime/60];
        if(minStr.length < 2){
            minStr = [NSString stringWithFormat:@"0%@", minStr];
        }
        _minuteLabel.text = minStr;
        
        NSString *secStr = [NSString stringWithFormat:@"%ld", _aptTime%60];
        if(secStr.length < 2){
            secStr = [NSString stringWithFormat:@"0%@", secStr];
        }
        _secondLabel.text = secStr;
        
        if(_aptTime <= 0){
            [timer invalidate];
        }
    } repeats:YES];
}

#pragma mark UItableView 协议
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 5;
}

#pragma mark 按钮点击方法
- (IBAction)navAction:(id)sender {
    
}

- (IBAction)cancelAptAction:(id)sender {
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"取消确认" message:@"取消车位预约车位将不再为您保留且订金不予退还。确认取消？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cer = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        CancelReservViewController *canVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"CancelReservViewController"];
        [self.navigationController pushViewController:canVC animated:YES];
    }];
    [alertCon addAction:cancel];
    [alertCon addAction:cer];
    [self presentViewController:alertCon animated:YES completion:nil];
}

- (IBAction)inParkAction:(id)sender {
    
}


@end
