//
//  DKViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/9.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "DKViewController.h"
#import "Utils.h"
#import "KqStatusModel.h"
#import "YDKView.h"
#import "YQLocationTool.h"
#import "UserModel.h"
#import <MapKit/MapKit.h>
#import "DkSuccessPopView.h"
#import "NoDataView.h"

@interface DKViewController ()<reConfirmDKDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    
    __weak IBOutlet UIImageView *headerIconView;
    __weak IBOutlet UILabel *nameLab;
    __weak IBOutlet UILabel *yearAndMouthLab;
    __weak IBOutlet UILabel *weekLab;
    
    __weak IBOutlet UIImageView *onWorkDotsView;
    __weak IBOutlet UIView *onWorkDotsLineView;
    
    __weak IBOutlet UILabel *onWorkTitleLab;
    __weak IBOutlet UIView *onWorkBgView;
    __weak IBOutlet UIImageView *DKonWorkView;
    __weak IBOutlet UILabel *onWorkTimeLab;
    __weak IBOutlet UILabel *onWorkLocationLab;
    __weak IBOutlet UITableViewCell *onWorkTableViewCell;
    
    
    __weak IBOutlet UILabel *offWorkTitleLab;
    __weak IBOutlet UIImageView *offWorkDotsView;
    __weak IBOutlet UIView *offWorkDotsLineView;
    __weak IBOutlet UIView *offWorkBgView;
    __weak IBOutlet UIImageView *DKoffWorkView;
    __weak IBOutlet UILabel *offWorkTimeLab;
    __weak IBOutlet UILabel *offWorkLocationLab;
    __weak IBOutlet UITableViewCell *offWorkTableViewCell;
    
    KqStatusModel *inModel;
    KqStatusModel *outModel;
    
    YDKView *onYdkView;
    YDKView *offYdkView;
    NSTimer *_timeNow;
    
    NSString *signAddr;
    NSString *latitude;
    NSString *longtitude;
    NSDictionary *_currentDic;
    
    UILabel *qkLab;
    UIButton *reDkBtn;
    UIImageView *cxdkView;
    
    BOOL isReDk;
    
    NoDataView *_noDataView;
}

@property (strong,nonatomic) CLLocationManager* locationManager;

@end

@implementation DKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    isReDk = NO;
    
    [self monitorNetwork];
    
    BOOL isLocationServiceOpen = [Utils isLocationServiceOpen];
    if (!isLocationServiceOpen) {
        UIAlertView *remainInstall = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位权限未开启,是否去设置开启定位权限?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        
        [remainInstall show];
    }
    
    [self _initView];
    //加载个人信息
    [self _loadPersonMsg];
    
    [self _loadKqTimeData];
    
    [self _loadData];
    
    _timeNow = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    
    [self startLocation];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        }
    }
}

- (void)timerFunc
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    [onWorkTimeLab setText:timestamp];//时间在变化的语句
    [offWorkTimeLab setText:timestamp];
}

-(void)_initView
{
    
    headerIconView.layer.cornerRadius = 35;
    headerIconView.clipsToBounds = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
//    onWorkBgView.hidden = YES;
//    offWorkBgView.hidden = YES;
    
//    onWorkDotsView.size = CGSizeMake(15, 15);
    
    _currentDic = @{};
    
#pragma mark 上班打卡
    onWorkBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *onWorkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onWorkTapAction)];
    [onWorkBgView addGestureRecognizer:onWorkTap];
    
#pragma mark 上班打卡
    offWorkBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *offWorkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offWorkTapAction)];
    [offWorkBgView addGestureRecognizer:offWorkTap];
    
    onYdkView = [[YDKView alloc] initWithFrame:CGRectMake(CGRectGetMinX(onWorkTitleLab.frame), CGRectGetMaxY(onWorkTitleLab.frame)+20, onWorkBgView.width, 80)];
    [onWorkTableViewCell.contentView addSubview:onYdkView];
//    onYdkView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    onYdkView.tag = 100001;
    onYdkView.delegate = self;
    onYdkView.hidden = YES;
    
    offYdkView = [[YDKView alloc] initWithFrame:CGRectMake(CGRectGetMinX(offWorkTitleLab.frame), CGRectGetMaxY(offWorkTitleLab.frame)+20, offWorkBgView.width, 80)];
    [offWorkTableViewCell.contentView addSubview:offYdkView];
