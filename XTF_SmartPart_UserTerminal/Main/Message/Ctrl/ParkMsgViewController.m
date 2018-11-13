//
//  ParkMsgViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ParkMsgViewController.h"
#import "ParkMsgTableViewCell.h"
#import "NoDataView.h"
#import "ParkMsgModel.h"
#import "CalculateHeight.h"
#import "YQEmptyView.h"
#import "ParkMessageModel.h"
#import "MessageDetailViewController.h"

@interface ParkMsgViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_msgData;
    
    int _page;
    int _length;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation ParkMsgViewController

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
    
    [self.tableView.mj_header beginRefreshing];
    
    [self _loadMsgData];
}

-(void)_initView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"ParkMsgTableViewCell"];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-60);
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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

/*
- (void)_loadMsgData {
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/member/getMessagePushList",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    [params setValue:[NSNumber numberWithInt:_page * _length] forKey:@"start"];
    [params setValue:[NSNumber numberWithInt:_length] forKey:@"length"];
    [params setValue:@"12" forKey:@"pushType"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if([responseObject[@"success"] boolValue]) {
            NSArray *data = responseObject[@"data"][@"data"];
            if(_page == 0){
                [_msgData removeAllObjects];
                if ([data isKindOfClass:[NSNull class]]||data.count == 0) {
                    self.tableView.ly_emptyView = self.noDataView;
                    [self.tableView reloadData];
                    [self.tableView ly_endLoading];
                    return;
                }
            }
            if(data.count > 0){
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            if(![data isKindOfClass:[NSNull class]]&&data != nil){
                [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ParkMsgModel *model = [[ParkMsgModel alloc] initWithDataDic:obj];
                    [_msgData addObject:model];
                }];
            }
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
*/

- (void)_loadMsgData{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getMessageList?appType=user&loginName=%@&pageNum=%d&messageType=05",MainUrl,[kUserDefaults objectForKey:kCustId],_page];
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] isEqualToString:@"1"]) {
            NSArray *msgAry = responseObject[@"responseData"];
            if(_page == 0){
                [_msgData removeAllObjects];
                if ([msgAry isKindOfClass:[NSNull class]]||msgAry.count == 0) {
                    self.tableView.ly_emptyView = self.noDataView;
                    [self.tableView reloadData];
                    [self.tableView ly_endLoading];
                    return;
                }
            }
            
            if(msgAry.count > 0){
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            [msgAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ParkMessageModel *msgModel = [[ParkMessageModel alloc] initWithDataDic:obj];
                [_msgData addObject:msgModel];
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
    ParkMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkMsgTableViewCell" forIndexPath:indexPath];
    cell.parkMsgModel = _msgData[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkMessageModel *model = _msgData[indexPath.row];
    CGFloat height = 73;
    height += [CalculateHeight heightForString:model.PUSH_CONTENT fontSize:17 andWidth:KScreenWidth - 20];
    return height;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkMessageModel *model = _msgData[indexPath.row];
    [self deleteMessage:model.PUSH_ID];
}

-(void)deleteMessage:(NSNumber *)pushId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/delMessage?pushId=%@",MainUrl,pushId];
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        [self _loadMsgData];
        [kNotificationCenter postNotificationName:@"readMessageNotification" object:nil];
    } failure:^(NSError *error) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkMessageModel *model = _msgData[indexPath.row];
    [self readMessage:model];
    
    MessageDetailViewController *msgDetailVC = [[UIStoryboard storyboardWithName:@"Message" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageDetailViewController"];
    msgDetailVC.model = model;
    [self.navigationController pushViewController:msgDetailVC animated:YES];
}

-(void)readMessage:(ParkMessageModel *)model
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/readMessage?pushId=%@",MainUrl,model.PUSH_ID];
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        [self _loadMsgData];
        [kNotificationCenter postNotificationName:@"readMessageNotification" object:nil];
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
