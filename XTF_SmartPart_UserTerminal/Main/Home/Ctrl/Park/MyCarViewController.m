//
//  MyCarViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "MyCarViewController.h"
#import "MyCarTableViewCell.h"
#import "YQEmptyView.h"
#import "BindCarTableViewController.h"
#import "CarListModel.h"
#import "BookRecordModel.h"
#import "BookRecordParkAreaModel.h"
#import "BookRecordParkSpaceModel.h"
#import "Utils.h"

#import "CarRecordModel.h"
#import "FindCarViewController.h"

@interface MyCarViewController ()<UITableViewDataSource,UITableViewDelegate, RemoveBindCarDelegate, BindCarSuccessDelegate>
{
    NSMutableArray *_carData;
    BookRecordModel *model;
    CarListModel *_carListModel;
    NSMutableArray *_parkingData;
}

//新增绑定
@property (nonatomic,strong) UIButton *bindBtn;

@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation MyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _carData = @[].mutableCopy;
    _parkingData = @[].mutableCopy;
    
    [self _initView];
    
    [self _initNavItems];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self _loadBindCarData];

}

-(void)_initView
{
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCarTableViewCell"];
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight-60-17);
    }else{
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight-60);
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
}

-(void)_initNavItems
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.title = @"我的车辆";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _bindBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), KScreenWidth, 60)];
    [_bindBtn addTarget:self action:@selector(bindBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bindBtn setTitle:@"新增绑定" forState:UIControlStateNormal];
    [_bindBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [_bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bindBtn setBackgroundColor:[UIColor colorWithHexString:@"#1B82D1"]];
    [self.view addSubview:_bindBtn];
}

#pragma mark 请求绑定车辆信息
- (void)_loadBindCarData {
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/member/getMemberCards",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            [_carData removeAllObjects];
            NSArray *carList = responseObject[@"data"][@"carList"];
            if ([carList isKindOfClass:[NSNull class]]||carList.count == 0||carList == nil) {
                [kUserDefaults setObject:@"0" forKey:isBindCar];
                self.tableView.ly_emptyView = self.noDataView;
                [self.tableView reloadData];
                [self.tableView ly_endLoading];
                return;
            }else{
                [kUserDefaults setObject:@"1" forKey:isBindCar];
            }
            [carList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CarListModel *carModel = [[CarListModel alloc] initWithDataDic:obj];
                [_carData addObject:carModel];
            }];
            
            [self loadRecordBindCars];
        }else{
            [self.tableView.mj_header endRefreshing];
            self.tableView.ly_emptyView = self.noDataView;
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            self.tableView.ly_emptyView = self.noNetworkView;
        }else{
            self.tableView.ly_emptyView = self.noDataView;
        }
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
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
        [self.tableView.mj_header endRefreshing];
        if([responseObject[@"success"] boolValue]){
            NSArray *carRecord = responseObject[@"data"][@"data"];
            [_parkingData removeAllObjects];
            
            [_carData enumerateObjectsUsingBlock:^(CarListModel *carModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [carRecord enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CarRecordModel *carRecordModel = [[CarRecordModel alloc] initWithDataDic:obj];
                    if([carModel.carNo isEqualToString:carRecordModel.traceCarno]){
                        carModel.state = @"1";
                        if ([carRecordModel.traceArea isEqualToString:@"8a04a41f56bc33a20156bc3726df0006"]) {
                            carModel.carParkArea = @"前坪停车场";
                        }else if ([carRecordModel.traceArea isEqualToString:@"8a04a41f56c0c3f90157277802150065"]){
                            carModel.carParkArea = @"地下停车场";
                        }else if ([carRecordModel.traceArea isEqualToString:@"8a04a41f56c0c3f9015727785c4c0067"]){
                            carModel.carParkArea = @"南坪停车场";
                        }else if ([carRecordModel.traceArea isEqualToString:@"8a04a41f588f6f860158903d97e40003"]){
                            carModel.carParkArea = @"天园假日小区";
                        }else{
                            carModel.carParkArea = @"未知区域";
                        }
                    }
                }];
            }];
        }else{
            [self hideHud];
            [self showHint:@"请重试!"];
        }
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self hideHud];
        [self showHint:@"请重试!"];
    }];
}

