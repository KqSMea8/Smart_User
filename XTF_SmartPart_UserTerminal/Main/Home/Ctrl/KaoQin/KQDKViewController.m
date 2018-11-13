//
//  KQDKViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/3/22.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "KQDKViewController.h"
#import "Utils.h"
#import "YDKTableViewCell.h"
#import "WDKTableViewCell.h"
#import "OffWorkYDKTableViewCell.h"
#import "QKTableViewCell.h"
#import "UserModel.h"
#import "KqStatusModel.h"
#import "DkSuccessPopView.h"
#import "OutWorkDKView.h"
#import "YQScanImage.h"
#import "LocationManager.h"
#import "CameraViewController.h"
#import "YQEmptyView.h"
#import "LeaveEarlyDkView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Zip.h"
#import "MyInfomatnTabViewController.h"
#import "HumanFaceViewController.h"
#import "UIView+Extension.h"

@interface KQDKViewController ()<UITableViewDelegate,UITableViewDataSource,panchDelegate,reConfirmDKDelegate,offWorkReSaveRecordDelegate,wqDkSaveRecordDelegate,onWorkRecordDelegate,imagePickerDelegate,LeaveEarlyDelegate>
{
    NSString *_nameStr;
    NSString *_custheadimage;
    //考勤的上下班时间
    NSString *_onWorkTime;
    NSString *_offWorkTime;
    
    NSString *_actualOffTime;

    NSString *_isInLack;
    NSString *_isWorkDay;
    
    NSString *signAddr;
    NSString *latitude;
    NSString *longtitude;
    //当前打卡类型
    NSString *_signType;
    //人像id
    NSString *_faceId;
    OutWorkDKView *_outView;
    
    NSString *_timestamp;
    
    NSDictionary *_indic;
    NSDictionary *_outDic;
}

@property (nonatomic,strong) UITableView *tabView;

@property (nonatomic,strong) NSMutableArray *statusDataArr;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSTimer *timer;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation KQDKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *kqtimeStr = [kUserDefaults objectForKey:kqTime];
    NSString *kqDevationStr = [kUserDefaults objectForKey:kqDeviation];
    
    NSArray *timeArr = [kqtimeStr componentsSeparatedByString:@","];
    NSArray *kqDevationArr = [kqDevationStr componentsSeparatedByString:@","];
    _onWorkTime = timeArr.firstObject;
    _offWorkTime = timeArr.lastObject;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH:mm";
    NSDate *data = [format dateFromString:_offWorkTime];
    NSTimeInterval time = [kqDevationArr.lastObject integerValue]*60;
    NSDate *actualDate = [data dateByAddingTimeInterval:-time];
    _actualOffTime = [format stringFromDate:actualDate];
    
    [self cheakLocationAuthorization];
    
    [self locationSelf:@"0"];
    
    _statusDataArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
//    如果不添加下面这条语句，在UITableView拖动的时候，会阻塞定时器的调用
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];

    [self initView];
    
    [self _loadData];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [kNotificationCenter postNotificationName:@"tabbarDidSelectItemNotification" object:nil];
}


-(BOOL)cheakLocationAuthorization
{
    BOOL isAuth = NO;
    //判断设备是否开启定位服务
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        //定位功能可用
        isAuth = YES;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        UIAlertView *remainInstall = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有定位权限,请去-> [设置 - 隐私 - 定位服务 - 智慧天园] 获取定位权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        remainInstall.tag = 100002;
        [remainInstall show];
        isAuth = NO;
    }
    return isAuth;
}

- (YQEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [YQEmptyView diyEmptyView];
    }
    return _noDataView;
}

