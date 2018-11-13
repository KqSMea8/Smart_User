//
//  BookRecordViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/6.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BookRecordViewController.h"
#import "BookRecordTableViewCell.h"
#import "BookRecordDetailController.h"
#import "Utils.h"
#import "BookRecordModel.h"
#import "YQEmptyView.h"
#import "BookRecordParkAreaModel.h"
#import "BookRecordParkSpaceModel.h"
#import "BookDetailsViewController.h"

@interface BookRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
    int _length;
}

@property (nonatomic,retain) NSMutableArray *orderDataArr;
@property (nonatomic,retain) NSMutableArray *parkAreaDataArr;
@property (nonatomic,retain) NSMutableArray *parkSpaceDataArr;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation BookRecordViewController

-(NSMutableArray *)orderDataArr
{
    if (_orderDataArr == nil) {
        _orderDataArr = [NSMutableArray array];
    }
    return _orderDataArr;
}

-(NSMutableArray *)parkAreaDataArr
{
    if (_parkAreaDataArr == nil) {
        _parkAreaDataArr = [NSMutableArray array];
    }
    return _parkAreaDataArr;
}

-(NSMutableArray *)parkSpaceDataArr
{
    if (_parkSpaceDataArr == nil) {
        _parkSpaceDataArr = [NSMutableArray array];
    }
    return _parkSpaceDataArr;
}

- (YQEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [YQEmptyView diyEmptyView];
    }
    return _noDataView;
}

- (YQEmptyView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [YQEmptyView diyEmptyActionViewWithTarget:self action:@selector(loadData)];
    }
    return _noNetworkView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _length = 10;
    
    [self initNavItems];
    
    [self initTableView];
    
    [self loadData];
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
}

- (void)_leftBarBtnItemClick {
    [kNotificationCenter postNotificationName:@"refreshParkAreaStatusNotification" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initTableView
{
    [kNotificationCenter addObserver:self selector:@selector(unlockAndRefresh:) name:@"unlockNotification" object:nil];
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"BookRecordTableViewCell"];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadData];
    }];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self loadData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadData{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/getParkingOrdersDetail",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"custId"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNumber"];
    [params setObject:[NSString stringWithFormat:@"%d",_length] forKey:@"pageSize"];
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *arr = dic[@"items"];
            if(_page == 1){
                [self.orderDataArr removeAllObjects];
                [self.parkAreaDataArr removeAllObjects];
                [self.parkSpaceDataArr removeAllObjects];
                if ([arr isKindOfClass:[NSNull class]]||arr.count == 0) {
                    self.tableView.ly_emptyView = self.noDataView;
                    [self.tableView reloadData];
                    [self.tableView ly_endLoading];
                    return;
                }
            }
            if(arr.count > 0){
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dataDic = (NSDictionary *)obj;
                BookRecordModel *model = [[BookRecordModel alloc] initWithDataDic:dataDic[@"order"]];
                BookRecordParkAreaModel *parkAreaModel = [[BookRecordParkAreaModel alloc] initWithDataDic:dataDic[@"parkingArea"]];
                BookRecordParkSpaceModel *parkSpaceModel = [[BookRecordParkSpaceModel alloc] initWithDataDic:dataDic[@"parkingSpace"]];
                [self.orderDataArr addObject:model];
                [self.parkAreaDataArr addObject:parkAreaModel];
                [self.parkSpaceDataArr addObject:parkSpaceModel];
            }];
            
        }else{
            self.tableView.ly_emptyView = self.noDataView;
        }
        
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderDataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 252.5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookRecordTableViewCell" forIndexPath:indexPath];
    cell.model = self.orderDataArr[indexPath.row];
    cell.parkSpaceModel = self.parkSpaceDataArr[indexPath.row];
    cell.parkAreaModel = self.parkAreaDataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookRecordModel *model = self.orderDataArr[indexPath.row];
    if ([model.status isEqualToString:@"0"]) {
        [self loadDetailData:model.orderId];
    }else{
        BookRecordDetailController *bookRecordDetailVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BookRecordDetailController"];
        bookRecordDetailVC.orderId = model.orderId;
        [self.navigationController pushViewController:bookRecordDetailVC animated:YES];
    }
}

-(void)loadDetailData:(NSString *)orderId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/parkingOrderDetail",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderId forKey:@"orderId"];
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
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
}

-(void)unlockAndRefresh:(NSNotification *)notification
{
    [self loadData];
}

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"unlockNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
