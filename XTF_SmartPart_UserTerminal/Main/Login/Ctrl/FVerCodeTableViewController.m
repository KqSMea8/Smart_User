//
//  FVerCodeTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/2.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "FVerCodeTableViewController.h"
#import "ResetPwdTableViewController.h"

@interface FVerCodeTableViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIImageView *verCodeBgView;
@property (weak, nonatomic) IBOutlet UITextField *verCodeTex;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property(strong, nonatomic) NSTimer *timer;
@property(assign, nonatomic) NSInteger timeCount;

@end

@implementation FVerCodeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    [self _initNavItems];
}

-(void)_initView
{
    _phoneLab.text = _telephoneNum;
    
    self.timeCount = 60;
    
    NSString *timeStr = [NSString stringWithFormat:@"%lu",self.timeCount];
    
    NSString *str = [NSString stringWithFormat:@"%lu秒后重新获取", self.timeCount];
    
    NSMutableAttributedString *attributiStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attributiStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1B82D1"] range:NSMakeRange(0, timeStr.length)];
    [attributiStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(timeStr.length, str.length-timeStr.length)];
    
    _timeLab.attributedText = attributiStr;
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.bounces = NO;
    
    UITapGestureRecognizer *endDditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditAction)];
    [self.tableView addGestureRecognizer:endDditTap];
    
    _sureBtn.layer.cornerRadius = 4;
    
    _verCodeTex.delegate = self;
    
    _verCodeBgView.image = [_verCodeBgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    
    UIView *verCodeLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *verCodeLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    verCodeLeftImgView.image = [UIImage imageNamed:@"verCode"];
    [verCodeLeftView addSubview:verCodeLeftImgView];
    _verCodeTex.leftView = verCodeLeftView;
    _verCodeTex.leftViewMode = UITextFieldViewModeAlways;
    _verCodeTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _verCodeTex.layer.borderWidth = 0.8;
    _verCodeTex.layer.cornerRadius = 4;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getVerCodeTapAction)];
    _timeLab.userInteractionEnabled = NO;
    [_timeLab addGestureRecognizer:tap];
    
    [self viewFireDate];
    
}

#pragma mark 重新获取验证码
-(void)getVerCodeTapAction
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getSmsVerify",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_telephoneNum forKey:@"custMobile"];
    [params setObject:@"2" forKey:@"verifyType"];
    
    [self showHudInView:self.view hint:@""];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            self.timeCount = 60;
            [self viewFireDate];
        }
        [self showHint:responseObject[@"message"]];
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"网络错误,请重试!"];
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
        _timeLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
        _timeLab.text = @"重新获取验证码";
        _timeLab.userInteractionEnabled = YES;
        [self.timer invalidate];
//        self.timer = nil;
    }else{
        NSString *timeStr = [NSString stringWithFormat:@"%lu",self.timeCount];
        
        NSString *str = [NSString stringWithFormat:@"%lu秒后重新获取", self.timeCount];
        
        NSMutableAttributedString *attributiStr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attributiStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1B82D1"] range:NSMakeRange(0, timeStr.length)];
        [attributiStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(timeStr.length, str.length-timeStr.length)];
        
        _timeLab.attributedText = attributiStr;

        _timeLab.userInteractionEnabled = NO;
    }
}

-(void)_initNavItems
{
    self.title = @"手机验证";
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UItextField协议
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _verCodeTex) {
        _verCodeBgView.hidden = NO;
        _verCodeTex.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == _verCodeTex) {
        _verCodeBgView.hidden = YES;
        _verCodeTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }
    return YES;
}

-(void)endEditAction
{
    [self.tableView endEditing:YES];
}

- (IBAction)sureBtnAction:(id)sender {
    
    [self endEditAction];
    
    [self sureVerCode];
    
}

-(void)sureVerCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/isSmsVerify",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [params setObject:_telephoneNum forKey:@"custMobile"];
    [params setObject:_verCodeTex.text forKey:@"smsCode"];
    [params setObject:@"2" forKey:@"verifyType"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
//        DLog(@"%@",responseObject);
        [self showHint:responseObject[@"message"]];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
//            DLog(@"%@",responseObject);
            ResetPwdTableViewController *resetVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"ResetPwdTableViewController"];
            resetVC.telephoneNum = _telephoneNum;
            [self.navigationController pushViewController:resetVC animated:YES];
        }
    } failure:^(NSError *error) {
        [self showHint:@"网络错误,请重试!"];
    }];
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

@end