//    offYdkView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    offYdkView.tag = 100002;
    offYdkView.delegate = self;
    offYdkView.hidden = YES;
    
    NSDate *currentDate = [NSDate date];//获取当前日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    yearAndMouthLab.text = [NSString stringWithFormat:@"%@",dateString];

    [weekLab setText:[Utils weekdayStringFromDate:[NSDate date]]];
    
    onWorkDotsView.layer.cornerRadius = 15/2;
    onWorkDotsView.clipsToBounds = YES;
    offWorkDotsView.layer.cornerRadius = 15/2;
    offWorkDotsView.clipsToBounds = YES;
    
    qkLab = [[UILabel alloc] initWithFrame:CGRectMake(onWorkTitleLab.frame.origin.x, CGRectGetMaxY(onWorkTitleLab.frame)+12, 80, 30)];
    qkLab.text = @"缺卡";
    qkLab.textColor = [UIColor colorWithHexString:@"#FF4359"];
    qkLab.font = [UIFont systemFontOfSize:17];
    qkLab.hidden = YES;
    [onWorkTableViewCell.contentView addSubview:qkLab];
    
    reDkBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(qkLab.frame) +15, 0, 80, qkLab.height)];
    reDkBtn.centerY = qkLab.centerY;
    reDkBtn.hidden = YES;
    [reDkBtn addTarget:self action:@selector(reDKAction:) forControlEvents:UIControlEventTouchUpInside];
    [reDkBtn setTitle:@"重新打卡" forState:UIControlStateNormal];
    [reDkBtn setTitleColor:[UIColor colorWithHexString:@"#FF4359"] forState:UIControlStateNormal];
    [reDkBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [onWorkTableViewCell.contentView addSubview:reDkBtn];
    
    cxdkView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(reDkBtn.frame)+1.5*wScale, 0, 15, 15)];
    cxdkView.hidden = YES;
    cxdkView.image = [UIImage imageNamed:@"redk"];
    cxdkView.centerY = reDkBtn.centerY;
    [onWorkTableViewCell.contentView addSubview:cxdkView];
    
    // 加载失败图片
    _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight -49)];
    _noDataView.hidden = YES;
    _noDataView.backgroundColor = [UIColor whiteColor];
    _noDataView.label.text = @"对不起,网络连接失败";
    _noDataView.imgView.image = [UIImage imageNamed:@"webView_noNetWork"];
    _noDataView.imgView.frame = CGRectMake(10, 15, 150, 150);
    [self.view addSubview:_noDataView];
    
}

#pragma mark 监听网络变化
- (void)monitorNetwork {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                //NSLog(@"未识别的网络");
                _noDataView.hidden = NO;
                
//                _noNetworkView.hidden = NO;
//                _noDataView.hidden = YES;
                // 无网络
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotNetworkNotification" object:nil];
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                //NSLog(@"不可达的网络(未连接)");
//                _noNetworkView.hidden = NO;
//                _noDataView.hidden = YES;
                _noDataView.hidden = NO;
                
                // 无网络
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotNetworkNotification" object:nil];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //NSLog(@"2G,3G,4G...的网络");
                _noDataView.hidden = YES;
                
//                _noNetworkView.hidden = YES;
//                _noDataView.hidden = YES;
                [self _loadData];
                // 恢复网络
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"ResumeNetworkNotification" object:nil];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //NSLog(@"wifi的网络");
//                _noNetworkView.hidden = YES;
//                _noDataView.hidden = YES;
                _noDataView.hidden = YES;
                
                [self _loadData];
                // 恢复网络
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"ResumeNetworkNotification" object:nil];
                break;
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
}



#pragma mark 上班打卡
-(void)onWorkTapAction
{
    [self saveDkRecords:@"IN"];
    [self startLocation];
}

#pragma mark 下班打卡
-(void)offWorkTapAction
{
    BOOL isYes = [Utils isBetweenFromHour:18 toHour:24];
    if (isYes) {
        [self saveDkRecords:@"OUT"];
        [self startLocation];
    }else{
        
        UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:@"暂未到下班时间,是否确认打卡?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureInfoAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //确认重新打卡
            [self saveDkRecords:@"OUT"];
            [self startLocation];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [actionSheetController addAction:cancelAction];
        [actionSheetController addAction:sureInfoAction];
        
        [self presentViewController:actionSheetController animated:YES completion:nil];
    }
}

