//
//  MessageViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "UITabBar+CustomBadge.h"
#import "MessageModel.h"
#import "Utils.h"
#import "MsgListViewController.h"
#import "ParkMessageModel.h"
#import "YQEmptyView.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}

@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MessageViewController

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initData];
    
    [kNotificationCenter addObserver:self selector:@selector(refreshUnReadMessage) name:@"readMessageNotification" object:nil];
    
    [self _initView];
    
    [self initNavItems];
    
    [self _loadMsgData];
    
    [self loadData];
}

-(void)initNavItems
{
    self.title = @"消息";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"一键已读" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightBtn addTarget:self action:@selector(rightBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

-(void)rightBarBtnItemClick
{
    UIAlertController *navAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定将未读消息全部标记为已读？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [navAlert addAction:cancel];
    
    UIAlertAction *baiduAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/public/readAllMessage",MainUrl];
        
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:@"user" forKey:@"appType"];
        [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"loginName"];
        [params setObject:@"05" forKey:@"messageType"];
        
        NSString *jsonStr = [Utils convertToJsonData:params];
        NSMutableDictionary *param = @{}.mutableCopy;
        [param setObject:jsonStr forKey:@"param"];
        
        [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
            [self _loadMsgData];
            [self loadData];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }];
    [navAlert addAction:baiduAction];
    
    if ([navAlert respondsToSelector:@selector(popoverPresentationController)]) {
        navAlert.popoverPresentationController.sourceView = self.view; //必须加
        navAlert.popoverPresentationController.sourceRect = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);//可选，我这里加这句代码是为了调整到合适的位置
    }
    
    [self presentViewController:navAlert animated:YES completion:nil];
}

-(void)loadData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getMessageStatus",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:@"user" forKey:@"appType"];
    [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"loginName"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.dataArr removeAllObjects];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSDictionary *parkOrderDic = dic[@"parkOrder"];
            NSDictionary *latestMessageDic = parkOrderDic[@"latestMessage"];
            ParkMessageModel *model = [[ParkMessageModel alloc] initWithDataDic:latestMessageDic];
            model.headerImage = [NSString stringWithFormat:@"%@",@"message_parkMsg"];
            model.titleStr = [NSString stringWithFormat:@"%@",@"停车消息"];
            model.UNREAD_SUM = [parkOrderDic[@"UNREAD_SUM"] stringValue];
            [self.dataArr addObject:model];
            [self.dataArr addObjectsFromArray:self.dataList];
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

#pragma mark 加载未读消息
- (void)_loadMsgData {
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getUnreadMessage?appType=user&loginName=%@&messageType=05",MainUrl,[kUserDefaults objectForKey:kCustId]];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        NSDictionary *data = responseObject;
        if ([data[@"code"] isEqualToString:@"1"]) {
            NSNumber *msgNum = responseObject[@"responseData"];
            if(msgNum != nil && ![msgNum isKindOfClass:[NSNull class]] && msgNum.integerValue > 0){
                [self.tabBarController.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:0 atIndex:1];
            }else {
                [self.tabBarController.tabBar setBadgeStyle:kCustomBadgeStyleNone value:0 atIndex:1];
            }
        }
    } failure:^(NSError *error) {
    }];
}

-(void)_initView
{
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageTableViewCell"];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49);
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self _loadMsgData];
        [self loadData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)_initData
{
    self.dataList=[NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic=@{@"PUSH_CONTENT":@"暂无消息",@"headerImage":@"message_workMsg",@"titleStr":@"工作消息"};
    ParkMessageModel *model = [[ParkMessageModel alloc] initWithDataDic:dic];
    [self.dataList addObject:model];
    
    NSDictionary *dic2=@{@"PUSH_CONTENT":@"暂无消息",@"headerImage":@"message_pNoticeMsg",@"titleStr":@"园区通知"};
    ParkMessageModel *model2 = [[ParkMessageModel alloc] initWithDataDic:dic2];
    [self.dataList addObject:model2];
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
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgListViewController *msgListVC = [[MsgListViewController alloc] init];
    msgListVC.selectIndex = indexPath.row;
    [self.navigationController pushViewController:msgListVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _loadMsgData];
    [self loadData];
}

-(void)refreshUnReadMessage
{
    [self _loadMsgData];
    [self loadData];
}

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"readMessageNotification" object:nil];
}

@end
