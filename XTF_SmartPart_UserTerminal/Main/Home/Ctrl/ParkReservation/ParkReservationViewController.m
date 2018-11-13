//
//  ParkReservationViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/5.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ParkReservationViewController.h"
#import "BookDetailsViewController.h"
#import "ParkReservationTableViewCell.h"
#import "ParkReservationAreaCell.h"
#import "ParkReservationFooterView.h"
#import "BookRecordViewController.h"
#import "Utils.h"
#import "CarParkModel.h"
#import "CarListModel.h"
#import "BookRecordModel.h"
#import "BookRecordParkAreaModel.h"
#import "BookRecordParkSpaceModel.h"
#import "YQEmptyView.h"
#import "ParkAreaStatusModel.h"
#import "ParkCarNumTabCell.h"

@interface ParkReservationViewController ()<UITableViewDataSource,UITableViewDelegate,selectCarNumDelegate,selectParkAreaDelegate,selectNumDelegate>
{
    __weak IBOutlet UIButton *commitReservationBtn;
    NSMutableArray *bindCarDataArr;
    NSString *_selectCarNum;//当前选中的车牌
    CarParkModel *_selectCarParkModel;
    NSMutableArray *_numArr;
    BOOL _isOpen;
    NSMutableArray *bindCarArr;
    NSInteger _selectIndex;
}

@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@property (nonatomic,retain) NSMutableArray *dataArr;

@end

@implementation ParkReservationViewController

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isOpen = NO;
    _numArr = @[].mutableCopy;
    
    [kNotificationCenter addObserver:self selector:@selector(reservationNoVaalibleBtnStatus) name:@"reservationNoAvalibleNotification" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(reservationBtnStatus) name:@"reservationAvalibleNotification" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    commitReservationBtn.hidden = YES;
    
    bindCarDataArr = @[].mutableCopy;
    bindCarArr = @[].mutableCopy;
    
    [self initNavItems];
    
    [self initTableView];
    
    [self loadData];
}

-(void)reservationBtnStatus{
    commitReservationBtn.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    commitReservationBtn.userInteractionEnabled = YES;
}

-(void)reservationNoVaalibleBtnStatus
{
    commitReservationBtn.backgroundColor = [UIColor colorWithHexString:@"#b7b7b7"];
    commitReservationBtn.userInteractionEnabled = NO;
}

-(void)initNavItems
{
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
    [rightBtn setImage:[UIImage imageNamed:@"slideMenu"] forState:UIControlStateNormal];    // switchmap
    [rightBtn addTarget:self action:@selector(_rightBarBtnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)_leftBarBtnItemClick {
    if (_isSholudBackRootViewController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)_rightBarBtnItemClick:(id)sender
{
    BookRecordViewController *bookRecordVC = [[BookRecordViewController alloc] init];
    bookRecordVC.title = @"预约记录";
    [self.navigationController pushViewController:bookRecordVC animated:YES];
}

- (YQEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [YQEmptyView msgDiyEmptyView];
    }
    return _noDataView;
}

- (YQEmptyView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [YQEmptyView diyEmptyActionViewWithTarget:self action:@selector(loadData)];
    }
    return _noNetworkView;
}

-(void)setIsSholudBackRootViewController:(BOOL)isSholudBackRootViewController
{
    _isSholudBackRootViewController = isSholudBackRootViewController;
}

-(void)loadData{
    //加载绑定车辆信息
    [self loadBindCarData];
}

-(void)loadBindCarData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/member/getMemberCards",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [bindCarDataArr removeAllObjects];
        [_numArr removeAllObjects];
        if([responseObject[@"success"] boolValue]){
            NSArray *carList = responseObject[@"data"][@"carList"];
            [carList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CarListModel *carModel = [[CarListModel alloc] initWithDataDic:obj];
                [bindCarDataArr addObject:[NSString stringWithFormat:@"%@ %@",carModel.carArea,carModel.carNum]];
                [bindCarArr addObject:carModel];
            }];
            
            CarListModel *model = bindCarArr[0];
            _selectCarNum = model.carNo;
            _selectIndex = 0;
            
            [self loadParkAreaData];
        }else{
            [self hideHud];
            [self showHint:@"加载失败,请重试!"];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"加载失败,请重试!"];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            self.tableView.ly_emptyView = self.noNetworkView;
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }else{
            self.tableView.ly_emptyView = self.noDataView;
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }
    }];
}

-(void)loadParkAreaData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/getParkingAreas",MainUrl];
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    [params setObject:@"湘AZ0168" forKey:@"carNo"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            [_numArr addObject:@"1"];
            [_numArr addObject:@"1"];
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *arr1 = dic[@"items"];
            if ([arr1 isKindOfClass:[NSNull class]]||arr1.count == 0) {
                self.tableView.ly_emptyView = self.noDataView;
                [self.tableView reloadData];
                [self.tableView ly_endLoading];
                return;
            }
            
            [arr1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CarParkModel *model = [[CarParkModel alloc] initWithDataDic:obj];
                [self.dataArr addObject:model];
            }];
            
            _selectCarParkModel = self.dataArr[0];
            
            self.tableView.hidden = NO;
            commitReservationBtn.hidden = NO;
            [self.tableView reloadData];
        }else{
            self.tableView.ly_emptyView = self.noDataView;
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"加载失败,请重试!"];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            self.tableView.ly_emptyView = self.noNetworkView;
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }else{
            self.tableView.ly_emptyView = self.noDataView;
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }
    }];
}

