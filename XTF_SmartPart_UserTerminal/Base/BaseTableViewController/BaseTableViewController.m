//
//  BaseTableViewController.m
//  ZHYQ
//
//  Created by 焦平 on 2017/10/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

//只支持竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return _StatusBarStyle;
}

//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle = StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWhiteColor;
    //是否显示返回按钮
    self.isShowLiftBack = YES;
    //默认导航栏样式：白字
    self.StatusBarStyle = UIStatusBarStyleDefault;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //针对iOS11转场动画导致的view偏移进行修复
//    if (self.isHidenNaviBar == YES) {
//        //导航栏隐藏，view top = 0
//        self.view.top = 0;
//    }else{
//        if (self.navigationController) {
//            CGRect frame = self.view.frame;
//            frame.origin.y = kTopHeight;
//            self.view.frame = frame;
//        }
//    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


@end
