//
//  ParkHomeViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ParkHomeViewController.h"
#import "ParkIngCell.h"
#import "ParkCountCell.h"
#import "ParkAreasModel.h"
#import "AptDetailViewController.h"
#import "ParkReservaViewController.h"

#import "BindTableViewController.h"

#import "CarListModel.h"
#import "ParkPhotoModel.h"
#import "ParkInfoModel.h"
#import "CarRecordModel.h"
#import "Utils.h"
#import "TopScrollView.h"
#import "BookRecordModel.h"
#import "ReservationRemindViewController.h"
#import "BookRecordParkAreaModel.h"

@interface ParkHomeViewController ()<UITableViewDelegate, UITableViewDataSource, NavToParkDelegate,ParkIngDelegate>
{
    UITableView *_parkTableView;
    
    NSMutableArray *_photoData;
    NSMutableArray *_parkingData;
    
    NSMutableArray *_surplusData;
    
    ParkInfoModel *_parkInfoModel;
    
    NSMutableArray *_bindCars;
    
    BOOL _isReload;
    
    NSInteger _sectionRows;
    
    NSString *isHidden;
    NSString *_currentTime;
}

@end

@implementation ParkHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    [kNotificationCenter addObserver:self selector:@selector(refreshBindCarData:) name:@"refreshBindCarData" object:nil];
    
    _sectionRows = 1;
    
    _photoData = @[].mutableCopy;
    _parkingData = @[].mutableCopy;
    _surplusData = @[].mutableCopy;
    _bindCars = @[].mutableCopy;
    
    [self _initView];
    
    [self _loadRecordData];
}

-(void)refreshBindCarData:(NSNotification *)notification
{
    [self _loadRecordData];
}

- (void)_initView {
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _parkTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
    _parkTableView.delegate = self;
    _parkTableView.dataSource = self;
    _parkTableView.separatorColor = [UIColor clearColor];
    
    _parkTableView.tableFooterView = [UITableView new];
    [self.view addSubview:_parkTableView];
    
    [_parkTableView registerNib:[UINib nibWithNibName:@"ParkIngCell" bundle:nil] forCellReuseIdentifier:@"ParkIngCell"];
    [_parkTableView registerNib:[UINib nibWithNibName:@"ParkCountCell" bundle:nil] forCellReuseIdentifier:@"ParkCountCell"];
    
     // 预约停车
    UIButton *aptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aptButton.frame = CGRectMake(0, KScreenHeight - 60 - 64, KScreenWidth, 60);
    aptButton.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    [aptButton setTitle:@"预约停车" forState:UIControlStateNormal];
    [aptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aptButton addTarget:self action:@selector(aptAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:aptButton];
    
}
- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)aptAction {
    [self showHint:@"敬请期待"];
    /*
    ParkReservaViewController *parkResercaVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ParkReservaViewController"];
    [self.navigationController pushViewController:parkResercaVC animated:YES];
     */
}

#pragma mark 未出场停车记录
- (void)_loadRecordData {
    [self showHudInView:self.view hint:@"加载中~"];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
        [self _loadParkData];
        return;
    }
    
    // 先查询已绑定车辆
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/member/getMemberCards",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            NSArray *carList = responseObject[@"data"][@"carList"];
            [_bindCars removeAllObjects];
            [carList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CarListModel *carModel = [[CarListModel alloc] initWithDataDic:obj];
                [_bindCars addObject:carModel];
            }];
         
            // 请求已有记录车牌
            [self loadRecordBindCars];
        }else{
            [self hideHud];
            [self showHint:@"加载失败,请重试!"];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"加载失败,请重试!"];
        }
    }];
}

- (void)loadRecordBindCars {
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/trace/getMemberTraceList",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    [params setValue:[NSNumber numberWithInt:0] forKey:@"start"];
    [params setValue:[NSNumber numberWithInt:20] forKey:@"length"];
    [params setObject:@"90" forKey:@"traceResult"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        
        if([responseObject[@"success"] boolValue]){
            NSArray *carRecord = responseObject[@"data"][@"data"];
            [_parkingData removeAllObjects];
            
            [_bindCars enumerateObjectsUsingBlock:^(CarListModel *carModel, NSUInteger idx, BOOL * _Nonnull stop) {
                __block BOOL isInclude = NO;
                [carRecord enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CarRecordModel *carRecordModel = [[CarRecordModel alloc] initWithDataDic:obj];
                    if([carModel.carNo isEqualToString:carRecordModel.traceCarno]){
                        [_parkingData addObject:carRecordModel];
                        isInclude = YES;
                    }
                }];
                if(!isInclude){
                    CarRecordModel *carRecordModel = [[CarRecordModel alloc] init];
                    carRecordModel.traceCarno = carModel.carNo;
                    carRecordModel.traceParkname = @"";
                    [_parkingData addObject:carRecordModel];
                }
            }];
        }else{
            [self hideHud];
            [self showHint:@"请重试!"];
        }
        _sectionRows = 2;
        if (_parkingData == nil||_parkingData.count == 0) {
            isHidden = @"0";
        }else{
            isHidden = @"1";
        }
        
        [self loadBookingCarData];
        
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"请重试!"];
    }];
}

