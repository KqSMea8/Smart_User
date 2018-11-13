//
//  CompleteInfoViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/10/19.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "CompleteInfoViewController.h"
#import "Utils.h"
#import "WSDatePickerView.h"
#import "UserModel.h"
#import "ScanResultController.h"

@interface CompleteInfoViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *sexBgView;
@property (weak, nonatomic) IBOutlet UITextField *sexTex;
@property (weak, nonatomic) IBOutlet UIImageView *birthdayBgView;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTex;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation CompleteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initNav];
    
    //加载个人信息
    [self loadPersonInfo:@"0"];
}

-(void)initNav
{
    self.title = @"完善个人资料";
    
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

-(void)initView
{
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    _commitBtn.layer.cornerRadius = 3;
    _commitBtn.clipsToBounds = YES;
    
    _iconView.layer.cornerRadius = 50;
    _iconView.clipsToBounds = YES;
    
    UITapGestureRecognizer *endDditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditAction)];
    [self.tableView addGestureRecognizer:endDditTap];
    
    // 初始化textField
    _sexBgView.image = [_sexBgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    _birthdayBgView.image = [_birthdayBgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    _sexBgView.userInteractionEnabled = YES;
    _birthdayBgView.userInteractionEnabled = YES;
    
    UIView *sexbgView = [[UIView alloc] initWithFrame:CGRectMake(34, 0, KScreenWidth-90, _sexBgView.height)];
    sexbgView.backgroundColor = [UIColor clearColor];
    [_sexBgView.superview addSubview:sexbgView];
    
    UIView *birthdaybgView = [[UIView alloc] initWithFrame:CGRectMake(34, 0, KScreenWidth-90, _birthdayBgView.height)];
    birthdaybgView.backgroundColor = [UIColor clearColor];
    [_birthdayBgView.superview addSubview:birthdaybgView];
    
    UITapGestureRecognizer *sexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sexTap)];
    [sexbgView addGestureRecognizer:sexTap];
    
    UITapGestureRecognizer *birthdayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(birthdayTap)];
    [birthdaybgView addGestureRecognizer:birthdayTap];
    
    UILabel *sexLeftlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    sexLeftlab.text = @"性别：";
    sexLeftlab.font = [UIFont systemFontOfSize:17];
    sexLeftlab.textColor = [UIColor blackColor];
    sexLeftlab.textAlignment = NSTextAlignmentCenter;
    _sexTex.leftView = sexLeftlab;
    _sexTex.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *sexRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
    UIImageView *sexRightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 18, 15, 15)];
    sexRightImgView.image = [UIImage imageNamed:@"list_right_narrow"];
    [sexRightView addSubview:sexRightImgView];
    _sexTex.rightView = sexRightView;
    _sexTex.rightViewMode = UITextFieldViewModeAlways;
    
    _sexTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _sexTex.layer.borderWidth = 0.8;
    _sexTex.layer.cornerRadius = 4;
    
    UILabel *birthdayLeftlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    birthdayLeftlab.text = @"生日：";
    birthdayLeftlab.font = [UIFont systemFontOfSize:17];
    birthdayLeftlab.textColor = [UIColor blackColor];
    birthdayLeftlab.textAlignment = NSTextAlignmentCenter;
    _birthdayTex.leftView = birthdayLeftlab;
    _birthdayTex.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *birthdayRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
    UIImageView *birthdayRightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 18, 15, 15)];
    birthdayRightImgView.image = [UIImage imageNamed:@"list_right_narrow"];
    [birthdayRightView addSubview:birthdayRightImgView];
    _birthdayTex.rightView = birthdayRightView;
    _birthdayTex.rightViewMode = UITextFieldViewModeAlways;
    
    _birthdayTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _birthdayTex.layer.borderWidth = 0.8;
    _birthdayTex.layer.cornerRadius = 4;
}

- (void)endEditAction {
    [self.tableView endEditing:YES];
}

