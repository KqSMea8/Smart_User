//
//  BookDetailsViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/5.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BookDetailsViewController.h"
#import "Utils.h"
#import "PopView.h"
#import "ReservationRemindViewController.h"
#import "BookRecordModel.h"
#import "BookRecordParkAreaModel.h"
#import "BookRecordParkSpaceModel.h"

@interface BookDetailsViewController ()<DeclarePopViewDelegate,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UILabel *bookMessageLab;
    __weak IBOutlet UILabel *minLab;//分
    __weak IBOutlet UILabel *secLab;//秒
    __weak IBOutlet UIButton *navBtn;
    __weak IBOutlet UIButton *cancleBookBtn;
    __weak IBOutlet UIButton *unlockBtn;
    __weak IBOutlet UILabel *parkName;
    __weak IBOutlet UILabel *bookNumLab;
    __weak IBOutlet UILabel *bookTimeLab;
    
    NSInteger _aptTime; // 单位秒
    NSTimer *_timer;
    NSDate *_enterBDate;
}

@end

@implementation BookDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _aptTime = 1800;
    
    // app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    [self initNavItems];
    
    [self initView];
}

- (void)applicationEnterBackground {
    
    _enterBDate = [NSDate date];
    _timer.fireDate = [NSDate distantFuture];
}

- (void)applicationBecomeActive {
    if ([_timer isValid]) {
        NSDate *activeDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *time = [Utils dateTimeDifferenceWithStartTime:[dateFormatter stringFromDate:_enterBDate] endTime:[dateFormatter stringFromDate:activeDate]];
        
        if ([time integerValue]>=_aptTime) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            _aptTime = _aptTime - [time integerValue];
        }
        [self startTime];
    }
}

-(void)initNavItems
{
    self.title = @"预约详情";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)setOrderModel:(BookRecordModel *)orderModel
{
    _orderModel = orderModel;
    
    _aptTime = [[Utils dateTimeDifferenceWithStartTime:orderModel.orderTime endTime:orderModel.invalidTime] integerValue];
}

-(void)setParkAreaModel:(BookRecordParkAreaModel *)parkAreaModel
{
    _parkAreaModel = parkAreaModel;
}

-(void)setParkSpaceModel:(BookRecordParkSpaceModel *)parkSpaceModel
{
    _parkSpaceModel = parkSpaceModel;
}

-(void)setCurrentTime:(NSString *)currentTime
{
    _currentTime = currentTime;
}

-(void)initView
{
    // 禁止左滑
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    navBtn.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    navBtn.layer.cornerRadius = 4;
    navBtn.clipsToBounds = YES;
    
    [cancleBookBtn setTitleColor:[UIColor colorWithHexString:@"#1B82D1"] forState:UIControlStateNormal];
    cancleBookBtn.layer.cornerRadius = 4;
    cancleBookBtn.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
    cancleBookBtn.layer.borderWidth = 0.5;
    cancleBookBtn.clipsToBounds = YES;
    
    [unlockBtn setTitleColor:[UIColor colorWithHexString:@"#1B82D1"] forState:UIControlStateNormal];
    unlockBtn.layer.cornerRadius = 4;
    unlockBtn.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
    unlockBtn.layer.borderWidth = 0.5;
    unlockBtn.clipsToBounds = YES;

    NSString *parckingSpaceName = [NSString stringWithFormat:@"%@",_parkSpaceModel.parkingSpaceName];
    NSString *carNoStr = [NSString stringWithFormat:@"%@",_orderModel.carNo];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@预定%@，车位将保留三十分钟",carNoStr,parckingSpaceName]];
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithHexString:@"#FF0000"]
                       range:NSMakeRange(0, carNoStr.length)];
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithHexString:@"#FF0000"]
                       range:NSMakeRange(carNoStr.length+2, parckingSpaceName.length)];
    bookMessageLab.attributedText = attrString;
    
    parkName.text = [NSString stringWithFormat:@"%@",_parkSpaceModel.parkingName];
    bookNumLab.text = [NSString stringWithFormat:@"%@",_orderModel.orderId];
    bookTimeLab.text = [NSString stringWithFormat:@"%@",[self dateStrFormDateStr:_orderModel.orderTime]];
    
    NSString *sencond = [Utils dateTimeDifferenceWithStartTime:_orderModel.orderTime endTime:_currentTime];
    _aptTime = _aptTime - [sencond integerValue];
    
    [self startTime];
}

- (void)_leftBarBtnItemClick {
    [kNotificationCenter postNotificationName:@"refreshParkAreaStatusNotification" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 导航前往
- (IBAction)navBtnAction:(id)sender {
    [self navPark:_parkAreaModel.latitude.floatValue withLongitude:_parkAreaModel.longitude.floatValue];
}

#pragma mark 取消预约
- (IBAction)cancleBookBtnAction:(id)sender {
    PopView *pView = [[PopView alloc] initWithTitle:@"取消确认" message:@"取消车位预约将不再为您保留车位,确认取消?" delegate:self leftButtonTitle:@"取消" rightButtonTitle:@"确定" type:normalPopView];
    pView.delegate = self;
    [pView show];
}

#pragma mark 打开车位锁
- (IBAction)unlockAction:(id)sender {
    
    NSString *orderId = _orderModel.orderId;
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/operateParkingLock",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderId forKey:@"orderId"];
    [params setObject:@"on" forKey:@"operateType"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [_timer invalidate];
            ReservationRemindViewController *reservationRemindVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationRemindViewController"];
            reservationRemindVC.orderId = _orderModel.orderId;
            reservationRemindVC.type = BookParkAreaOpen;
            [self.navigationController pushViewController:reservationRemindVC animated:YES];
        }else{
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                [self showHint:[NSString stringWithFormat:@"%@",responseObject[@"message"]]];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"开锁失败,请重试!"];
    }];
}