- (YQEmptyView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [YQEmptyView diyEmptyActionViewWithTarget:self action:@selector(_loadData)];
    }
    return _noNetworkView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100002) {
        if (buttonIndex == 1) {
            if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
        }
    }else{
        if (buttonIndex == 1) {
            // 系统是否大于10
            NSURL *url = nil;
            if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
                url = [NSURL URLWithString:@"prefs:root=privacy"];
                
            } else {
                url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            }
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

//时间在变化的语句
- (void)timerFunc
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    _timestamp = [formatter stringFromDate:[NSDate date]];
    
    UITableViewCell *cell = [self.tabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if ([cell isKindOfClass:[WDKTableViewCell class]]) {
        WDKTableViewCell *cell2 = (WDKTableViewCell *)cell;
        cell2.timeLab.text = _timestamp;
    }
    UITableViewCell *cell1 = [self.tabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if ([cell1 isKindOfClass:[WDKTableViewCell class]]) {
        WDKTableViewCell *cell3 = (WDKTableViewCell *)cell1;
        cell3.timeLab.text = _timestamp;
    }
    
    _outView.time = _timestamp;
}

-(void)_loadData
{
    //加载个人信息数据
    [self _loadPersonMsg];
    //加载考勤记录数据
    [self _loadKqData];
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
                    _nameStr = model.CUST_NAME;
                }
                if(![model.CUST_HEADIMAGE isKindOfClass:[NSNull class]]&&model.CUST_HEADIMAGE != nil){
                    _custheadimage = model.CUST_HEADIMAGE;
                }
                _faceId = model.FACE_IMAGE_ID;
            }
        }
        [self.tabView reloadData];
    } failure:^(NSError *error) {
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            self.tabView.ly_emptyView = self.noNetworkView;
            [self.tabView reloadData];
            [self.tabView ly_endLoading];
        }else{
            self.tabView.ly_emptyView = self.noDataView;
            [self.tabView reloadData];
            [self.tabView ly_endLoading];
        }
    }];
}

