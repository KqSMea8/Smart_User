//
//  VisitRecordViewController.m
//  DXWingGate
//
//  Created by coder on 2018/8/24.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "VisitRecordViewController.h"
#import "VisitRecordTableViewCell.h"
#import "VisitRecordDetailController.h"
#import "YQFaliterPopView.h"
#import "Utils.h"
#import "VisitHistoryModel.h"
#import "YQEmptyView.h"

@interface VisitRecordViewController ()<UITableViewDelegate,UITableViewDataSource,YQFaliterPopViewDelegate>
{
    YQFaliterPopView *filterView;
    int _page;
    int _length;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation VisitRecordViewController

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _length = 10;
    
    [kNotificationCenter addObserver:self selector:@selector(filterAction) name:@"VisitRecordFilterNotification" object:nil];
    
    [self initView];
    
    [self loadData];
    
    [self.tableView.mj_header beginRefreshing];
    
    YYReachability *rech = [YYReachability reachability];
    if (!rech.reachable) {
        self.tableView.ly_emptyView = self.noNetworkView;
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    }
    
    [kNotificationCenter addObserver:self selector:@selector(refreshVisitResStatus) name:@"visitResStatusChangeNotification" object:nil];
}

-(void)refreshVisitResStatus
{
    [self loadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [kNotificationCenter postNotificationName:@"VisittabbarDidSelectItemNotification" object:nil];
}

-(void)initView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight-33-49);
    }else{
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight-49);
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"VisitRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"VisitRecordTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadData];
    }];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self loadData];
    }];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
    }

    self.tableView.mj_footer.automaticallyHidden = YES;
    [self.view addSubview:self.tableView];
}

-(void)loadData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/getAppointments",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNumber"];
    [params setObject:[NSString stringWithFormat:@"%d",_length] forKey:@"pageSize"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(_page == 1){
            [_dataArr removeAllObjects];
        }
        
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
//            NSLog(@"%@",responseObject);
            if (![responseObject[@"responseData"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dic = responseObject[@"responseData"];
                NSArray *arr;
                if (![dic[@"rows"] isKindOfClass:[NSNull class]]) {
                    arr = dic[@"rows"];
                }
                if(_page == 1){
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
                    VisitHistoryModel *model = [[VisitHistoryModel alloc] initWithDataDic:obj];
                    [self.dataArr addObject:model];
                }];
            }
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VisitRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VisitRecordTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VisitRecordDetailController *homeVC = [[UIStoryboard storyboardWithName:@"Visit" bundle:nil] instantiateViewControllerWithIdentifier:@"VisitRecordDetailController"];
    homeVC.model = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:homeVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(void)filterAction
{
    if (filterView.isShow) {
        return;
    }
    filterView = [[YQFaliterPopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //显示
    filterView.delegate = self;
    [filterView showInView:self.view];
}

#pragma mark - PopViewDelegate
-(void)resetCallBackAction
{
    _page = 1;
    
    [self loadData];
}

-(void)completeCallBackAction
{
//    NSLog(@"%@,%@,%@,%@",filterView.visitName,filterView.visitCarNum,filterView.arriveTime,filterView.leaveTime);
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/getAppointments",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    if (filterView.visitName != nil&&filterView.visitName.length != 0) {
        [params setObject:filterView.visitName forKey:@"visitorName"];
    }
    
    if (filterView.visitCarNum != nil&&filterView.visitCarNum.length != 0) {
        [params setObject:filterView.visitCarNum forKey:@"carNo"];
    }
    
    if (filterView.arriveTime != nil&&filterView.arriveTime.length != 0) {
        NSString *beginStr = [NSString stringWithFormat:@"%@ 00:00:00",filterView.arriveTime];
        [params setObject:beginStr forKey:@"beginTime"];
    }
    
    if (filterView.leaveTime != nil&&filterView.leaveTime.length != 0) {
        NSString *endStr = [NSString stringWithFormat:@"%@ 24:00:00",filterView.leaveTime];
        [params setObject:endStr forKey:@"endTime"];
    }
//    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNumber"];
//    [params setObject:[NSString stringWithFormat:@"%d",_length] forKey:@"pageSize"];
    
    NSString *jsonStr = [self convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        [self.dataArr removeAllObjects];
        
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            if (![responseObject[@"responseData"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dic = responseObject[@"responseData"];
                NSArray *arr;
                if (![dic[@"rows"] isKindOfClass:[NSNull class]]) {
                    arr = dic[@"rows"];
                }
                
                if ([arr isKindOfClass:[NSNull class]]||arr.count == 0) {
                    self.tableView.ly_emptyView = self.noDataView;
                    [self.tableView reloadData];
                    [self.tableView ly_endLoading];
                    return;
                }
                
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    VisitHistoryModel *model = [[VisitHistoryModel alloc] initWithDataDic:obj];
                    [self.dataArr addObject:model];
                }];
            }
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

-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range];
    return mutStr;
}

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"VisitRecordFilterNotification" object:nil];
    [kNotificationCenter removeObserver:self name:@"visitResStatusChangeNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
