//
//  WIFIListViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/28.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "WIFIListViewController.h"
#import "WIFITableViewCell.h"
#import "WIFIGuideViewController.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreFoundation/CoreFoundation.h>
#import "Utils.h"
#import <CoreLocation/CoreLocation.h>

@interface WIFIListViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    __weak IBOutlet UILabel *wifiNameLab;
    
    __weak IBOutlet UILabel *wifiStateLab;
    
    __weak IBOutlet UIButton *connectWifiBtn;
    
    BOOL isOutPark;
}

@property (nonatomic,strong) UITableView *tabView;

@property (nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic,assign) CLLocationCoordinate2D coor;

@end

@implementation WIFIListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initNavItems];
    
    [self _initView];
    
    _coor = CLLocationCoordinate2DMake(28.198266,113.069903);
    
    BOOL isLocationServiceOpen = [Utils isLocationServiceOpen];
    if (!isLocationServiceOpen) {
        UIAlertView *remainInstall = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位权限未开启,是否去设置开启定位权限?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        
        [remainInstall show];
    }
    
    // 从后台进入前台的提醒
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWifiList) name:@"EnterForegroundAlert" object:nil];
    
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

//开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        //        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        // 总是授权
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            CGFloat distance = [self distanceBetweenOrderBy:_coor.latitude :placemark.location.coordinate.latitude :_coor.longitude :placemark.location.coordinate.longitude];
//            NSLog(@"%lf",distance);
            if (distance>=1000) {
                isOutPark = YES;
            }else{
                isOutPark = NO;
            }
            [self.tabView reloadData];
        }else if (error == nil && [array count] == 0){
            NSLog(@"No results were returned.");
        }else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}

-(void)refreshWifiList
{
    [self _loadWifiName];
}

-(void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
}

-(void)_initNavItems
{
    self.title = _titleStr;
    
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
    self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, KScreenWidth, KScreenHeight-200) style:UITableViewStylePlain];
//    [self.tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self.tabView registerNib:[UINib nibWithNibName:@"WIFITableViewCell" bundle:nil] forCellReuseIdentifier:@"WIFITableViewCell"];
    self.tabView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    self.tabView.separatorColor = [UIColor clearColor];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    [self.view addSubview:self.tabView];
    
    connectWifiBtn.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    connectWifiBtn.layer.cornerRadius = 6;
    connectWifiBtn.clipsToBounds = YES;
    
    [self _loadWifiName];
    
    _tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self _loadWifiName];
    }];
}

- (void)_loadWifiName {
    NSString *wifiName = [self GetWifiName];
    
    if(wifiName != nil && wifiName.length > 0){
        wifiNameLab.text = wifiName;
        wifiStateLab.text = @"已连接";
    }else {
        wifiNameLab.text = @"请检查当前网络设置";
        wifiStateLab.text = @"未连接";
    }
    [_tabView.mj_header endRefreshing];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WIFITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WIFITableViewCell" forIndexPath:indexPath];
    
    cell.wifiNameLab.text = @"HNTF";
    if (isOutPark) {
        cell.wifiNameLab.textColor = [UIColor lightGrayColor];
        cell.keyImageView.image = [UIImage imageNamed:@"key_gray"];
        cell.wifiImageView.image = [UIImage imageNamed:@"wifi_gray"];
    }else{
        cell.wifiNameLab.textColor = [UIColor blackColor];
        cell.keyImageView.image = [UIImage imageNamed:@"key"];
        cell.wifiImageView.image = [UIImage imageNamed:@"wifi_near"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([kUserDefaults boolForKey:isJumpOverGuide]) {
        NSString * urlString = @"App-Prefs:root=WIFI";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            if (iOS10) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            }
        }
    }else{
        WIFIGuideViewController *wifiGuideVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"WIFIGuideViewController"];
//        wifiGuideVC.isHidenNaviBar = YES;
        [self presentViewController:wifiGuideVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectBtnAction:(id)sender {
    if ([kUserDefaults boolForKey:isJumpOverGuide]) {
        NSString * urlString = @"App-Prefs:root=WIFI";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            if (iOS10) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            }
        }
    }else{
        WIFIGuideViewController *wifiGuideVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"WIFIGuideViewController"];
        
        [self presentViewController:wifiGuideVC animated:YES completion:nil];
    }
}

- (NSString *)GetWifiName{
    
    NSString *wifiName = @"";
    
    CFArrayRef myArray = CNCopySupportedInterfaces();
    
    if (myArray != nil) {
        
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        
        if (myDict != nil) {
            
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            wifiName = [dict valueForKey:@"SSID"];
            
        }
        
    }
    
    return wifiName;
}

-(double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
