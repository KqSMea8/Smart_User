//
//  AccessListViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/5/29.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "AccessListViewController.h"
#import "YQEmptyView.h"
#import "AControlTableViewCell.h"
#import "OpenDoorModel.h"
#import "FloorModel.h"
#import "EntranceGuardViewController.h"
#import "MenuView.h"

@interface AccessListViewController ()<UITableViewDelegate,UITableViewDataSource,OpenDoorDelegate,NormalMenuDelegate>
{
    NSMutableArray *_dataArr;
    BOOL isExit;
}

@property (nonatomic,strong) NSMutableDictionary *dict;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation AccessListViewController

-(void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self _initView];
    
    [self _loadData];
    
    [kNotificationCenter addObserver:self selector:@selector(refreshDoorList) name:@"AddCommonlyDoor" object:nil];
}

-(void)refreshDoorList{
    [self _loadData];
}

-(void)_initNavItems
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    
    self.title = _titleStr;
    
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

-(void)_initView
{
    _dataArr = @[].mutableCopy;
    //记录的字典
    self.dict = [NSMutableDictionary dictionary];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"AControlTableViewCell" bundle:nil] forCellReuseIdentifier:@"AControlTableViewCell"];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self _loadData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)_loadData
{
    NSString *certIds = [kUserDefaults objectForKey:KUserCertId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/getUserDoorBulidingList",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:certIds forKey:@"certIds"];
    [params setObject:@"-11" forKey:@"buildId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [_dataArr removeAllObjects];
        [self.tableView.mj_header endRefreshing];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            if (![responseObject[@"responseData"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dic = responseObject[@"responseData"];
                
                NSMutableArray *commonDoorListArr = dic[@"commonDoorList"];
                NSMutableArray *layerListArr = dic[@"layerList"];
                
                [layerListArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableArray *layerArr = @[].mutableCopy;
                    FloorModel *model = [[FloorModel alloc] initWithDataDic:obj];
                    [layerArr addObject:model];
                    [_dataArr addObject:layerArr];
                }];
                
                NSMutableArray *gateTempArr = @[].mutableCopy;
                NSMutableArray *doorTempArr = @[].mutableCopy;
                
                if (![commonDoorListArr isKindOfClass:[NSNull class]]&&commonDoorListArr.count != 0) {
                    isExit = YES;
                    
                    [commonDoorListArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        OpenDoorModel *model = [[OpenDoorModel alloc] initWithDataDic:obj];
                        if ([model.DEVICE_TYPE isEqualToString:@"4-1"]) {
                            [gateTempArr addObject:model];
                        }else{
                            [doorTempArr addObject:model];
                        }
                    }];
                    
                    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:gateTempArr];
                    [tempArr addObjectsFromArray:doorTempArr];
                    
                    [_dataArr insertObject:tempArr atIndex:0];
                }else{
                    isExit = NO;
                    NSMutableArray *arr = @[].mutableCopy;
                    [_dataArr insertObject:arr atIndex:0];
                    
                }
                
                [self.tableView reloadData];
                [self.tableView ly_endLoading];
            }
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

- (YQEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [YQEmptyView diyEmptyView];
    }
    return _noDataView;
}

- (YQEmptyView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [YQEmptyView diyEmptyActionViewWithTarget:self action:@selector(_loadData)];
    }
    return _noNetworkView;
}