#pragma mark 加载考勤记录数据
-(void)_loadKqData
{
    NSString *timeStr = [Utils getCurrentTime];
    NSString *certId = [kUserDefaults objectForKey:KUserCertId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/attendanceRecord/valid",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:certId forKey:@"certIds"];
    [params setObject:@"" forKey:@"recordDate"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [_dataArr removeAllObjects];
            [_statusDataArr removeAllObjects];
            NSDictionary *dic = responseObject[@"responseData"];
            _indic = dic[@"IN"];
            _outDic = dic[@"OUT"];
            KqStatusModel *model = [[KqStatusModel alloc] initWithDataDic:_indic];
            KqStatusModel *model1 = [[KqStatusModel alloc] initWithDataDic:_outDic];
            _isInLack = dic[@"isInLack"];
            _isWorkDay = dic[@"isWorkDay"];
            if ([_indic isKindOfClass:[NSNull class]]||_indic.allKeys.count == 0) {
                if ([_outDic isKindOfClass:[NSNull class]]||_outDic.allKeys.count == 0) {
                    if ([_isInLack isEqualToString:@"1"]) {
                        [_statusDataArr addObject:@"0"];
                        [_statusDataArr addObject:@"0"];
                    }else{
                       [_statusDataArr addObject:@"0"];
                    }
                }else{
                    [_statusDataArr addObject:@"0"];
                    [_statusDataArr addObject:@"1"];
                    [_dataArr addObject:model1];
                }
            }else{
                if ([_outDic isKindOfClass:[NSNull class]]||_outDic.allKeys.count == 0) {
                    [_statusDataArr addObject:@"1"];
                    [_statusDataArr addObject:@"0"];
                    [_dataArr addObject:model];
                }else{
                    [_statusDataArr addObject:@"1"];
                    [_statusDataArr addObject:@"1"];
                    [_dataArr addObject:model];
                    [_dataArr addObject:model1];
                }
            }
            
            [self.tabView reloadData];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }
        if (!rech.reachable) {
            self.tabView.ly_emptyView = self.noNetworkView;
            [self.tabView reloadData];
            [self.tabView ly_endLoading];
        }else{
            self.tabView.ly_emptyView = self.noDataView;
            [self.tabView reloadData];
            [self.tabView ly_endLoading];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    NSString *faceimageid = [kUserDefaults objectForKey:KFACE_IMAGE_ID];
    NSString *companyId = [kUserDefaults objectForKey:companyID];
    NSString *orgId = [kUserDefaults objectForKey:OrgId];
    if ([faceimageid isKindOfClass:[NSNull class]]||faceimageid == nil||faceimageid.length == 0) {
        [self showHint:@"请先录入人像信息!" yOffset:-120];
        [self performSelector:@selector(presentHumanFaceVC) withObject:nil afterDelay:0];
    }else if([companyId isKindOfClass:[NSNull class]]||companyId == nil||companyId.length == 0||[orgId isKindOfClass:[NSNull class]]||orgId == nil||orgId.length == 0){
        [self showHint:@"请先绑定公司和部门!" yOffset:-120];
        [self performSelector:@selector(presentPersonInfoVC) withObject:nil afterDelay:0];
    }
}

-(void)initView{
    self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-49-kTopHeight) style:UITableViewStylePlain];
    [self.tabView registerNib:[UINib nibWithNibName:@"WDKTableViewCell" bundle:nil] forCellReuseIdentifier:@"WDKTableViewCell"];
    [self.tabView registerNib:[UINib nibWithNibName:@"YDKTableViewCell" bundle:nil] forCellReuseIdentifier:@"YDKTableViewCell"];
    [self.tabView registerNib:[UINib nibWithNibName:@"OffWorkYDKTableViewCell" bundle:nil] forCellReuseIdentifier:@"OffWorkYDKTableViewCell"];
    [self.tabView registerNib:[UINib nibWithNibName:@"QKTableViewCell" bundle:nil] forCellReuseIdentifier:@"QKTableViewCell"];
    self.tabView.bounces = NO;
    self.tabView.backgroundColor = [UIColor whiteColor];
    self.tabView.separatorColor = [UIColor clearColor];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    [self.view addSubview:self.tabView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statusDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (_statusDataArr.count == 1) {
        WDKTableViewCell *wdkCell = [tableView dequeueReusableCellWithIdentifier:@"WDKTableViewCell"];
        wdkCell.signAddr = signAddr;
        wdkCell.latitude = latitude;
        wdkCell.longtitude = longtitude;
        wdkCell.delegate = self;
        wdkCell.type = @"0";
        wdkCell.onWorkTime = [NSString stringWithFormat:@"上班考勤(%@)",_onWorkTime];
        cell = wdkCell;
    }else{
        if (indexPath.row  == 0) {
            NSString *status1 = _statusDataArr[0];
            NSString *status2 = _statusDataArr[1];
            if ([status1 isEqualToString:@"0"]) {
                if ([_isInLack isEqualToString:@"1"]) {
                    QKTableViewCell *qkCell = [tableView dequeueReusableCellWithIdentifier:@"QKTableViewCell"];
                    qkCell.onWorkTime = [NSString stringWithFormat:@"上班考勤(%@)",_onWorkTime];
                    if ([status2 isEqualToString:@"0"]) {
                        qkCell.isAllowReDk = @"1";
                    }else{
                        qkCell.isAllowReDk = @"0";
                    }
                    qkCell.signAddr = signAddr;
                    qkCell.delegate = self;
                    cell = qkCell;
                }else{
                    WDKTableViewCell *wdkCell = [tableView dequeueReusableCellWithIdentifier:@"WDKTableViewCell"];
                    wdkCell.delegate = self;
                    wdkCell.type = @"0";
                    wdkCell.onWorkTime = [NSString stringWithFormat:@"上班考勤(%@)",_onWorkTime];
                    wdkCell.signAddr = signAddr;
                    cell = wdkCell;
                }
            }else{
                YDKTableViewCell *ydkCell = [tableView dequeueReusableCellWithIdentifier:@"YDKTableViewCell"];
                ydkCell.delegate = self;
                ydkCell.isWorkDay = _isWorkDay;
                ydkCell.islack = _isInLack;
                ydkCell.onWorkTime = [NSString stringWithFormat:@"上班考勤(%@)",_onWorkTime];
                ydkCell.signAddr = signAddr;
                ydkCell.model = _dataArr[indexPath.row];
                cell = ydkCell;
            }
        }else{
            NSString *status2 = _statusDataArr[1];
            if ([status2 isEqualToString:@"0"]) {
                WDKTableViewCell *wdkCell = [tableView dequeueReusableCellWithIdentifier:@"WDKTableViewCell"];
                wdkCell.signAddr = signAddr;
                wdkCell.latitude = latitude;
                wdkCell.longtitude = longtitude;
                wdkCell.delegate = self;
                wdkCell.type = @"1";
                wdkCell.onWorkTime = [NSString stringWithFormat:@"下班考勤(%@)",_offWorkTime];
                cell = wdkCell;
            }else{
                OffWorkYDKTableViewCell *ydkCell = [tableView dequeueReusableCellWithIdentifier:@"OffWorkYDKTableViewCell"];
                ydkCell.isWorkDay = _isWorkDay;
                ydkCell.onWorkTime = [NSString stringWithFormat:@"下班考勤(%@)",_offWorkTime];
                ydkCell.delegate = self;
                ydkCell.signAddr = signAddr;
                if ([_indic isKindOfClass:[NSNull class]]||_indic.allKeys.count == 0) {
                    ydkCell.model = _dataArr[indexPath.row-1];
                }else{
                    ydkCell.model = _dataArr[indexPath.row];
                }
                cell = ydkCell;
            }
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.row == 0) {
        NSString *status = _statusDataArr[0];
        if ([status isEqualToString:@"0"]) {
            if ([_isInLack isEqualToString:@"1"]) {
                height = 110;
            }else{
                height = 290;
            }
        }else{
            height = 110;
        }
    }else{
        NSString *status = _statusDataArr[1];
        if ([status isEqualToString:@"0"]) {
            height = 290;
        }else{
            height = 140;
        }
    }
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(22.5, 20, 70, 70)];
    iconView.layer.cornerRadius = 35;
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.clipsToBounds = YES;
    [iconView sd_setImageWithURL:[NSURL URLWithString:_custheadimage] placeholderImage:[UIImage imageNamed:@"_member_icon"]];
    [view addSubview:iconView];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(12.5, iconView.bottom+10, 90, 18)];
    nameLab.font = [UIFont systemFontOfSize:17];
    nameLab.textColor = [UIColor blackColor];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = _nameStr;
    [view addSubview:nameLab];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, KScreenWidth, 5)];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [view addSubview:bottomView];
    
    UILabel *yearAndMonthLab = [[UILabel alloc] initWithFrame:CGRectMake(iconView.right + 30, 46, 150, 18)];
    NSDate *currentDate = [NSDate date];//获取当前日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    yearAndMonthLab.text = [NSString stringWithFormat:@"%@",dateString];
    
    yearAndMonthLab.font = [UIFont systemFontOfSize:17];
    yearAndMonthLab.textAlignment = NSTextAlignmentLeft;
    yearAndMonthLab.textColor = [UIColor blackColor];
    [view addSubview:yearAndMonthLab];
    
    UILabel *weekLab = [[UILabel alloc] initWithFrame:CGRectMake(iconView.right + 30, yearAndMonthLab.bottom+12.5, 120, 18)];
    weekLab.text = [Utils weekdayStringFromDate:[NSDate date]];
    weekLab.font = [UIFont systemFontOfSize:17];
    weekLab.textAlignment = NSTextAlignmentLeft;
    weekLab.textColor = [UIColor blackColor];
    [view addSubview:weekLab];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 145;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}

