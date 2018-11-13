//
//  RepairViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/4.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "RepairViewController.h"
#import "YQPlaceHolderTextView.h"
#import "OwnRepairViewController.h"
#import "Utils.h"

@interface RepairViewController ()<UITextViewDelegate>
{
    
    __weak IBOutlet UITextField *equipmentNameTex;
    
    __weak IBOutlet UITextField *equipmentIdTex;
    
    __weak IBOutlet UITextField *equipmentPositionTex;
    __weak IBOutlet YQPlaceHolderTextView *contentTextView;
}

@property (weak, nonatomic) IBOutlet UIButton *sureRepairBtn;

@end

@implementation RepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    [self _initNavItems];
}

-(void)_initView
{
    _sureRepairBtn.layer.cornerRadius = 6;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#efefef"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableEndEdit)];
    [self.tableView addGestureRecognizer:tap];
    
    contentTextView.placeholder = @"请简单描述物品故障情况";
    [contentTextView setPlaceholderFont:[UIFont systemFontOfSize:17]];
    contentTextView.delegate = self;
    [contentTextView setPlaceholderColor:[UIColor colorWithHexString:@"#c6c7ce"]];
    
}

-(void)_initNavItems
{
    self.title = @"一键报修";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [rightBtn setImage:[UIImage imageNamed:@"myRepairs"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(_rightBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_rightBarBtnItemClick{
    OwnRepairViewController *ownRepairVc = [[OwnRepairViewController alloc] init];
    [self.navigationController pushViewController:ownRepairVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sureRepairBtnAction:(id)sender {
    [self showHudInView:self.view hint:nil];
    if (equipmentNameTex.text == nil||equipmentNameTex.text.length == 0) {
        [self hideHud];
        [self showHint:@"请输入报修设备名!"];
        return;
    }
    
    if (equipmentPositionTex.text == nil||equipmentPositionTex.text.length == 0) {
        [self hideHud];
        [self showHint:@"请输入报修设备位置!"];
        return;
    }
    
    if (contentTextView.text == nil||contentTextView.text.length == 0) {
        [self hideHud];
        [self showHint:@"请对设备出现的故障情况进行简要描述!"];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/deviceAlarm/report",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:equipmentNameTex.text forKey:@"deviceName"];
    [params setObject:contentTextView.text forKey:@"alarmInfo"];
    [params setObject:equipmentPositionTex.text forKey:@"alarmLocation"];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    NSString *jsonStr = [Utils convertToJsonData:params];
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"] != nil) {
            [self showHint:responseObject[@"message"]];
        }
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"请重试！"];
        NSLog(@"%@",error);
    }];
}

-(void)tableEndEdit
{
    [self.tableView endEditing:YES];
}

//正在改变

- (void)textViewDidChange:(UITextView *)textView
{
    //字数限制操作
    if (textView.text.length >= 60) {
        textView.text = [textView.text substringToIndex:60];
        [self showHint:@"故障描述不得超过六十个字！" yOffset:-160];
    }
}

@end
