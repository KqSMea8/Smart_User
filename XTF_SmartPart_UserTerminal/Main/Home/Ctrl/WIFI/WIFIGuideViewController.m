//
//  WIFIGuideViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/28.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "WIFIGuideViewController.h"

@interface WIFIGuideViewController ()
{
    __weak IBOutlet UIButton *connectBtn;
    __weak IBOutlet UIButton *closeBtn;
    __weak IBOutlet UIButton *selectBtn;
    __weak IBOutlet UILabel *signLab;
    
    __weak IBOutlet UILabel *promptLab;
    
    NSInteger secondsCountDown;//倒计时总时长
    NSTimer *countDownTimer;
    
    __weak IBOutlet NSLayoutConstraint *signLabTopEdg;
    __weak IBOutlet NSLayoutConstraint *connectRightNowBtnTopEdg;
    __weak IBOutlet NSLayoutConstraint *selectBtnTopEdg;
    __weak IBOutlet NSLayoutConstraint *guideViewHeight;
    
    __weak IBOutlet NSLayoutConstraint *guideViewRightCon;
    
    __weak IBOutlet NSLayoutConstraint *guideViewLeftCon;
    
}

@end

@implementation WIFIGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initView];
}


-(void)_initView
{
    guideViewRightCon.constant = hScale * guideViewRightCon.constant;
    
    guideViewLeftCon.constant = hScale * guideViewLeftCon.constant;
    
    guideViewHeight.constant = hScale * guideViewHeight.constant;
    
    signLabTopEdg.constant = hScale * signLabTopEdg.constant;
    
    connectRightNowBtnTopEdg.constant = hScale * connectRightNowBtnTopEdg.constant;
    
    selectBtnTopEdg.constant = hScale * selectBtnTopEdg.constant;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    selectBtn.selected = NO;
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"remember_normal"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"remember_select"] forState:UIControlStateSelected];
    
    connectBtn.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    connectBtn.layer.cornerRadius = 6;
    connectBtn.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBtnAction:)];
    promptLab.userInteractionEnabled = YES;
    [promptLab addGestureRecognizer:tap];
    
    secondsCountDown = 10;
    
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        //倒计时-1
        secondsCountDown--;
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
        NSString *format_time = [NSString stringWithFormat:@"%@秒后将自动切换到wifi列表",str_second];
        //修改倒计时标签现实内容
        signLab.text=[NSString stringWithFormat:@"%@",format_time];
        //当倒计时到0时，做需要的操作，比如验证码过期不能提交
        if(secondsCountDown==0){
            [self connectWifiRightNowBtnAction:nil];
            [timer invalidate];
            [countDownTimer invalidate];
        }
    } repeats:YES];
}

////设置字体颜色
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;//白色
//}
//
////设置状态栏颜色
//- (void)setStatusBarBackgroundColor:(UIColor *)color {
//
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = color;
//    }
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [self preferredStatusBarStyle];
//    [self setStatusBarBackgroundColor:[UIColor colorWithHexString:@"#252E44"]];
//}

- (IBAction)closeBtnAction:(id)sender {
    [countDownTimer invalidate];
    countDownTimer =nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)connectWifiRightNowBtnAction:(id)sender {
    
    NSString * urlString = @"App-Prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if (iOS10) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }
    }
    
    [self performSelector:@selector(popView) withObject:nil afterDelay:0.5];
}

-(void)popView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectBtnAction:(id)sender {
    selectBtn.selected = !selectBtn.selected;
    if (selectBtn.selected) {
        [kUserDefaults setBool:YES forKey:isJumpOverGuide];
        [kUserDefaults synchronize];
    }else{
        [kUserDefaults setBool:NO forKey:isJumpOverGuide];
        [kUserDefaults synchronize];
    }
}

-(void) countDownAction{
    //倒计时-1
    secondsCountDown--;
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
    NSString *format_time = [NSString stringWithFormat:@"%@秒后将自动切换到wifi列表",str_second];
    //修改倒计时标签现实内容
    signLab.text=[NSString stringWithFormat:@"%@",format_time];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [self connectWifiRightNowBtnAction:nil];
        [countDownTimer invalidate];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [countDownTimer invalidate];
    countDownTimer =nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
