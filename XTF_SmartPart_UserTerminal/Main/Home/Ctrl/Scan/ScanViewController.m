//
//  ScanViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/21.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ScanViewController.h"
#import "YQScanView.h"
#import "PayMentTableViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import "Utils.h"
#import "CompleteInfoViewController.h"
#import "UserModel.h"
#import "ScanResultController.h"
#import <YYKit/NSString+YYAdd.h>

@interface ScanViewController ()<YQScanViewDelegate>
{
    int line_tag;
    UIView *highlightView;
    NSString *scanMessage;
    BOOL isRequesting;
}

@property (nonatomic,weak) YQScanView *scanV;

@end

@implementation ScanViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self _initView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _scanV.delegate = nil;
    [_scanV removeFromSuperview];
    _scanV = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initNavItems];
    
    [self monitorNetwork];
    
    [self loadPersonInfo];
}

-(void)loadPersonInfo
{
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCustInfo", MainUrl];
    NSMutableDictionary *param = @{}.mutableCopy;
    if(![custId isKindOfClass:[NSNull class]]&&custId != nil){
        [param setObject:custId forKey:@"custId"];
    }
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"code"] isEqualToString:@"1"]){
            UserModel *_model = [[UserModel alloc] initWithDataDic:responseObject[@"responseData"]];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                if(![_model.BIRTHDAY isKindOfClass:[NSNull class]]&&_model.BIRTHDAY != nil){
                    [kUserDefaults setObject:_model.BIRTHDAY forKey:kUserBirthDay];
                }
                
                if(![_model.SEX isKindOfClass:[NSNull class]]&&_model.SEX != nil){
                    [kUserDefaults setObject:_model.SEX forKey:KUserSex];
                }
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

#pragma mark 监听网络变化
- (void)monitorNetwork {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                //NSLog(@"未识别的网络");
                
                // 无网络
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotNetworkNotification" object:nil];
                _scanV.noNetView.hidden = NO;
                _scanV.lab.hidden = NO;
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                //NSLog(@"不可达的网络(未连接)");
                _scanV.noNetView.hidden = NO;
                _scanV.lab.hidden = NO;
                // 无网络
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotNetworkNotification" object:nil];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //NSLog(@"2G,3G,4G...的网络");
                _scanV.noNetView.hidden = YES;
                _scanV.lab.hidden = YES;
                // 恢复网络
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ResumeNetworkNotification" object:nil];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //NSLog(@"wifi的网络");
                _scanV.noNetView.hidden = YES;
                _scanV.lab.hidden = YES;
                // 恢复网络
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ResumeNetworkNotification" object:nil];
                break;
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
}

-(void)_initNavItems
{
//    self.title = @"扫扫";
    
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
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限 弹框提示是否去开启相应权限
        
        NSString *msg = [NSString stringWithFormat:@"相机访问权限被禁用,是否去设置开启访问相机权限？"];
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *remove = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
            [self performSelector:@selector(popView) withObject:nil afterDelay:0.5];
        }];
        
        [alertCon addAction:cancel];
        [alertCon addAction:remove];
        [self presentViewController:alertCon animated:YES completion:nil];
        
    }else{
        YQScanView *scanV = [[YQScanView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        scanV.delegate = self;
        [self.view addSubview:scanV];
        _scanV = scanV;
    }
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getScanDataString:(NSString*)scanDataString{
    NSString *offerId;
    NSString *urlStr = [NSString stringWithFormat:@"/public/getErImage"];
    NSString *healthStr = [NSString stringWithFormat:@"api.iguoshi.cn"];
    NSString *smartlearnStr = [NSString stringWithFormat:@"www.360guoxue.com"];
    if([scanDataString rangeOfString:urlStr].location != NSNotFound)
    {
        NSMutableDictionary *orderDic = [self getURLParameters:scanDataString];
        
        if (![orderDic[@"offerId"] isKindOfClass:[NSNull class]]&&orderDic[@"offerId"] != nil) {
            offerId = orderDic[@"offerId"];
            PayMentTableViewController *parMentVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"PayMentTableViewController"];
            parMentVC.offerId = offerId;
            [self.navigationController pushViewController:parMentVC animated:YES];
        }else{
            [self showHint:@"不可识别的二维码!"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if([scanDataString rangeOfString:healthStr].location != NSNotFound){
        
        NSString *birthdayStr = [kUserDefaults objectForKey:kUserBirthDay];
        NSString *sexStr = [kUserDefaults objectForKey:KUserSex];
        if ([birthdayStr isKindOfClass:[NSNull class]]||birthdayStr == nil||[sexStr isKindOfClass:[NSNull class]]||sexStr == nil) {
            CompleteInfoViewController *compInVc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"CompleteInfoViewController"];
            compInVc.scanDataString = scanDataString;
            [self.navigationController pushViewController:compInVc animated:YES];
        }else{
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *startDate = [dateFormatter dateFromString:birthdayStr];
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

            NSURL *url = [NSURL URLWithString:scanDataString];

            NSMutableDictionary *param = @{}.mutableCopy;
            [param setObject:custId forKey:@"uid"];
            [param setObject:name forKey:@"name"];
            [param setObject:custMoible forKey:@"mobile"];
            if ([sexStr isEqualToString:@"1"]) {
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
            if ([sexStr isEqualToString:@"1"]) {
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

            [[NetworkClient sharedInstance] POST:scanDataString dict:param progressFloat:nil succeed:^(id responseObject) {
                [self hideHud];
                if([responseObject[@"success"] boolValue]) {
                    ScanResultController *scanVc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ScanResultController"];
                    scanVc.remindStr = @"资料获取成功";
                    [self.navigationController pushViewController:scanVc animated:YES];
                }else{
                    if (![responseObject isKindOfClass:[NSNull class]]&&![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                        [self showHint:responseObject[@"message"]];
                    }
                }
            } failure:^(NSError *error) {
                [self hideHud];
                [self showHint:@"扫码失败,请重试!"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }else if([scanDataString rangeOfString:smartlearnStr].location != NSNotFound){
        NSMutableDictionary *orderDic = [self getURLParameters:scanDataString];
        if (![orderDic[@"bookId"] isKindOfClass:[NSNull class]]&&orderDic[@"bookId"] != nil) {
            
        }
    }else{
        [self showHint:@"不可识别的二维码!"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(NSMutableDictionary*)getURLParameters:(NSString *)str {
    NSRange range = [str rangeOfString:@"?"];
    if(range.location==NSNotFound) {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *parametersString = [str substringFromIndex:range.location+1];
    
    if([parametersString containsString:@"&"]) {
        
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for(NSString *keyValuePair in urlComponents) {
            
            //生成key/value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString*value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            //key不能为nil
            if(key==nil|| value ==nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            
            if(existValue !=nil) {
                //已存在的值，生成数组。
                if([existValue isKindOfClass:[NSArray class]]) {
                    //已存在的值生成数组
                    NSMutableArray*items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                }else{
                    //非数组
                    [params setValue:@[existValue,value]forKey:key];
                }
            }else{
                //设置值
                [params setValue:value forKey:key];
            }
        }
    }else{
        //单个参数生成key/value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        if(pairComponents.count==1) {
            return nil;
        }
        //分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        //key不能为nil
        if(key ==nil|| value ==nil) {
            return nil;
        }
        //设置值
        [params setValue:value forKey:key];
    }
    return params;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

