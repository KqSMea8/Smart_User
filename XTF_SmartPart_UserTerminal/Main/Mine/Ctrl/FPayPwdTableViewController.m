//
//  FPayPwdTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/15.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "FPayPwdTableViewController.h"
#import "ReSetPayPwdTableViewController.h"

@interface FPayPwdTableViewController ()<UITextFieldDelegate>
{
    
    __weak IBOutlet UILabel *phoneNumLab;
    
    __weak IBOutlet UIImageView *verCodeBgView;
    __weak IBOutlet UITextField *verCodeTex;
    __weak IBOutlet UILabel *signLab;
    __weak IBOutlet UIButton *sureBtn;
    
}

@property (nonatomic,assign) NSInteger timeCount;
@property(strong, nonatomic) NSTimer *timer;

@end

@implementation FPayPwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self _initView];
    //获取验证码
    [self getVerCodeTapAction];
}

-(void)_initNavItems
{
    self.title = @"忘记支付密码";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_initView
{
    NSString *phoneNum = [kUserDefaults objectForKey:KUserPhoneNum];
    phoneNumLab.text = phoneNum;
    
    self.timeCount = 60;
    
    NSString *timeStr = [NSString stringWithFormat:@"%lu",self.timeCount];
    
    NSString *str = [NSString stringWithFormat:@"%lu秒后重新获取", self.timeCount];
    
    NSMutableAttributedString *attributiStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attributiStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1B82D1"] range:NSMakeRange(0, timeStr.length)];
    [attributiStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(timeStr.length, str.length-timeStr.length)];
    
    signLab.attributedText = attributiStr;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);

    UITapGestureRecognizer *endDditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditAction)];
    [self.tableView addGestureRecognizer:endDditTap];
    
    sureBtn.layer.cornerRadius = 4;
    
    verCodeTex.delegate = self;
    
    UIView *verCodeLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *verCodeLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    verCodeLeftImgView.image = [UIImage imageNamed:@"verCode"];
    [verCodeLeftView addSubview:verCodeLeftImgView];
    verCodeTex.leftView = verCodeLeftView;
    verCodeTex.leftViewMode = UITextFieldViewModeAlways;
    verCodeTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    verCodeTex.layer.borderWidth = 0.8;
    verCodeTex.layer.cornerRadius = 4;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getVerCodeTapAction)];
    signLab.userInteractionEnabled = NO;
    [signLab addGestureRecognizer:tap];
    
}

- (IBAction)sureBtnAction:(id)sender {
    
    [self endEditAction];
    
    [self sureVerCode];
}

#pragma mark 重新获取验证码
-(void)getVerCodeTapAction
{
    [self showHudInView:self.view hint:@""];
    
    NSString *phoneNum = [kUserDefaults objectForKey:KUserPhoneNum];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getSmsVerify",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:phoneNum forKey:@"custMobile"];
    [params setObject:@"5" forKey:@"verifyType"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            self.timeCount = 60;
            [self viewFireDate];
        }
        [self showHint:responseObject[@"message"]];
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

-(void)viewFireDate
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        [self reduceTime];
    } repeats:YES];
}

-(void)reduceTime
{
    self.timeCount--;
    if (self.timeCount == 0) {
        signLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
        signLab.text = @"重新获取验证码";
        signLab.userInteractionEnabled = YES;
        [self.timer invalidate];
        //        self.timer = nil;
    }else{
        
        NSString *timeStr = [NSString stringWithFormat:@"%lu",self.timeCount];
        
        NSString *str = [NSString stringWithFormat:@"%lu秒后重新获取", self.timeCount];
        
        NSMutableAttributedString *attributiStr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attributiStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1B82D1"] range:NSMakeRange(0, timeStr.length)];
        [attributiStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(timeStr.length, str.length-timeStr.length)];
        
        signLab.attributedText = attributiStr;
        signLab.userInteractionEnabled = NO;
    }
}

-(void)sureVerCode
{
    NSString *phoneNum = [kUserDefaults objectForKey:KUserPhoneNum];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/isSmsVerify",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [params setObject:phoneNum forKey:@"custMobile"];
    [params setObject:verCodeTex.text forKey:@"smsCode"];
    [params setObject:@"5" forKey:@"verifyType"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        //        DLog(@"%@",responseObject);
        [self showHint:responseObject[@"message"]];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            //            DLog(@"%@",responseObject);
            ReSetPayPwdTableViewController *resetPayPwdVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"ReSetPayPwdTableViewController"];
            resetPayPwdVC.signStr = _signStr;
            [self.navigationController pushViewController:resetPayPwdVC animated:YES];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark UItextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == verCodeTex) {
        verCodeBgView.hidden = NO;
        verCodeTex.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == verCodeTex) {
        verCodeBgView.hidden = YES;
        verCodeTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }
    return YES;
}

-(void)endEditAction
{
    [self.tableView endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