- (void)startTime {
    __weak typeof(self) weakSelf = self;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        _aptTime --;
        NSString *minStr = [NSString stringWithFormat:@"%ld", _aptTime/60];
        if(minStr.length < 2){
            minStr = [NSString stringWithFormat:@"0%@", minStr];
        }
        minLab.text = minStr;
        
        NSString *secStr = [NSString stringWithFormat:@"%ld", _aptTime%60];
        if(secStr.length < 2){
            secStr = [NSString stringWithFormat:@"0%@", secStr];
        }
        secLab.text = secStr;
        
        if(_aptTime <= 0){
            [weakSelf showHint:@"未在规定时间内停入车场,预定车位被取消!"];
            [timer invalidate];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    } repeats:YES];
}

#pragma mark 取消弹窗代理
-(void)declareAlertView:(PopView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *orderId = _orderModel.orderId;
    
        NSString *urlStr = [NSString stringWithFormat:@"%@/parking/cancelOrder",MainUrl];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:orderId forKey:@"orderId"];
        NSString *jsonStr = [Utils convertToJsonData:params];
        NSMutableDictionary *param = @{}.mutableCopy;
        [param setObject:jsonStr forKey:@"param"];
        
        [self showHudInView:kAppWindow hint:nil];
    
        [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
            [self hideHud];
            [alertView dismiss];
            [_timer invalidate];
            if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
                ReservationRemindViewController *reservationRemindVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationRemindViewController"];
                reservationRemindVC.orderId = _orderModel.orderId;
                reservationRemindVC.type = BookCancle;
                [self.navigationController pushViewController:reservationRemindVC animated:YES];
            }else{
                if (![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"] != nil) {
                    [self showHint:responseObject[@"message"]];
                }
            }
        } failure:^(NSError *error) {
            [self hideHud];
            [self showHint:@"取消预约失败!"];
        }];
    }
}

#pragma mark 导航
- (void)navPark:(CGFloat)latitude withLongitude:(CGFloat)longitude {
    
    // 模拟本地经纬度
    //    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(28.147481, 113.065363);
    
    CLLocationCoordinate2D endCoord = CLLocationCoordinate2DMake(latitude, longitude);
    // 导航停车场经纬度 指向一个
//    CLLocationCoordinate2D endCoord = CLLocationCoordinate2DMake(_parkInfoModel.parkLat.floatValue/1000000, _parkInfoModel.parkLng.floatValue/1000000);
    
    UIAlertController *navAlert = [UIAlertController alertControllerWithTitle:@"" message:@"请选地图" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [navAlert addAction:cancel];
    
    // 苹果地图
    UIAlertAction *iosAction = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        currentLocation.name = @"我的位置";
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoord addressDictionary:nil]];
        toLocation.name = @"停车场";
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        
    }];
    [navAlert addAction:iosAction];
    
    // 百度地图
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        UIAlertAction *baiduAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLLocationCoordinate2D bmCoord = [self baiduLocationFromMars_marsLat:endCoord.latitude marsLon:endCoord.longitude];
            
            NSString *navStr = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=%f,%f&mode=driving&coord_type=%@&src=webapp.navi.yourCompanyName.通服园区", bmCoord.latitude, bmCoord.longitude, @"bd09ll"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:navStr]];
            
        }];
        [navAlert addAction:baiduAction];
    }
    
    // 高德地图
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        UIAlertAction *amapAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"通服园区",@"com.transfar.smartpartUser", endCoord.latitude, endCoord.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        [navAlert addAction:amapAction];
    }
    
    if ([navAlert respondsToSelector:@selector(popoverPresentationController)]) {
        navAlert.popoverPresentationController.sourceView = self.view; //必须加
        navAlert.popoverPresentationController.sourceRect = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);//可选，我这里加这句代码是为了调整到合适的位置
    }
    
    [self presentViewController:navAlert animated:YES completion:nil];
}

/** 火星坐标 => 百度坐标 */
- (CLLocationCoordinate2D)baiduLocationFromMars_marsLat:(double)latitude marsLon:(double)longitude {
    double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    double x = longitude, y = latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    double newLatitude = z * sin(theta) + 0.006;
    double newLongitude = z * cos(theta) + 0.0065;
    
    return CLLocationCoordinate2DMake(newLatitude, newLongitude);
}

-(NSString *)dateStrFormDateStr:(NSString *)dateStr
{
    NSDateFormatter *inDateFormat = [[NSDateFormatter alloc] init];
    [inDateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[inDateFormat dateFromString:dateStr];
    
    NSDateFormatter* outDateFormat = [[NSDateFormatter alloc] init];
    [outDateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *currentDateStr = [outDateFormat stringFromDate:date];
    return currentDateStr;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_timer.isValid) {
        [_timer invalidate];
    }
}

-(void)dealloc
{
    _timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