#pragma mark panchDelegate
//打卡相关代理
-(void)panch:(NSString *)signType
{
    _signType = signType;
    
    BOOL isAuth = [self cheakLocationAuthorization];
    if (isAuth) {
        if ([_signType isEqualToString:@"OUT"]) {
            if ([_isWorkDay isEqualToString:@"1"]) {
                if ([self isItWithinRange]) {
                    NSString *hourTime = [Utils getCurrentHourTime];
                    NSString *offWorkTime = [_actualOffTime stringByReplacingOccurrencesOfString:@":" withString:@""];
                    NSString *currentTime = [hourTime stringByReplacingOccurrencesOfString:@":" withString:@""];
                    if ([offWorkTime integerValue] > [currentTime integerValue]) {
                        //早退
                        LeaveEarlyDkView *leaEarlyView = [[LeaveEarlyDkView alloc] initWithsignTime:hourTime];
                        leaEarlyView.delegate = self;
                        leaEarlyView.signType = _signType;
                        [leaEarlyView show];
                        
                    }else if([offWorkTime integerValue] < [currentTime integerValue]){
                        [self locationSelf:@"1"];
                    }else{
                        [self locationSelf:@"1"];
                    }
                }else{
                    [self locationSelf:@"1"];
                }
            }else{
                [self locationSelf:@"1"];
            }
        }else{
            [self locationSelf:@"1"];
        }
    }
}

