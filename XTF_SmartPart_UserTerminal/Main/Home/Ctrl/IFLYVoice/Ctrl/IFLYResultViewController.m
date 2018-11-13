//
//  IFLYResultViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/6.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "IFLYResultViewController.h"
#import "IFLYResultTableViewCell.h"
#import "ParkHomeViewController.h"
#import "ScanViewController.h"
#import "AccessListViewController.h"
#import "WeatherDetailController.h"
#import "KqTabbarViewController.h"
#import "ParkReservationViewController.h"
#import "BookDetailsViewController.h"
#import "BookRecordDetailController.h"
#import "BookRecordModel.h"
#import "BookRecordParkAreaModel.h"
#import "BookRecordParkSpaceModel.h"
#import "CarListModel.h"
#import "BindCarTableViewController.h"
#import "FoodViewController.h"
#import "FindCarViewController.h"
#import "QuickRechargeViewController.h"
#import "Utils.h"
#import "ParkRecordsViewController.h"
#import "MyCarViewController.h"
#import "ParkRecordsViewController.h"
#import "BindTableViewController.h"

@interface IFLYResultViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat headerHeight;
    NSMutableArray *placeHolderArr;
    NSMutableArray *bindCarDataArr;
}

@end

@implementation IFLYResultViewController

- (void)viewDidLoad {
    [self _initNavItems];
    
    [self initView];
    
    [self.tableView reloadData];
}

-(void)initPlaceHolderData
{
//    @{@"MENU_NAME": @"天气",@"MENU_ICON": @"home_sign",@"MENU_ID":@4},
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@{@"MENU_NAME": @"智能停车",@"MENU_ICON": @"ifly_park",@"MENU_ID":@1},@{@"MENU_NAME": @"扫一扫",@"MENU_ICON": @"ifly_scan",@"MENU_ID":@2},@{@"MENU_NAME": @"智能开门",@"MENU_ICON": @"ifly_opendoor",@"MENU_ID":@3},@{@"MENU_NAME": @"天气",@"MENU_ICON": @"ifly_weather",@"MENU_ID":@4},@{@"MENU_NAME": @"员工考勤",@"MENU_ICON": @"home_sign",@"MENU_ID":@5},@{@"MENU_NAME": @"车位预约",@"MENU_ICON": @"car_seat",@"MENU_ID":@6},@{@"MENU_NAME": @"今日菜谱",@"MENU_ICON": @"home_food",@"MENU_ID":@7},@{@"MENU_NAME": @"反向寻车",@"MENU_ICON": @"home_searchcar",@"MENU_ID":@8},@{@"MENU_NAME": @"一卡通充值",@"MENU_ICON": @"home_rechage",@"MENU_ID":@9},@{@"MENU_NAME": @"停车记录",@"MENU_ICON": @"mine_park_all",@"MENU_ID":@10},@{@"MENU_NAME": @"我的车辆",@"MENU_ICON": @"mine_car",@"MENU_ID":@11}, nil];
    
    placeHolderArr = [NSMutableArray array];
    [placeHolderArr removeAllObjects];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        [placeHolderArr addObject:[[FirstMenuModel alloc] initWithDataDic:dic]];
    }];
}

-(void)_initNavItems
{
    self.title = @"搜索结果";
    
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

-(void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"IFLYResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"IFLYResultTableViewCell"];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
}

#pragma mark tableview delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IFLYResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IFLYResultTableViewCell" forIndexPath:indexPath];
//    cell.matchStr = _matchArr[indexPath.row];
    cell.matchStr = _matchStr;
    cell.model = _dataArr[indexPath.row];
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
    return headerHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 102)];
    headerBgView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerBgView addSubview:headerView];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, 20, 20)];
    titleView.image = [UIImage imageNamed:@"ifly_result_remind"];
    [headerView addSubview:titleView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(titleView.right+6.5, 20, 200, 20)];
    lab.text = @"暂时没有找到相关内容";
    lab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
    lab.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:lab];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.bottom+20, KScreenWidth/3-25, 0.5)];
    leftView.backgroundColor = [UIColor colorWithHexString:@"#BFBFBF"];
    [headerBgView addSubview:leftView];
    
    UILabel *centerLab = [[UILabel alloc] initWithFrame:CGRectMake(leftView.right, headerView.bottom, KScreenWidth/3+50, 42)];
    centerLab.text = @"你可能感兴趣的内容";
    centerLab.textColor = [UIColor colorWithHexString:@"#A2A2A2"];
    centerLab.textAlignment = NSTextAlignmentCenter;
    [headerBgView addSubview:centerLab];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(centerLab.right, headerView.bottom+20, KScreenWidth/3-25, 0.5)];
    rightView.backgroundColor = [UIColor colorWithHexString:@"#BFBFBF"];
    [headerBgView addSubview:rightView];
    
    return headerBgView;
}

