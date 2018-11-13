//
//  HistoryVistorViewController.m
//  DXWingGate
//
//  Created by coder on 2018/9/4.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "HistoryVistorViewController.h"
#import "VistorHistoryTableViewCell.h"
#import "YQSearchBar.h"
#import "Utils.h"
#import "VisitHistoryModel.h"
#import "YQEmptyView.h"

@interface HistoryVistorViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    __weak IBOutlet UIView *searchBgView;
    __weak IBOutlet YQSearchBar *searchBar;
    
    int _page;
    int _length;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation HistoryVistorViewController

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
    
    [self initNav];
    
    [self initView];
    
    [self loadData:nil];
    
    [self.tableView.mj_header beginRefreshing];
    
    YYReachability *rech = [YYReachability reachability];
    if (!rech.reachable) {
        self.tableView.ly_emptyView = self.noNetworkView;
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    }
}

-(void)initNav
{
    self.title = @"选择访客";
    
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

-(void)initView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    searchBar.labelColor = [UIColor colorWithHexString:@"#CFCFCF"];
    searchBar.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, searchBar.bottom+5, KScreenWidth, KScreenHeight - kTopHeight-33-49);
    }else{
        self.tableView.frame = CGRectMake(0, searchBar.bottom+5, KScreenWidth, KScreenHeight - kTopHeight-49);
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"VistorHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"VistorHistoryTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        NSString *searchStr = searchBar.text;
        searchStr = [searchStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (searchStr != nil&&searchStr.length != 0) {
            [self loadData:searchBar.text];
        }else{
            [self loadData:nil];
        }
    }];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        NSString *searchStr = searchBar.text;
        searchStr = [searchStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (searchStr != nil&&searchStr.length != 0) {
            [self loadData:searchBar.text];
        }else{
            [self loadData:nil];
        }
    }];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self.view addSubview:self.tableView];
}

-(void)loadData:(NSString *)str
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/getVisitors",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    if (str == nil) {
        [params setObject:@"" forKey:@"queryValue"];
    }else{
        [params setObject:str forKey:@"queryValue"];
    }
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
            NSDictionary *dic = responseObject[@"responseData"];
            
            NSArray *arr = dic[@"rows"];
            
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
            
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
    VistorHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VistorHistoryTableViewCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakself = self;
    VisitHistoryModel *model = self.dataArr[indexPath.row];
    if (self.historyValueBlock) {
        weakself.historyValueBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (YQEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [YQEmptyView diyEmptyView];
    }
    return _noDataView;
}

- (YQEmptyView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [YQEmptyView diyEmptyActionViewWithTarget:self action:@selector(loadData:)];
    }
    return _noNetworkView;
}

#pragma mark UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self.dataArr removeAllObjects];
    NSString *searchStr = searchBar.text;
    searchStr = [searchStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchStr != nil&&searchStr.length != 0) {
        _page = 1;
        [self loadData:searchBar.text];
    }else{
        [self loadData:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