#pragma mark 调用相机
-(void)openCamera
{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有相机访问权限,请去-> [设置 - 隐私 - 相机 - 智慧天园] 获取相机访问权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        alertView.tag = 100001;
        [alertView show];
        return;
    }
    CameraViewController *camVC = [[CameraViewController alloc] init];
    camVC.leftBtnTitle = @"重拍";
    camVC.rightBtnTitle = @"确认打卡";
    camVC.delegate = self;
    [self presentViewController:camVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
// 拍照完成回调
-(void)imagePicker:(UIViewController *)picker didFinishPickingImage:(UIImage *)image
{
    UIImage *fixImage = [Utils fixOrientation:image];
    NSData *data = [UIImage compressWithOrgImg:fixImage];
    [self uploadFaceImage:[UIImage imageWithData:data]];
}

#pragma mark 上班缺卡重新打卡
-(void)reConfirmDKAction:(NSString *)type
{
    _signType = type;
    
    BOOL isAuth = [self cheakLocationAuthorization];
    if (isAuth) {
        [self locationSelf:@"1"];
    }
}

#pragma mark 上班外勤卡重新打卡
-(void)onWorkreSaveRecord:(NSString *)signType
{
    _signType = signType;
    BOOL isAuth = [self cheakLocationAuthorization];
    if (isAuth) {
        [self locationSelf:@"1"];
    }
}

-(void)locationSelf:(NSString *)locationType{
    if ([locationType isEqualToString:@"1"]) {
        [self showHudInView:self.view hint:nil];
    }
    __weak typeof(self) weakSelf = self;
    [LocationManager getGps:^(CLLocation *location) {
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        if ([locationType isEqualToString:@"1"]) {
            [LocationManager stop];
        }
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
            if ([placemarks isKindOfClass:[NSNull class]]||placemarks == nil||placemarks.count == 0) {
                [weakSelf hideHud];
                [self showHint:@"当前网络状况不好，定位失败!"];
            }
            [weakSelf hideHud];
            for (CLPlacemark *place in placemarks) {
                NSDictionary *addressDic = place.addressDictionary;
                NSString *city=[addressDic objectForKey:@"City"];
                NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
                NSString *street=[addressDic objectForKey:@"Street"];
                
                latitude = [NSString stringWithFormat:@"%lf",place.location.coordinate.latitude];
                longtitude = [NSString stringWithFormat:@"%lf",place.location.coordinate.longitude];
                
                if ([locationType isEqualToString:@"1"]) {
                    
                    BOOL isInRange = [self isItWithinRange];
                    if (isInRange) {
                        [weakSelf openCamera];
                    }else{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未进入打卡范围" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                }else{
                    if ([city isKindOfClass:[NSNull class]]||city == nil) {
                        city = @"";
                    }
                    if ([subLocality isKindOfClass:[NSNull class]]||subLocality == nil) {
                        subLocality = @"";
                    }
                    if ([street isKindOfClass:[NSNull class]]||street == nil) {
                        street = @"";
                    }
                    signAddr = [NSString stringWithFormat:@"%@%@%@",city,subLocality,street];
                    [weakSelf.tabView reloadData];
                }
            }
        }];
    }];
}