-(void)initTableView
{
    self.tableView.hidden = YES;
    // 禁止左滑
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkReservationTableViewCell" bundle:nil] forCellReuseIdentifier:@"ParkReservationTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkReservationAreaCell" bundle:nil] forCellReuseIdentifier:@"ParkReservationAreaCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkCarNumTabCell" bundle:nil] forCellReuseIdentifier:@"ParkCarNumTabCell"];
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight-60-33);
    }else{
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight-60);
    }
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [self.view addSubview:self.tableView];
}

#pragma mark 提交预约

- (IBAction)commitReservationAction:(id)sender {
    
    CarListModel *model = bindCarArr[_selectIndex];
    if (![model.carType isEqualToString:@"0"]) {
        [self showHint:@"该车型不是小型车,不可进行预约!"];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/orderParkingSpace",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"custId"];
    [params setObject:_selectCarNum forKey:@"carNo"];
    [params setObject:_selectCarParkModel.parkingAreaId forKey:@"parkingAreaId"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            if (![responseObject[@"responseData"] isKindOfClass:[NSNull class]]&&responseObject[@"responseData"] != nil) {
                NSDictionary *dic = responseObject[@"responseData"];
                BookDetailsViewController *bookDetailVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BookDetailsViewController"];
                bookDetailVC.orderModel = [[BookRecordModel alloc] initWithDataDic:dic[@"order"]];
                bookDetailVC.parkAreaModel = [[BookRecordParkAreaModel alloc] initWithDataDic:dic[@"parkingArea"]];
                bookDetailVC.parkSpaceModel = [[BookRecordParkSpaceModel alloc] initWithDataDic:dic[@"parkingSpace"]];
                bookDetailVC.currentTime = dic[@"cunrentTime"];
                [self.navigationController pushViewController:bookDetailVC animated:YES];
            }else{
                [self showHint:@"获取预约信息失败!"];
            }
        }else{
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                [self showHint:responseObject[@"message"]];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _numArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *_cell;
    if (indexPath.row == 0) {
        //        ParkReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkReservationTableViewCell"];
        //        cell.delegate = self;
        //        cell.selectIndex = _selectIndex;
        //        cell.isOverNeedHide = _isOpen;
        //        cell.dataArr = bindCarArr;
        ParkCarNumTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkCarNumTabCell"];
        cell.dataArr = bindCarArr;
        cell.parkAreaArr = self.dataArr;
        cell.delegate = self;
        _cell = cell;
    }else{
        ParkReservationAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkReservationAreaCell"];
        cell.delegate = self;
        cell.dataArr = self.dataArr;
        _cell = cell;
    }
    return _cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.row == 0) {
        //        if (bindCarDataArr.count <= 3) {
        //            height = 84.5 + 40*bindCarDataArr.count + 12.5*(bindCarDataArr.count-1);
        //        }else{
        //            if (_isOpen) {
        //                height = 84.5 + 40*bindCarDataArr.count + 12.5*(bindCarDataArr.count-1)+20;
        //            }else{
        //                height = 84.5 + 120 + 25+20;
        //            }
        //        }
        height = 240+120*wScale;
    }else{
        //        if (self.dataArr.count <= 3) {
        //            height = 132+23.5 + 50.5*self.dataArr.count+27+25+90*wScale;
        //        }else{
        //            if (_isOpen) {
        //                height = 132+23.5 + 50.5*self.dataArr.count+27+25+90*wScale;
        //            }else{
        //                height = 23.5 + 151.5+132+27+25+90*wScale;
        //            }
        //        }
        height = 145;
    }
    
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [kNotificationCenter postNotificationName:@"hidePickerNotification" object:nil];
}

#pragma mark 选择车牌代理
-(void)selectCarNum:(NSString *)carNum withIndex:(NSInteger)index
{
    _selectCarNum = carNum;
    _selectIndex = index;
}

#pragma mark 选择预定区域
-(void)selectParkArea:(CarParkModel *)model
{
    _selectCarParkModel = model;
}

#pragma mark 展开或者收起cell
-(void)unfoldOrCloseCell:(NSString *)isOpen
{
    if ([isOpen isEqualToString:@"1"]) {
        _isOpen = NO;
    }else{
        _isOpen = YES;
    }
    [self.tableView reloadData];
}

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"reservationNoAvalibleNotification" object:nil];
    [kNotificationCenter removeObserver:self name:@"reservationAvalibleNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
