//
//  WorkMsgViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "WorkMsgViewController.h"
#import "YQEmptyView.h"

@interface WorkMsgViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_msgData;
    
    int _page;
    int _length;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation WorkMsgViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return _StatusBarStyle;
}

//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle=StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _msgData = @[].mutableCopy;
    _page = 0;
    _length = 10;
    
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    
    [self _initView];
    
    [self _loadMsgData];
    
    YYReachability *rech = [YYReachability reachability];
    if (!rech.reachable) {
        self.tableView.ly_emptyView = self.noNetworkView;
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    }
}

-(void)_initView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
//    [self.tableView registerNib:[UINib nibWithNibName:@"ParkMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"ParkMsgTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellReuseIdentifierID"];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-60);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self _loadMsgData];
    }];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self _loadMsgData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
}

-(void)_loadMsgData
{
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
    
}

- (YQEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [YQEmptyView msgDiyEmptyView];
    }
    return _noDataView;
}

- (YQEmptyView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [YQEmptyView diyEmptyActionViewWithTarget:self action:@selector(_loadMsgData)];
    }
    return _noNetworkView;
}

#pragma mark tableview delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _msgData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellReuseIdentifierID" forIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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

@end