-(void)headerRereshing {
    [self _loadBindCarData];
}

- (YQEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [YQEmptyView diyEmptyView];
    }
    return _noDataView;
}

- (YQEmptyView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [YQEmptyView diyEmptyActionViewWithTarget:self action:@selector(headerRereshing)];
    }
    return _noNetworkView;
}


#pragma mark 新增绑定车辆
-(void)bindBtnAction
{
    BindCarTableViewController *bindCarVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BindCarTableViewController"];
    bindCarVC.bindSucDelegate = self;
    [self.navigationController pushViewController:bindCarVC animated:YES];
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableview delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _carData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCarTableViewCell" forIndexPath:indexPath];
    cell.carListModel = _carData[indexPath.row];
    cell.removeBindDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

#pragma mark 解除绑定
- (void)removeBind:(CarListModel *)carListModel {
    _carListModel = carListModel;
    NSString *msg = [NSString stringWithFormat:@"是否解除绑定 %@", carListModel.carNo];
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *remove = [UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self cheakIsBookParkArea:carListModel];
        
    }];
    [alertCon addAction:cancel];
    [alertCon addAction:remove];
    [self presentViewController:alertCon animated:YES completion:nil];
}

#pragma mark 检查是否已经预定车位
-(void)cheakIsBookParkArea:(CarListModel *)carListModel
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/getCustReservationOrder",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"custId"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
//    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
//        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *arr = dic[@"items"];
            __block BOOL isRrser = NO;
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dataDic = obj;
                BookRecordModel *_orderModel = [[BookRecordModel alloc] initWithDataDic:dataDic[@"order"]];
                BookRecordParkAreaModel *_parkAreaModel = [[BookRecordParkAreaModel alloc] initWithDataDic:dataDic[@"parkingArea"]];
                BookRecordParkSpaceModel *_parkSpaceModel = [[BookRecordParkSpaceModel alloc] initWithDataDic:dataDic[@"parkingSpace"]];
                if ([carListModel.carNo isEqualToString:_orderModel.carNo]) {
                    model = _orderModel;
                    isRrser = YES;
                    *stop = YES;
                }
            }];
            
            if (isRrser) {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"解绑失败,该车牌已预约车位！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [view show];
                return;
            }else{
                [self cancleBindCar:carListModel];
            }
        }else{
            [self cancleBindCar:carListModel];
        }
    } failure:^(NSError *error) {
//        [self hideHud];
        [self showHint:@"请重试!"];
    }];
}

-(void)cancleBindCar:(CarListModel *)carListModel
{
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/member/deleteCar",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    [params setObject:carListModel.carNo forKey:@"carNo"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"success"] boolValue]){
            // 解除绑定成功
            NSInteger index = [_carData indexOfObject:carListModel];
            [_carData removeObjectAtIndex:index];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
            [self showHint:@"解绑成功"];
        }else {
            [self showHint:@"解绑失败"];
        }
        
        [self _loadBindCarData];
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self cancleParkReservation];
    }
}

-(void)cancleParkReservation
{
    NSString *orderId = model.orderId;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/cancelOrder",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderId forKey:@"orderId"];
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [self showHudInView:kAppWindow hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            [self cancleBindCar:_carListModel];
        }else{
            [self showHint:@"取消预约失败,解绑失败!"];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"取消预约失败,解绑失败!"];
    }];
}

#pragma mark 绑定成功协议
- (void)bindCarSuc {
    [self _loadBindCarData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarListModel *carListModel = _carData[indexPath.row];
    FindCarViewController *findcarVC = [[FindCarViewController alloc] init];
    findcarVC.title = @"反向寻车";
    findcarVC.source = @"1";
    findcarVC.carNo = carListModel.carNo;
    [self.navigationController pushViewController:findcarVC animated:YES];
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