#pragma mark UItableView 协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *str = [NSString stringWithFormat:@"%ld",section];
    NSArray *arr = _dataArr[section];
    if (isExit) {
        if (section == 0) {
            if([self.dict[str] integerValue] == 1){
                return 0;
            }else{
                return arr.count;
            }
        }else{
            if([self.dict[str] integerValue] == 1){
                return arr.count;
            }else{
                return 0;
            }
        }
    }else{
        if (arr.count == 0) {
            return 1;
        }else{
            if([self.dict[str] integerValue] == 1){
                return arr.count;
            }else{
                return 0;
            }
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *_cell;
    NSArray *arr = _dataArr[indexPath.section];
    if (indexPath.section == 0) {
        if (arr.count == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"remaindCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, cell.width-25, 60)];
            lable.font = [UIFont systemFontOfSize:17];
            lable.text = @"·将使用频繁的门禁加入常用,方便工作";
            lable.textColor = [UIColor lightGrayColor];
            lable.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:lable];
            _cell = cell;
        }else{
            AControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AControlTableViewCell" forIndexPath:indexPath];
            cell.delegate = self;
            NSArray *arr1 = _dataArr[indexPath.section];
            cell.model = arr1[indexPath.row];
            _cell = cell;
        }
    }else{
        AControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AControlTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        NSArray *arr1 = _dataArr[indexPath.section];
        cell.model = arr1[indexPath.row];
        _cell = cell;
    }
    return _cell;

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
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 7.5, 5, 20)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    lineView.layer.cornerRadius = 2;
    lineView.clipsToBounds = YES;
    [headerView addSubview:lineView];
    lineView.centerY = headerView.height/2;
    
    UILabel *_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 180, 20)];
    _titleLab.font = [UIFont systemFontOfSize:17];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.centerY = lineView.centerY;
    _titleLab.textColor = [UIColor blackColor];
    
    if (section == 0) {
        _titleLab.text = @"常用门禁";
    }else{
        NSArray *arr = _dataArr[section];
        FloorModel *model = arr[0];
        _titleLab.text = [NSString stringWithFormat:@"%@",model.LAYER_NAME];
    }
    
    [headerView addSubview:_titleLab];
    
    UIView *verlineView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height-0.5, headerView.width, 0.5)];
    verlineView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [headerView addSubview:verlineView];
    
    headerView.tag = section;
    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrClose:)]];
    
    return headerView;
}

-(void)openOrClose:(UITapGestureRecognizer *)tap
{
    //将点击了哪一组转换成字符串
    NSString *str = [NSString stringWithFormat:@"%ld",tap.view.tag];
    if ([str isEqualToString:@"0"]) {
        //从字典里面以第几组为key取出状态值
        //如果状态值为0，代表关闭
        if([self.dict[str] integerValue] == 0){
            [self.dict setObject:@(1) forKey:str];
        }
        //如果状态值为不为0，代表展开
        else{
            [self.dict setObject:@(0) forKey:str];
        }
        //记得一定要刷新tabelView，不然没有效果
        [self.tableView reloadData];
    }else{
        EntranceGuardViewController *entranceVC = [[EntranceGuardViewController alloc] init];
        NSArray *arr = _dataArr[tap.view.tag];
        FloorModel *model = arr[0];
        entranceVC.model = model;
        [self.navigationController pushViewController:entranceVC animated:YES];
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSMutableArray *arr = @[].mutableCopy;
    
    if (isExit) {
        if (indexPath.section == 0) {
            UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除常用"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                
                [self deleteAction:indexPath];
                
            }];
            
            deleteRowAction.backgroundColor = [UIColor redColor];
            [arr addObject:deleteRowAction];
        }
    }
    // 将设置好的按钮放到数组中返回
    return arr;
}

-(void)deleteAction:(NSIndexPath *)indexPath
{
    NSString *certIds = [kUserDefaults objectForKey:KUserCertId];
    
    NSArray *arr = _dataArr[indexPath.section];
    
    OpenDoorModel *model = arr[indexPath.row];

    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/deleteCommonDoorLog?certId=%@&tagId=%@",MainUrl,certIds,model.TAGID];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            [self _loadData];
        }
        [self showHint:responseObject[@"message"]];
    } failure:^(NSError *error) {
        [self showHint:@"删除失败!"];
    }];
}

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"AddCommonlyDoor" object:nil];
}

