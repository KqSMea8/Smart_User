//
//  ScanResultController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/10/25.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ScanResultController.h"

@interface ScanResultController ()
{
    __weak IBOutlet UILabel *remindLab;
    
    __weak IBOutlet UIButton *sureBtn;
}

@end

@implementation ScanResultController

-(void)setRemindStr:(NSString *)remindStr
{
    _remindStr = remindStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self initView];
}

-(void)initView
{
    sureBtn.layer.cornerRadius = 4;
    sureBtn.clipsToBounds = YES;
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    remindLab.text = [NSString stringWithFormat:@"%@",_remindStr];
}

-(void)_initNavItems
{
    self.title = @"扫码体检";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void)sureBtnAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