#pragma mark 下班重新打卡
-(void)offWorkreSaveRecord:(NSString *)signType
{
    [self hideHud];
    _signType = signType;
    
    NSString *hourTime = [Utils getCurrentHourTime];
    NSString *offWorkTime = [_actualOffTime stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *currentTime = [hourTime stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    if ([_isWorkDay isEqualToString:@"1"]) {
        if ([self isItWithinRange]) {
            if ([offWorkTime integerValue] > [currentTime integerValue]) {
                //早退
                LeaveEarlyDkView *leaEarlyView = [[LeaveEarlyDkView alloc] initWithsignTime:hourTime];
                leaEarlyView.delegate = self;
                leaEarlyView.signType = _signType;
                [leaEarlyView show];
                
            }else if([offWorkTime integerValue] < [currentTime integerValue]){
                [self locationSelf:@"1"];
            }else{
                [self locationSelf:@"1"];
            }
        }else{
            [self locationSelf:@"1"];
        }
    }else{
        [self locationSelf:@"1"];
    }
}

-(BOOL)isItWithinRange
{
    BOOL isSatisfy = NO;
    
    NSString *positionStr = [kUserDefaults objectForKey:kqPosition];
    NSArray *positionArr = [positionStr componentsSeparatedByString:@"|"];
    
    NSString *range = [kUserDefaults objectForKey:kqRange];
    for (int i = 0; i < positionArr.count; i++) {
        NSString *postion = positionArr[i];
        NSArray *currComPositionArr = [postion componentsSeparatedByString:@","];
        
        double distance = [Utils distanceBetweenOrderBy:[latitude doubleValue] :[currComPositionArr.lastObject doubleValue] :[longtitude doubleValue] :[currComPositionArr.firstObject doubleValue]];
        if (distance < [range doubleValue]) {
            isSatisfy = YES;
        }
    }
    return isSatisfy;
}

#pragma mark 对比图片
-(void)uploadFaceImage:(UIImage *)image
{
    //是否进入考勤范围
//    latitude = @"28.188848";
//    longtitude = @"113.005027";
    
    BOOL isSatisfy = NO;
    
    NSString *positionStr = [kUserDefaults objectForKey:kqPosition];
    NSArray *positionArr = [positionStr componentsSeparatedByString:@"|"];
    
    NSString *range = [kUserDefaults objectForKey:kqRange];
    for (int i = 0; i < positionArr.count; i++) {
        NSString *postion = positionArr[i];
        NSArray *currComPositionArr = [postion componentsSeparatedByString:@","];
        double distance = [Utils distanceBetweenOrderBy:[latitude doubleValue] :[currComPositionArr.lastObject doubleValue] :[longtitude doubleValue] :[currComPositionArr.firstObject doubleValue]];
        if (distance < [range doubleValue]) {
            isSatisfy = YES;
        }
    }
    
    if (isSatisfy) {
        [self saveKqRecord:image isSatisfy:isSatisfy signRemark:nil];
    }else{
        [self.tabView reloadData];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未进入打卡范围" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
//        _outView = [[OutWorkDKView alloc] initWithimage:image signTime:_timestamp signAddr:signAddr];
//        _outView.delegate = self;
//        _outView.signType = _signType;
//        [_outView show];
    }
}

#pragma mark 外勤打卡代理
-(void)wqDkSaveRecord:(NSString *)signType humanFace:(UIImage *)image signRemake:(NSString *)mark
{
    if ([mark isKindOfClass:[NSNull class]]||mark == nil||mark.length == 0) {
        [self showHint:@"请输入外勤打卡备注!"];
        return;
    }
    
    [self saveKqRecord:image isSatisfy:NO signRemark:mark];
    
    [_outView dismiss];
}

#pragma mark 早退打卡
-(void)leaveEarlyContinueDk:(NSString *)type
{
    _signType = type;
    
    BOOL isAuth = [self cheakLocationAuthorization];
    if (isAuth) {
        [self locationSelf:@"1"];
    }
}

-(void)saveKqRecord:(UIImage *)image isSatisfy:(BOOL)satisfy signRemark:(NSString *)remark;
{
    //    获取设备uuid
    NSString *udid = [kUserDefaults objectForKey:kDeveicedID];
    NSString *certid = [kUserDefaults objectForKey:KUserCertId];
    NSString *kcustid = [kUserDefaults objectForKey:kCustId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/storage",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:certid forKey:@"certIds"];
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
    [params setObject:_signType forKey:@"signType"];
    [params setObject:kcustid forKey:@"custId"];
    if (remark.length > 0) {
        [params setObject:remark forKey:@"signRemark"];
    }
    
    if (satisfy) {
        [params setObject:@"0" forKey:@"isOutside"];
    }else{
        [params setObject:@"1" forKey:@"isOutside"];
    }
    [params setObject:_faceId forKey:@"faceImageId"];
    NSString *companyid = [kUserDefaults objectForKey:companyID];
    if ([companyid isKindOfClass:[NSNull class]]||companyid == nil||companyid.length == 0) {
        
    }else{
        [params setObject:[kUserDefaults objectForKey:companyID] forKey:@"companyId"];
    }
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] UPLOAD:urlStr dict:params imageArray:@[image] progressFloat:^(float progressFloat) {
        
    } succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [self showHint:@"打卡成功"];
            NSDictionary *dic = responseObject[@"responseData"];
            NSString *timeStr = dic[@"signTime"];
            
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *someDay = [formatter1 dateFromString:timeStr];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSString *currentDateString = [formatter stringFromDate:someDay];
            
            NSString *signRemark = dic[@"signRemark"];
            
            if ([_signType isEqualToString:@"IN"]) {
                DkSuccessPopView *onPopView = [[DkSuccessPopView alloc] initWithtimeTitle:currentDateString type:onWorkPopView signContent:signRemark];
                [onPopView showInView:kAppWindow];
            }else{
                DkSuccessPopView *offPopView = [[DkSuccessPopView alloc] initWithtimeTitle:currentDateString type:offWorkPopView signContent:signRemark];
                [offPopView showInView:kAppWindow];
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

//人像录入
-(void)presentHumanFaceVC{
    HumanFaceViewController *humanVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"HumanFaceViewController"];
    humanVC.type = @"1";
    [self.navigationController pushViewController:humanVC animated:YES];
}
//个人信息
-(void)presentPersonInfoVC
{
    MyInfomatnTabViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfomatnTabViewController"];
    myInfoVC.type = @"1";
    [self.navigationController pushViewController:myInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    [kNotificationCenter removeObserver:self name:@"tabbarDidSelectItemNotification" object:nil];
}

@end