-(void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    if (_dataArr == nil||dataArr.count == 0) {
        headerHeight = 102;
        [self initPlaceHolderData];
        
        NSMutableArray* Valuearr=[NSMutableArray new];
        int counN=5;
        for(int i=0;i<counN;i++)  //创建出5条
        {
            int value = arc4random() % 10;
            for(int j=0;j<Valuearr.count;j++)
            {
                NSString* s=Valuearr[j]; //获取到s
                while([s intValue]==value) //判断2个是不是相等如果是的话 直到不相等 如果碰到
                {
                    value = arc4random() % 10;//重写给随机数重新赋值
                    j=-1;//重新判断  因为后面有个 i++ 所以把他赋值给-1 然后就成了0然后重0开始判断
                }
            }
            [Valuearr addObject:[NSString stringWithFormat:@"%d",value]];
        }
        
        [Valuearr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = [obj integerValue];
            [_dataArr addObject:placeHolderArr[index]];
        }];
    }else{
        headerHeight = 0;
    }
    [self.tableView reloadData];
}

//-(void)setMatchArr:(NSMutableArray *)matchArr
//{
//    _matchArr = matchArr;
//    [matchArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@",obj);
//    }];
//}

-(void)setMatchStr:(NSString *)matchStr
{
    _matchStr = matchStr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FirstMenuModel *model = _dataArr[indexPath.row];
    NSInteger menuid = model.MENU_ID.integerValue;
    switch (menuid) {
        case 1:
        {
            ParkHomeViewController *parkVC = [[ParkHomeViewController alloc] init];
            parkVC.hidesBottomBarWhenPushed = YES;
            parkVC.title = model.MENU_NAME;
            [self.navigationController pushViewController:parkVC animated:YES];
        }
            break;
        case 2:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                ScanViewController *scanVC = [[ScanViewController alloc] init];
                scanVC.title = model.MENU_NAME;
                [self.navigationController pushViewController:scanVC animated:YES];
            }else {
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
                    bindVC.type = @"1";
                }else{
                    bindVC.type = @"0";
                }
                bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
                bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
                [self.navigationController pushViewController:bindVC animated:YES];
            }
        }
            break;
        case 3:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                AccessListViewController *accessCtrlVC = [[AccessListViewController alloc] init];
                accessCtrlVC.titleStr = model.MENU_NAME;
                [self.navigationController pushViewController:accessCtrlVC animated:YES];
            }else{
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
                    bindVC.type = @"1";
                }else{
                    bindVC.type = @"0";
                }
                bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
                bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
                [self.navigationController pushViewController:bindVC animated:YES];
            }
        }
            break;
        case 4:
        {
            WeatherDetailController *weaDetailVC = [[WeatherDetailController alloc] init];
            [self.navigationController pushViewController:weaDetailVC animated:YES];
        }
            break;
        case 5:
        {
            // 考勤
            if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]) {
                KqTabbarViewController *kqtabbarVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"KqTabbarViewController"];
                kqtabbarVC.selectedIndex = 0;
                kqtabbarVC.titleStr = model.MENU_NAME;
                [self.navigationController pushViewController:kqtabbarVC animated:YES];
            }else
            {
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
                    bindVC.type = @"1";
                }else{
                    bindVC.type = @"0";
                }
                bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
                bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
                [self.navigationController pushViewController:bindVC animated:YES];
            }
        }
            break;
        case 6:
        {
            [self loadBindCarData];
        }
            break;
        case 7:
        {
            // 菜谱
            FoodViewController *foodVC = [[FoodViewController alloc] init];
            foodVC.titleStr = model.MENU_NAME;
            [self.navigationController pushViewController:foodVC animated:YES];
        }
            break;
        case 8:
        {
            // 寻车
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                [self.navigationController pushViewController:bindVC animated:YES];
            }else {
                FindCarViewController *findcarVC = [[FindCarViewController alloc] init];
                findcarVC.title = model.MENU_NAME;
                [self.navigationController pushViewController:findcarVC animated:YES];
            }
        }
            break;
        case 9:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                QuickRechargeViewController *quickRechageVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"QuickRechargeViewController"];
                quickRechageVC.titleStr = model.MENU_NAME;
                [self.navigationController pushViewController:quickRechageVC animated:YES];
            }else{
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
                    bindVC.type = @"1";
                }else{
                    bindVC.type = @"0";
                }
                bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
                bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
                [self.navigationController pushViewController:bindVC animated:YES];
            }
        }
            break;
        case 10:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                [self.navigationController pushViewController:bindVC animated:YES];
            }else {
                ParkRecordsViewController *parkReVc = [[ParkRecordsViewController alloc] init];
                [self.navigationController pushViewController:parkReVc animated:YES];
            }
            break;
        }
        case 11:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                [self.navigationController pushViewController:bindVC animated:YES];
            }else {
                MyCarViewController *myCarVC = [[MyCarViewController alloc] init];
                [self.navigationController pushViewController:myCarVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 检查是否已经预定车位
-(void)cheakIsBookParkArea
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/getCustReservationOrder",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"custId"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *arr = dic[@"items"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dataDic = obj;
                BookRecordModel *_orderModel = [[BookRecordModel alloc] initWithDataDic:dataDic[@"order"]];
                BookRecordParkAreaModel *_parkAreaModel = [[BookRecordParkAreaModel alloc] initWithDataDic:dataDic[@"parkingArea"]];
                BookRecordParkSpaceModel *_parkSpaceModel = [[BookRecordParkSpaceModel alloc] initWithDataDic:dataDic[@"parkingSpace"]];
                if ([_orderModel.status isEqualToString:@"1"]) {
                    BookRecordDetailController *bookRecordDetailVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BookRecordDetailController"];
                    bookRecordDetailVC.orderId = _orderModel.orderId;
                    [self.navigationController pushViewController:bookRecordDetailVC animated:YES];
                }else{
                    BookDetailsViewController *bookDetailVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BookDetailsViewController"];
                    bookDetailVC.orderModel = _orderModel;
                    bookDetailVC.parkAreaModel = _parkAreaModel;
                    bookDetailVC.parkSpaceModel = _parkSpaceModel;
                    bookDetailVC.currentTime = dic[@"cunrentTime"];
                    [self.navigationController pushViewController:bookDetailVC animated:YES];
                }
            }];
            
        }else{
            ParkReservationViewController *parkReserVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ParkReservationViewController"];
            parkReserVC.title = @"车位预约";
            [self.navigationController pushViewController:parkReserVC animated:YES];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"请重试!"];
    }];
}

#pragma mark 是否绑定车辆
-(void)loadBindCarData
{
    [self showHudInView:self.view hint:nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/member/getMemberCards",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"success"] boolValue]){
            
            NSArray *carList = responseObject[@"data"][@"carList"];
            [carList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CarListModel *carModel = [[CarListModel alloc] initWithDataDic:obj];
                [bindCarDataArr addObject:[NSString stringWithFormat:@"%@ %@",carModel.carArea,carModel.carNum]];
            }];
            
            if (carList.count ==1) {
                [self cheakIsBookParkArea];
            }else if(carList.count == 0){
                [self showHint:@"请先绑定你要预定的车辆!"];
                [self performSelector:@selector(bindCarAction) withObject:nil afterDelay:1];
            }else{
                ParkReservationViewController *parkReserVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ParkReservationViewController"];
                parkReserVC.title = @"车位预约";
                [self.navigationController pushViewController:parkReserVC animated:YES];
            }
        }else{
            [self showHint:@"请重试!"];
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

-(void)bindCarAction{
    BindCarTableViewController *bindCarVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BindCarTableViewController"];
    [self.navigationController pushViewController:bindCarVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