#pragma mark 获取个人信息
-(void)_loadPersonMsg
{
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCustInfo", MainUrl];
    NSMutableDictionary *param = @{}.mutableCopy;
    if(![custId isKindOfClass:[NSNull class]]&&custId != nil){
        [param setObject:custId forKey:@"custId"];
    }
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            UserModel *model = [[UserModel alloc] initWithDataDic:responseObject[@"responseData"]];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                // 员工
                if(![model.CUST_NAME isKindOfClass:[NSNull class]]&&model.CUST_NAME != nil){
                    nameLab.text = model.CUST_NAME;
                }
                
                if(![model.CUST_HEADIMAGE isKindOfClass:[NSNull class]]&&model.CUST_HEADIMAGE != nil){
                    headerIconView.contentMode = UIViewContentModeScaleAspectFill;
                    headerIconView.clipsToBounds = YES;
                    [headerIconView sd_setImageWithURL:[NSURL URLWithString:model.CUST_HEADIMAGE] placeholderImage:[UIImage imageNamed:@"_member_icon"]];
                }
            }
        }
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark 保存打卡记录
-(void)saveDkRecords:(NSString *)type
{
    [self showHudInView:self.view hint:@""];
    //    获取设备uuid
    NSString *udid = [kUserDefaults objectForKey:kDeveicedID];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/storage",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:KUserCertId] forKey:@"certIds"];
    [params setObject:udid forKey:@"macAddr"];
    if (![signAddr isKindOfClass:[NSNull class]]&&signAddr != nil) {
        [params setObject:signAddr forKey:@"signAddr"];
    }else{
        [self hideHud];
        [self showHint:@"请先获取您的位置!"];
        return;
    }
    [params setObject:latitude forKey:@"signLatitude"];
    [params setObject:longtitude forKey:@"signLongitude"];
    [params setObject:@"" forKey:@"signRemark"];
    [params setObject:type forKey:@"signType"];
    [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"custId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            if (isReDk) {
                [self showHint:@"重新打卡成功"];
                isReDk = NO;
            }else{
                [self showHint:@"打卡成功"];
            }
            NSDictionary *dic = responseObject[@"responseData"];
            NSString *timeStr = dic[@"signTime"];
            
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *someDay = [formatter1 dateFromString:timeStr];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSString *currentDateString = [formatter stringFromDate:someDay];
            
            if ([type isEqualToString:@"IN"]) {
//                DkSuccessPopView *onPopView = [[DkSuccessPopView alloc] initWithtimeTitle:currentDateString type:onWorkPopView];
//                [onPopView showInView:kAppWindow];
            }else{
//                DkSuccessPopView *offPopView = [[DkSuccessPopView alloc] initWithtimeTitle:currentDateString type:offWorkPopView];
//                [offPopView showInView:kAppWindow];
            }
            [self _loadData];
        }else
        {
            [self showHint:responseObject[@"message"]];
            return;
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

#pragma mark 获取作息时间
-(void)_loadKqTimeData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/timeTable",MainUrl];
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            if ([dic[@"isValid"] isEqualToString:@"1"]) {
                onWorkTitleLab.text = [NSString stringWithFormat:@"上班考勤(%@)",dic[@"signinTime"]];
                offWorkTitleLab.text = [NSString stringWithFormat:@"下班考勤(%@)",dic[@"signoutTime"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)_loadData
{
    NSString *timeStr = [Utils getCurrentTime];
    
    NSString *certId = [kUserDefaults objectForKey:KUserCertId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/attendanceRecord/valid",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:certId forKey:@"certIds"];
    [params setObject:timeStr forKey:@"recordDate"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        _noDataView.hidden = YES;
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            _currentDic = dic;
            NSDictionary *indic = dic[@"IN"];
            NSDictionary *outDic = dic[@"OUT"];
            inModel = [[KqStatusModel alloc] initWithDataDic:indic];
            outModel = [[KqStatusModel alloc] initWithDataDic:outDic];
            
            if (indic == nil||indic.allValues.count == 0||[indic isKindOfClass:[NSNull class]]) {
                inModel.status = @"0";
                if ([dic[@"isInLack"] isEqualToString:@"1"]) {
                    onWorkBgView.hidden = YES;
                    onWorkDotsView.image = [UIImage imageNamed:@"dots_blue"];
                    onWorkDotsLineView.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
                    
                    qkLab.hidden = NO;
                    reDkBtn.hidden = NO;
                    cxdkView.hidden = NO;
                
                }else{
                    onWorkBgView.hidden = NO;
                    onWorkDotsView.image = [UIImage imageNamed:@"dots_gray"];
                    onWorkDotsLineView.backgroundColor = [UIColor colorWithHexString:@"#C9C9C9"];
                }
                onYdkView.hidden = YES;
                if ([Utils isBetweenFromHour:0 toHour:12]) {
                    offWorkTableViewCell.contentView.hidden = YES;
                } else {
                    offWorkTableViewCell.contentView.hidden = NO;
                }
            }else{
                offWorkTableViewCell.contentView.hidden = NO;
                
                inModel.status = @"1";
                onWorkDotsView.image = [UIImage imageNamed:@"dots_blue"];
                onWorkDotsLineView.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
                onWorkBgView.hidden = YES;
                onYdkView.cxdkView.hidden = YES;
                onYdkView.cxdkBtn.hidden = YES;
                onYdkView.hidden = NO;
                
                qkLab.hidden = YES;
                reDkBtn.hidden = YES;
                cxdkView.hidden = YES;
            
                onYdkView.locationLab.text = inModel.signAddr;
                if ([inModel.signStatus isEqualToString:@"1"]) {
                    onYdkView.statusView.image = [UIImage imageNamed:@"normal"];
                }else if ([inModel.signStatus isEqualToString:@"2"]){
                    onYdkView.statusView.image = [UIImage imageNamed:@"later"];
                }else{
                    onYdkView.statusView.image = [UIImage imageNamed:@"kq_leaveEarly"];
                }
                
                onYdkView.dkTimeLab.text = [NSString stringWithFormat:@"%@已打卡",inModel.trunSignTime];
            }
            if (outDic == nil||outDic.allValues.count == 0||[outDic isKindOfClass:[NSNull class]]) {
                outModel.status = @"0";
                offWorkBgView.hidden = NO;
                offYdkView.hidden = YES;
                offWorkDotsView.image = [UIImage imageNamed:@"dots_gray"];
                offWorkDotsLineView.backgroundColor = [UIColor colorWithHexString:@"#C9C9C9"];
            }else{
                outModel.status = @"1";
                offWorkBgView.hidden = YES;
                offYdkView.hidden = NO;
                offYdkView.locationLab.text = outModel.signAddr;
                if ([outModel.signStatus isEqualToString:@"1"]) {
                    offYdkView.statusView.image = [UIImage imageNamed:@"normal"];
                }else if ([outModel.signStatus isEqualToString:@"2"]){
                    offYdkView.statusView.image = [UIImage imageNamed:@"later"];
                }else{
                    offYdkView.statusView.image = [UIImage imageNamed:@"kq_leaveEarly"];
                }
                offYdkView.dkTimeLab.text = [NSString stringWithFormat:@"%@已打卡",outModel.trunSignTime];
                offWorkDotsView.image = [UIImage imageNamed:@"dots_blue"];
                offWorkDotsLineView.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    YYReachability *rech = [YYReachability reachability];
    if (!rech.reachable) {
        height = 1;
    }else{
        if (indexPath.row == 1) {
            if ([inModel.status isEqualToString:@"1"]) {
                height = 100;
            }else{
                if ([_currentDic[@"isInLack"] isEqualToString:@"1"]) {
                    height = 100;
                }else{
                    height = 260;
                }
            }
        }else if(indexPath.row == 2){
            if ([inModel.status isEqualToString:@"1"]) {
                if ((self.tableView.height-130-100-49)>260) {
                    height = self.tableView.height-130-100-49;
                }else{
                    if ([outModel.status isEqualToString:@"1"]) {
                        height = self.tableView.height-130-100-49;
                    }else{
                        height = 260;
                    }
                }
            }else{
                if ([outModel.status isEqualToString:@"1"]) {
                    height = 100;
                }else{
                    height = 260;
                }
            }
            
        }else{
            height = 130;
        }

    }
    return height;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark 重新打卡
-(void)reConfirmDKAction:(id)object
{
    YDKView *ydkView = (YDKView *)object;
    if (ydkView.tag == 100001) {
        return;
    }else{
        isReDk = YES;
        [self saveDkRecords:@"OUT"];
        [self startLocation];
    }
}

#pragma mark 上班重新打卡
-(void)reDKAction:(id)sender
{
    [self saveDkRecords:@"IN"];
    [self startLocation];
}

#pragma mark 定位自己
//开始定位

-(void)startLocation{
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.locationManager.distanceFilter = 100.0f;
    
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] >8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }break;
        default:break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *newLocation = locations[0];
    
//    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    [manager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        
        for (CLPlacemark *place in placemarks) {
            
            signAddr = [NSString stringWithFormat:@"%@%@",place.thoroughfare,place.name];
            latitude = [NSString stringWithFormat:@"%lf",place.location.coordinate.latitude];
            longtitude = [NSString stringWithFormat:@"%lf",place.location.coordinate.longitude];
            
            onWorkLocationLab.text = signAddr;
            offWorkLocationLab.text = signAddr;
            
        }
    }];
}

-(void)dealloc
{
    [_timeNow invalidate];
    _timeNow = nil;
    self.locationManager.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
