//
//  RepairAllViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by jiaop on 2018/5/8.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "RepairingViewController.h"
#import "RepairStateTableViewCell.h"
#import "RepairDetailViewController.h"
#import "YQEmptyView.h"
#import "Utils.h"
#import "RepairModel.h"

@interface RepairingViewController ()
{
    NSMutableArray *_repairData;
    
    int _page;
    int _length;
}

@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation RepairingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _repairData = @[].mutableCopy;
    _page = 1;
    _length = 10;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RepairStateTableViewCell" bundle:nil] forCellReuseIdentifier:@"RepairStateTableViewCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
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
    
    [self loadData];
    
}

-(void)loadData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/deviceAlarm/alarmInfo",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:@"1" forKey:@"alarmState"];
    [params setValue:[NSNumber numberWithInt:_page] forKey:@"pageNumber"];
    [params setValue:[NSNumber numberWithInt:_length] forKey:@"pageSize"];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    NSString *jsonStr = [Utils convertToJsonData:params];
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *dataArr = dic[@"items"];
            
            if(_page == 1){
                [_repairData removeAllObjects];
                if ([dataArr isKindOfClass:[NSNull class]]||dataArr.count == 0) {
                    self.tableView.ly_emptyView = self.noDataView;
                    [self.tableView reloadData];
                    [self.tableView ly_endLoading];
                    return;
                }
            }
            if(dataArr.count > 0){
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dataDic = (NSDictionary *)obj;
                RepairModel *model = [[RepairModel alloc] initWithDataDic:dataDic];
                [_repairData addObject:model];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _repairData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepairStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepairStateTableViewCell" forIndexPath:indexPath];
    cell.model = _repairData[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairModel *model = _repairData[indexPath.row];
    CGFloat height = 105;
    CGFloat contentHeight = [[NSString stringWithFormat:@"故障：%@",model.alarmInfo] sizeForFont:[UIFont systemFontOfSize:17] size:CGSizeMake(KScreenWidth-19, MAXFLOAT) mode:NSLineBreakByCharWrapping].height;
    
    if (contentHeight >41) {
        height = height+41;
    }else{
        height = height + contentHeight;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairDetailViewController *repairDetailVc = [[RepairDetailViewController alloc] init];
    repairDetailVc.model = _repairData[indexPath.row];
    [self.navigationController pushViewController:repairDetailVc animated:YES];
}

@end