#pragma mark 加载个人信息
-(void)loadPersonInfo:(NSString *)sign
{
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCustInfo", MainUrl];
    NSMutableDictionary *param = @{}.mutableCopy;
    if(![custId isKindOfClass:[NSNull class]]&&custId != nil){
        [param setObject:custId forKey:@"custId"];
    }
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"code"] isEqualToString:@"1"]){
            UserModel *_model = [[UserModel alloc] initWithDataDic:responseObject[@"responseData"]];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                // 员工
                if (![_model.CUST_NAME isKindOfClass:[NSNull class]]&&_model.CUST_NAME != nil) {
                    _nameLab.text = [NSString stringWithFormat:@"员工姓名：%@",_model.CUST_NAME];
                }
                
                if(![_model.CUST_HEADIMAGE isKindOfClass:[NSNull class]]&&_model.CUST_HEADIMAGE != nil){
                    [_iconView sd_setImageWithURL:[NSURL URLWithString:_model.CUST_HEADIMAGE] placeholderImage:[UIImage imageNamed:@"_member_icon"]];
                }
                
                if(![_model.BIRTHDAY isKindOfClass:[NSNull class]]&&_model.BIRTHDAY != nil){
                    _birthdayTex.text = [NSString stringWithFormat:@"%@",_model.BIRTHDAY];
                    [kUserDefaults setObject:_birthdayTex.text forKey:kUserBirthDay];
                }
                
                if(![_model.SEX isKindOfClass:[NSNull class]]&&_model.SEX != nil){
                    if ([_model.SEX isEqualToString:@"0"]) {
                        _sexTex.text = @"男";
                    }else{
                        _sexTex.text = @"女";
                    }
                    [kUserDefaults setObject:_model.SEX forKey:KUserSex];
                }
                
                if ([sign isEqualToString:@"1"]) {
                    [self openTJJActionWithSex:_model.SEX andBirthDay:_model.BIRTHDAY];
                }
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

-(void)sexTap{
    _birthdayBgView.hidden = YES;
    _birthdayTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _sexBgView.hidden = NO;
    _sexTex.layer.borderColor = [UIColor clearColor].CGColor;
    [self showAlert];
}

-(void)birthdayTap{
    _sexBgView.hidden = YES;
    _sexTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _birthdayBgView.hidden = NO;
    _birthdayTex.layer.borderColor = [UIColor clearColor].CGColor;
    [self showBirthdayPicker];
}

- (IBAction)updateSexAndBirthDayAction:(id)sender {
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/upCustExt",MainUrl];
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:custId forKey:@"custId"];
    if (_sexTex.text == nil||_birthdayTex.text == nil) {
        [self showHint:@"请完善您的个人信息!"];
        return;
    }else{
        if ([_sexTex.text isEqualToString:@"男"]) {
            [param setObject:@"0" forKey:@"sex"];
        }else{
            [param setObject:@"1" forKey:@"sex"];
        }
        
        [param setObject:_birthdayTex.text forKey:@"birthday"];
    }
    
    NSString *jsonStr = [Utils convertToJsonData:param];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:jsonStr forKey:@"params"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSNull class]]&&![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            
            [self loadPersonInfo:@"1"];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)showAlert
{
    UIAlertController *act =[UIAlertController alertControllerWithTitle:nil message:@"性别选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *manact =[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _sexTex.text = @"男";
    }];
    UIAlertAction *femaleact =[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _sexTex.text = @"女";
    }];
    
    UIAlertAction *cacel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    if ([act respondsToSelector:@selector(popoverPresentationController)]) {
        act.popoverPresentationController.sourceView = self.view; //必须加
        act.popoverPresentationController.sourceRect = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);//可选，我这里加这句代码是为了调整到合适的位置
    }
    
    [act addAction:manact];
    [act addAction:femaleact];
    [act addAction:cacel];
    [self presentViewController:act animated:YES completion:nil];
}