-(void)openDoorWithData:(OpenDoorModel *)model withAnimationView:(UIImageView *)view
{
    if ([model.DEVICE_TYPE isEqualToString:@"4-1"]) {
        MenuView *menuView = [[MenuView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight)];
        menuView.view = view;
        menuView.model = model;
        menuView.delegate = self;
        if ([model.TAGID isEqualToString:@"344"]||[model.TAGID isEqualToString:@"346"]) {
            menuView.specialTag = @"1";
        }else{
            menuView.specialTag = @"0";
        }
        [menuView showInView:self.view];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否开门" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *openDoorgraphy = [UIAlertAction actionWithTitle:@"开门" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self annimation:view];
            
            [self _unLockTheDoor:model withType:nil];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        
        [alert addAction:openDoorgraphy];
        [alert addAction:cancel];
        
        if ([alert respondsToSelector:@selector(popoverPresentationController)]) {
            alert.popoverPresentationController.sourceView = self.view; //必须加
            alert.popoverPresentationController.sourceRect = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);//可选，我这里加这句代码是为了调整到合适的位置
        }
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)menuOpenDoorWithModel:(OpenDoorModel *)model withView:(UIImageView *)view withType:(NSString *)type
{
    [self annimation:view];
    
    [self _unLockTheDoor:model withType:type];
}

-(void)annimation:(UIImageView *)lockStatusView{
    NSArray *magesArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"lock.png"],
                           [UIImage imageNamed:@"unlock.png"],
                           [UIImage imageNamed:@"lock.png"],nil];
    
    lockStatusView.animationImages = magesArray;//将序列帧数组赋给UIImageView的animationImages属性
    lockStatusView.animationDuration = 1.5;//设置动画时间
    lockStatusView.animationRepeatCount = 1;//设置动画次数 0 表示无限
    [lockStatusView startAnimating];//开始播放动画
}

#pragma mark 远程开门
-(void)_unLockTheDoor:(OpenDoorModel *)model withType:(NSString *)type
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/openDoor",MainUrl];
    
    NSMutableDictionary *param =@{}.mutableCopy;
    if ([model.DEVICE_TYPE isEqualToString:@"4-1"]) {
        if ([model.TAGID isEqualToString:@"332"]||[model.TAGID isEqualToString:@"336"]||[model.TAGID isEqualToString:@"342"]) {
            if ([type isEqualToString:@"IN"]) {
                [param setObject:@"1" forKey:@"inOutFlag"];
            }else if ([type isEqualToString:@"OUT"]){
                [param setObject:@"2" forKey:@"inOutFlag"];
            }else{
            }
        }else{
            if ([type isEqualToString:@"IN"]) {
                [param setObject:@"2" forKey:@"inOutFlag"];
            }else if ([type isEqualToString:@"OUT"]){
                [param setObject:@"1" forKey:@"inOutFlag"];
            }else{
            }
        }
    }else{
        if(![model.LAYER_C isKindOfClass:[NSNull class]]&&model.LAYER_C != nil){
            [param setObject:model.LAYER_C forKey:@"inOutFlag"];
        }
    }
    
    [param setObject:model.DEVICE_ID forKey:@"deviceId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                [self showHint:responseObject[@"message"]];
            }
        }else{
            [self showHint:@"远程开门失败!"];
        }
    } failure:^(NSError *error) {
        [self showHint:@"远程开门失败!"];
    }];
//    if(![model.TAGID isKindOfClass:[NSNull class]]&&model.TAGID != nil){
//        [param setObject:model.TAGID forKey:@"tagId"];
//    }
//    if(![model.LAYER_A isKindOfClass:[NSNull class]]&&model.LAYER_A != nil){
//        [param setObject:model.LAYER_A forKey:@"param1"];
//    }
//    [param setObject:@"5768" forKey:@"param2"];
//    if(![model.LAYER_B isKindOfClass:[NSNull class]]&&model.LAYER_B != nil){
//        [param setObject:model.LAYER_B forKey:@"param3"];
//    }
//    [param setObject:@"user" forKey:@"appType"];
//    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kCustId] forKey:@"osUser"];
//    [param setObject:[kUserDefaults objectForKey:KUserCertId] forKey:@"number"];
//
//    [[NetworkClient sharedInstance] GET:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
//        if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
//            [self showHint:responseObject[@"message"]];
//        }
//        if ([responseObject[@"code"] isEqualToString:@"1"]) {
//
//        }
//    } failure:^(NSError *error) {
//        [self showHint:@"开门失败"];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