-(void)loadBookingCarData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/getCustReservationOrder",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"custId"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            if (![responseObject[@"responseData"] isKindOfClass:[NSNull class]]&&responseObject[@"responseData"] != nil) {
                NSDictionary *dic = responseObject[@"responseData"];
                _currentTime = dic[@"cunrentTime"];
                NSArray *arr = dic[@"items"];
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *objDic = obj;
                    if (![objDic[@"order"] isKindOfClass:[NSNull class]]&&objDic[@"order"] != nil) {
                        NSDictionary *orderDic = objDic[@"order"];
                        NSDictionary *parkAreaDic = orderDic[@"parkingArea"];
                        [_parkingData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            CarRecordModel *carModel = (CarRecordModel *)obj;
                            BookRecordModel *orderModel = [[BookRecordModel alloc] initWithDataDic:orderDic];
                            BookRecordParkAreaModel *parkAreaModel = [[BookRecordParkAreaModel alloc] initWithDataDic:parkAreaDic];
                            if ([orderModel.status isEqualToString:@"0"]) {
                                if ([carModel.traceCarno isEqualToString:orderModel.carNo]) {
                                    carModel.isBooking = @"1";
                                    carModel.orderModel = orderModel;
                                    carModel.parkAreaModel = parkAreaModel;
                                }
                            }
                        }];
                    }else{
                        [_parkingData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            CarRecordModel *carModel = (CarRecordModel *)obj;
                            carModel.isBooking = @"0";
                        }];
                    }
                }];
            }else{
                [_parkingData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CarRecordModel *carModel = (CarRecordModel *)obj;
                    carModel.isBooking = @"0";
                }];
            }
        }else{
            [_parkingData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CarRecordModel *carModel = (CarRecordModel *)obj;
                carModel.isBooking = @"0";
            }];
        }
        [self _loadParkData];
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"请重试!"];
    }];
}

#pragma mark 加载停车场信息
-(void)_loadParkData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/park/detail",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KParkId forKey:@"parkId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
         [_surplusData removeAllObjects];
         if([responseObject[@"success"] boolValue]) {
             NSDictionary *dic = responseObject[@"data"];
             
             // 顶部图片
             NSArray *parkImgs = dic[@"photo"];
             [_photoData removeAllObjects];
             [parkImgs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 ParkPhotoModel *photoModel = [[ParkPhotoModel alloc] initWithDataDic:obj];
                 [_photoData addObject:photoModel];
             }];
             
             // 经纬度
             _parkInfoModel = [[ParkInfoModel alloc] initWithDataDic:dic[@"park"]];
             
             // 停车场
             NSArray *parkAreasArr = dic[@"parkAreas"];
             [_surplusData removeAllObjects];
             [parkAreasArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 ParkAreasModel *model = [[ParkAreasModel alloc] initWithDataDic:obj];
                 [_surplusData addObject:model];
             }];
         }else{
             [self showHint:@"请重试!"];
         }
        
        [_parkTableView reloadData];
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"请重试!"];
    }];
}

#pragma mark UItableView 协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return _sectionRows;
    }
    return _surplusData.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section != 0){
        return 5;
    }else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if(indexPath.row == 0){
                return 200*hScale;
            }else {
                return 131;
            }
            break;
            
        case 1:
            return 105;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopDefaultCell"];
        
        TopScrollView *topScrView = [[TopScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200*hScale)];
        topScrView.backgroundColor = [UIColor orangeColor];
        topScrView.imgData = _photoData;
        [cell.contentView addSubview:topScrView];
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        ParkIngCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkIngCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.isHidden = isHidden;
        cell.currentTime = _currentTime;
        cell.carLists = _parkingData;
        return cell;
    }else {
        ParkCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkCountCell" forIndexPath:indexPath];
        cell.model = _surplusData[indexPath.row];
        cell.navDelegate = self;
        return cell;
    }
}

#pragma mark 导航
- (void)navPark:(CGFloat)latitude withLongitude:(CGFloat)longitude {
    
    // 模拟本地经纬度
//    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(28.147481, 113.065363);
    
//    CLLocationCoordinate2D endCoord = CLLocationCoordinate2DMake(latitude, longitude);
    // 导航停车场经纬度 指向一个
    CLLocationCoordinate2D endCoord = CLLocationCoordinate2DMake(_parkInfoModel.parkLat.floatValue/1000000, _parkInfoModel.parkLng.floatValue/1000000);
    
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
        navAlert.popoverPresentationController.sourceRect = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight);//可选，我这里加这句代码是为了调整到合适的位置
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

#pragma mark ParkIngDelegate
-(void)navToParkSpace:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.superview.tag;
    [self navToPark:_parkingData[index-100]];
}

-(void)unlockParkSpace:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.superview.tag;
    [self unlock:_parkingData[index-100]];
}

-(void)cancleBookParkSpace:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.superview.tag;
    [self cancleBook:_parkingData[index-100]];
}

-(void)unlock:(CarRecordModel *)model{
    NSString *orderId = model.orderModel.orderId;
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
        [self _loadRecordData];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            ReservationRemindViewController *reservationRemindVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationRemindViewController"];
            reservationRemindVC.orderId = model.orderModel.orderId;
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

-(void)cancleBook:(CarRecordModel *)model{
    NSString *orderId = model.orderModel.orderId;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/cancelOrder",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderId forKey:@"orderId"];
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self _loadRecordData];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            
            ReservationRemindViewController *reservationRemindVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationRemindViewController"];
            reservationRemindVC.orderId = model.orderModel.orderId;
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

-(void)navToPark:(CarRecordModel *)model{
    CarRecordModel *_model = model;
    [self navPark:[_model.parkAreaModel.latitude floatValue] withLongitude:[_model.parkAreaModel.longitude floatValue]];
}


-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"refreshBindCarData" object:nil];
}

@end