-(void)showBirthdayPicker
{
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:[NSDate date] CompleteBlock:^(NSDate *selectDate) {
        NSString *date1 = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        
        _birthdayTex.text = date1;
    }];
    datepicker.dateLabelColor = [UIColor colorWithHexString:@"#1B82D1"];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor colorWithHexString:@"#1B82D1"];//确定按钮的颜色
    datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
    [datepicker show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)openTJJActionWithSex:(NSString *)sex andBirthDay:(NSString *)birDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:birDate];
    NSDate *endDate = [NSDate date];
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    NSInteger year = delta.year;
    
    NSInteger time = [Utils getNowTimeTimestamp];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",time];
    NSString *custMoible = [kUserDefaults objectForKey:KUserPhoneNum];
    NSString *name = [kUserDefaults objectForKey:KUserCustName];
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    NSString *healthKey = kHealthKey;

    NSURL *url = [NSURL URLWithString:_scanDataString];

    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:custId forKey:@"uid"];
    [param setObject:name forKey:@"name"];
    [param setObject:custMoible forKey:@"mobile"];
    if ([sex isEqualToString:@"1"]) {
        [param setObject:@"0" forKey:@"sex"];
    }else{
        [param setObject:@"1" forKey:@"sex"];
    }
    [param setObject:[NSString stringWithFormat:@"%ld",year] forKey:@"age"];
    [param setObject:timeStamp forKey:@"timestamp"];

    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"uid"];
    [params setObject:[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"name"];
    [params setObject:custMoible forKey:@"mobile"];
    if ([sex isEqualToString:@"1"]) {
        [params setObject:@"0" forKey:@"sex"];
    }else{
        [params setObject:@"1" forKey:@"sex"];
    }
    [params setObject:[NSString stringWithFormat:@"%ld",year] forKey:@"age"];
    [params setObject:timeStamp forKey:@"timestamp"];
    [params setObject:[url.host lowercaseString] forKey:@"appid"];

    NSString *signStr = [self getSignStrWithHealthKey:healthKey withParams:params];

    [param setObject:signStr forKey:@"sign"];
    
    [self showHudInView:self.view hint:nil];

    [[NetworkClient sharedInstance] POST:_scanDataString dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"success"] boolValue]) {
//            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"资料提交成功,请在体检机上开始体检操作!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [view show];
            ScanResultController *scanVc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ScanResultController"];
            scanVc.remindStr = @"资料提交成功";
            [self.navigationController pushViewController:scanVc animated:year];
        }else{
            [self showHint:@"提交失败,请重试!"];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"提交失败,请重试!"];
    }];
}

//生成签名串
-(NSString *)getSignStrWithHealthKey:(NSString *)key withParams:(NSDictionary *)param
{
    NSString *signStr;
    
    NSString *appkeyMd5 = [key md5String];
    
    NSArray *keyArr = [param allKeys];
    NSArray *paiXuArr = [[self paixu:keyArr] reverseObjectEnumerator].allObjects;
    __block NSString *paramStr=@"";
    [paiXuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str1 = [NSString stringWithFormat:@"%@=%@&",obj,param[obj]];
        paramStr = [paramStr stringByAppendingString:str1];
    }];
    
    paramStr = [paramStr substringWithRange:NSMakeRange(0, paramStr.length-1)];
    
    NSString *md5AndParamStr = [NSString stringWithFormat:@"%@%@%@",key,paramStr,appkeyMd5];
    
    NSString *lastStr = [[md5AndParamStr md5String] uppercaseString];
    
    signStr = [self reverseWordsInString:lastStr];
    
    return signStr;
}

-(NSArray *)paixu:(NSArray *)arr
{
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        
        NSRange range = NSMakeRange(0,obj1.length);
        
        return [obj1 compare:obj2 options:comparisonOptions range:range];
        
    };
    
    NSArray *resultArray = [arr sortedArrayUsingComparator:sort];
    return resultArray;
}

//字符串倒序
- (NSString*)reverseWordsInString:(NSString*)oldStr
{
    NSMutableString *newStr = [NSMutableString stringWithCapacity:oldStr.length];
    [oldStr enumerateSubstringsInRange:NSMakeRange(0, oldStr.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
        [newStr appendString:substring];
    }];
    return newStr;
}


@end
