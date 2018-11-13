//
//  ParkAllViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/2.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ParkAllViewController.h"
#import "ParkAllRcordTableViewCell.h"
#import "YQEmptyView.h"
#import "ParkDetailMsgController.h"
#import "CarRecordModel.h"

@interface ParkAllViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
    int _length;
    
    NSMutableArray *_recordData;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation ParkAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _recordData = @[].mutableCopy;
    _page = 0;
    _length = 10;
    
    [self _initView];
    
    [self.tableView.mj_header beginRefreshing];
    
//    if ([kUserDefaults objectForKey:KMemberId] != nil&&![[kUserDefaults objectForKey:KMemberId] isKindOfClass:[NSNull class]]) {
//        [self _loadBindCarData];
//    }else{
//        [self _loadParkMemberId];
//    }

}

- (void)_loadParkMemberId {
    // 访客、员工 根据手机号查询停车接口需要使用的用户信息
    if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile] ||
       [[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]
       ){
        if([[NSUserDefaults standardUserDefaults] objectForKey:KMemberId] == nil){
            [self _loadParkUserInfo];
        }
    }
}

- (void)_loadParkUserInfo {
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/hntfEsb/parking/member/info",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:KUserPhoneNum];
    if(userPhone != nil){
        [params setObject:userPhone forKey:@"phone"];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%f", [NSDate date].timeIntervalSince1970 * 1000000];
    NSString *time = [timeStr componentsSeparatedByString:@"."].firstObject;
    NSString *userName = [time substringFromIndex:time.length - 11];
    [params setObject:userName forKey:@"ts"];
    
    NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    [params setObject:udid forKey:@"guid"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            NSDictionary *data = responseObject[@"data"];
            if(![data isKindOfClass:[NSNull class]]&&data != nil){
                NSDictionary *member = data[@"member"];
                if(![member isKindOfClass:[NSNull class]]&&member != nil){
                    NSString *memberId = member[@"memberId"];
                    if(![memberId isKindOfClass:[NSNull class]]&&memberId != nil){
                        [[NSUserDefaults standardUserDefaults] setObject:memberId forKey:KMemberId];
                        [self _loadBindCarData];
                    }
                }
            }else{
                [self.tableView.mj_header endRefreshing];
                self.tableView.ly_emptyView = self.noDataView;
                [self.tableView reloadData];
                [self.tableView ly_endLoading];
                
            }
        }else{
            [self.tableView.mj_header endRefreshing];
            self.tableView.ly_emptyView = self.noDataView;
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }
    } failure:^(NSError *error) {
        
    }];
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
            
            NSArray *carList = responseObject[@"data"][@"carList"];
            if (![carList isKindOfClass:[NSNull class]]&&carList.count != 0) {
                [self _loadRecordData];
            }else{
                [self.tableView.mj_header endRefreshing];
                self.tableView.ly_emptyView = self.noDataView;
                [self.tableView reloadData];
                [self.tableView ly_endLoading];
                
            }
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
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }else{
            self.tableView.ly_emptyView = self.noDataView;
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }
    }];
}

-(void)_initView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"E2E2E2"];
    if (kDevice_Is_iPhoneX) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight - 65-17) style:UITableViewStylePlain];
    }else{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight- 65) style:UITableViewStylePlain];
    }
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkAllRcordTableViewCell" bundle:nil] forCellReuseIdentifier:@"ParkAllRcordTableViewCell"];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        if (![[kUserDefaults objectForKey:KMemberId] isKindOfClass:[NSNull class]]&&[kUserDefaults objectForKey:KMemberId] != nil) {
            [self _loadBindCarData];
        }else{
            [self _loadParkMemberId];
        }
    }];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        if (![[kUserDefaults objectForKey:KMemberId] isKindOfClass:[NSNull class]]&&[kUserDefaults objectForKey:KMemberId] != nil) {
            [self _loadBindCarData];
        }else{
            [self _loadParkMemberId];
        }
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
}

#pragma mark 所有停车记录
- (void)_loadRecordData {
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/trace/getMemberTraceList",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    [params setValue:[NSNumber numberWithInt:_page * _length] forKey:@"start"];
    [params setValue:[NSNumber numberWithInt:_length] forKey:@"length"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if([responseObject[@"success"] boolValue]){
            NSArray *carRecord = responseObject[@"data"][@"data"];
            if(_page == 0){
                [_recordData removeAllObjects];
                if ([carRecord isKindOfClass:[NSNull class]]||carRecord.count == 0) {
                    self.tableView.ly_emptyView = self.noDataView;
                    [self.tableView reloadData];
                    [self.tableView ly_endLoading];
                    return;
                }
            }
            if(carRecord.count > 0){
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [carRecord enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CarRecordModel *carRecordModel = [[CarRecordModel alloc] initWithDataDic:obj];
                [_recordData addObject:carRecordModel];
            }];
        }
        [self.tableView cyl_reloadData];
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
        _noNetworkView = [YQEmptyView diyEmptyActionViewWithTarget:self action:@selector(_loadBindCarData)];
    }
    return _noNetworkView;
}

//-(void)headerRereshing {
//    _page = 0;
//    [self _loadRecordData];
//}
//
//-(void)footerRereshing {
//    _page ++;
//    [self _loadRecordData];
//}

#pragma mark UItableView 协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkAllRcordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkAllRcordTableViewCell" forIndexPath:indexPath];
    cell.carRecordModel = _recordData[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
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
    ParkDetailMsgController *parkMsgVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ParkDetailMsgController"];
    parkMsgVC.carRecordModel = _recordData[indexPath.row];
    [self.navigationController pushViewController:parkMsgVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
