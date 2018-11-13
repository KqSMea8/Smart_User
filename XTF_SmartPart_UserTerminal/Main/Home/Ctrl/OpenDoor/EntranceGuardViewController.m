//
//  EntranceGuardViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/5/28.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "EntranceGuardViewController.h"
#import "YQInDoorPointMapView.h"
#import <UITableView+PlaceHolderView.h>
#import "NoDataView.h"
#import "OpenDoorModel.h"
#import "AControlTableViewCell.h"
#import "ShowMenuView.h"
#import "YQEmptyView.h"
#import "PointSelectView.h"
#import "MenuView.h"

#define scal 0.3

@interface EntranceGuardViewController ()<DidSelInMapPopDelegate,UITableViewDelegate,UITableViewDataSource,menuDelegate,OpenDoorDelegate,NormalMenuDelegate>
{
    YQInDoorPointMapView *indoorView;
    UITableView *tabView;
    BOOL _isSwitch;
    NSString *_menuTitle;
    UIImageView *_selectImageView;
    ShowMenuView *menuView;
    BOOL _isPortrait;
}

@property (nonatomic,strong) NSMutableArray *doorDataArr;
@property (nonatomic,strong) NSMutableArray *graphData;
@property (nonatomic,strong) NSMutableArray *tableDataArr;

@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation EntranceGuardViewController

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

-(NSMutableArray *)doorDataArr
{
    if (_doorDataArr == nil) {
        _doorDataArr = [NSMutableArray array];
    }
    return _doorDataArr;
}

-(NSMutableArray *)tableDataArr
{
    if (_tableDataArr == nil) {
        _tableDataArr = [NSMutableArray array];
    }
    return _tableDataArr;
}

-(NSMutableArray *)graphData
{
    if (_graphData == nil) {
        _graphData = [NSMutableArray array];
    }
    return _graphData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isPortrait = YES;
    
    [self _initNavItems];

    [self _initTableView];

    [self _initPointMapView];
    
    [self loadData];
}

-(void)loadData{
    NSString *certIds = [kUserDefaults objectForKey:KUserCertId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/getOpenOwnDoorAuth",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:certIds forKey:@"certIds"];
    [params setObject:_model.LAYER_ID forKey:@"layerId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self.graphData removeAllObjects];
        [self.doorDataArr removeAllObjects];
        [self.tableDataArr removeAllObjects];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            if (![responseObject[@"responseData"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dic = responseObject[@"responseData"];
                NSArray *arr = dic[@"authList"];
                
                NSMutableArray *gateTempArr = @[].mutableCopy;
                NSMutableArray *doorTempArr = @[].mutableCopy;
                
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    OpenDoorModel *model = [[OpenDoorModel alloc] initWithDataDic:obj];
                    NSString *graphStr = [NSString stringWithFormat:@"%@,%@",model.LONGITUDE, model.LATITUDE];
                    [self.graphData addObject:graphStr];
                    [self.doorDataArr addObject:model];
                    
                    if (![model.hasAuth isKindOfClass:[NSNull class]]&&[[model.hasAuth stringValue] isEqualToString:@"1"]) {
                        if ([model.DEVICE_TYPE isEqualToString:@"4-1"]) {
                            [gateTempArr addObject:model];
                        }else{
                            [doorTempArr addObject:model];
                        }
                    }
                }];
                
                [self.tableDataArr addObjectsFromArray:gateTempArr];
                [self.tableDataArr addObjectsFromArray:doorTempArr];
                
                indoorView.graphData = _graphData;
                indoorView.doorArr = _doorDataArr;
                
                if (self.tableDataArr.count == 0) {
                    tabView.ly_emptyView = self.noDataView;
                }
                
                [tabView reloadData];
                [tabView ly_endLoading];
            }
        }
    } failure:^(NSError *error) {
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            tabView.ly_emptyView = self.noNetworkView;
            [tabView reloadData];
            [tabView ly_endLoading];
        }else{
            tabView.ly_emptyView = self.noDataView;
            [tabView reloadData];
            [tabView ly_endLoading];
        }
    }];
}

-(void)_initNavItems
{
    self.title = _model.LAYER_NAME;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [rightBtn setImage:[UIImage imageNamed:@"slideMenu"] forState:UIControlStateNormal];    // switchmap
    [rightBtn addTarget:self action:@selector(_rightBarBtnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_rightBarBtnItemClick:(id)sender
{
    if (menuView != nil) {
        [menuView disMissView];
    }
    UIButton *btn = (UIButton *)sender;
    [UIView animateWithDuration:0.5 animations:^{
        if (tabView.hidden) {
            tabView.hidden = NO;
            indoorView.hidden = YES;
            
            YYReachability *rech = [YYReachability reachability];
            if (!rech.reachable) {
                tabView.ly_emptyView = self.noNetworkView;
                [tabView reloadData];
                [tabView ly_endLoading];
            }else{
                tabView.ly_emptyView = self.noDataView;
                [tabView reloadData];
                [tabView ly_endLoading];
            }
            
            [btn setImage:[UIImage imageNamed:@"switchmap"] forState:UIControlStateNormal];
            
            [self endFullScreen];
        }else{
            tabView.hidden = YES;
            indoorView.hidden = NO;
            [btn setImage:[UIImage imageNamed:@"slideMenu"] forState:UIControlStateNormal];
            [self begainFullScreen];
        }
    }];
}

-(void)_initTableView
{
    tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tabView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight);
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.tableFooterView = [UIView new];
    tabView.separatorColor = [UIColor clearColor];
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [tabView registerNib:[UINib nibWithNibName:@"AControlTableViewCell" bundle:nil] forCellReuseIdentifier:@"AControlTableViewCell"];
    tabView.hidden = YES;
    [self.view addSubview:tabView];
}

-(void)_initPointMapView
{
    if (![_model.LAYER_NUM isKindOfClass:[NSNull class]]&&[_model.LAYER_NUM isEqualToString:@"-1"]) {
        indoorView = [[YQInDoorPointMapView alloc]initWithIndoorMapImageName:@"doorPark" Frame:CGRectMake(0, 0, self.view.frame.size.width, KScreenHeight-kTopHeight)];
    }else{
        indoorView = [[YQInDoorPointMapView alloc]initWithIndoorMapImageName:[NSString stringWithFormat:@"%@",_model.LAYER_MAP] Frame:CGRectMake(0, 0, self.view.frame.size.width, KScreenHeight-kTopHeight)];
    }
    
    indoorView.selInMapDelegate = self;
    [self.view addSubview:indoorView];
}

#pragma mark 无数据协议
- (UIView *)makePlaceHolderView {
    NoDataView *noDateView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 49, KScreenWidth, tabView.height-kTopHeight)];
    noDateView.label.text = @"无结果";
    return noDateView;
}

#pragma mark UItableView 协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OpenDoorModel *model = self.tableDataArr[indexPath.row];
    AControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AControlTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = model;
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

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSMutableArray *arr = @[].mutableCopy;
    // 添加一个按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"添加常用"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

        [self addAction:indexPath.row withType:@"0"];

    }];
    deleteRowAction.backgroundColor = [UIColor colorWithHexString:@"#7bbcf9"];
    [arr addObject:deleteRowAction];
    return arr;
}

-(void)addAction:(NSInteger)index withType:(NSString *)type
{
    NSString *certIds = [kUserDefaults objectForKey:KUserCertId];
    OpenDoorModel *model;
    if ([type isEqualToString:@"1"]) {
        model = _doorDataArr[index];
    }else{
        model = self.tableDataArr[index];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/saveCommonDoorLog?doorDeviceId=%@&tagId=%@&deviceAttr=%@&deviceName=%@&deviceType=%@&layerA=%@&layerB=%@&layerC=%@&layerId=%@&certId=%@",MainUrl,model.DEVICE_ID,model.TAGID,model.DEVICE_ADDR,model.DEVICE_NAME,model.DEVICE_TYPE,model.LAYER_A,model.LAYER_B,model.LAYER_C,model.LAYER_ID,certIds];
    
    NSString *utfStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self showHudInView:kAppWindow hint:nil];
    
    [[NetworkClient sharedInstance] GET:utfStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
//            _isSwitch = YES;
            [self showHint:@"常用门禁添加成功!"];
            [kNotificationCenter postNotificationName:@"AddCommonlyDoor" object:nil];
        }else{
            _isSwitch = NO;
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                [self showHint:responseObject[@"message"]];
            }
            [menuView reloadMenu];
        }
        [self loadData];
        
    } failure:^(NSError *error) {
        [self hideHud];
        _isSwitch = NO;
        [menuView reloadMenu];
        [self showHint:@"常用门禁添加失败!"];
    }];
}

#pragma mark 点位图代理
- (void)selInMapWithId:(NSString *)identity {
    int index = [identity intValue]-100;
    OpenDoorModel *model = _doorDataArr[index];

    if (![model.hasAuth isKindOfClass:[NSNull class]]&&[[model.hasAuth stringValue] isEqualToString:@"1"]) {
        menuView = [[ShowMenuView alloc] initWithIndex:index];
        menuView.isPortrait = _isPortrait;
        if ([model.DEVICE_TYPE isEqualToString:@"4-1"]) {
            menuView.isGate = @"1";
        }else{
            menuView.isGate = @"0";
        }
        if ([model.TAGID isEqualToString:@"344"]||[model.TAGID isEqualToString:@"346"]) {
            menuView.specialTag = @"1";
        }else{
            menuView.specialTag = @"0";
        }
        menuView.delegate = self;
        [menuView showInView:self.view];
    }else{
        [self showHint:@"无权限操作此门禁!"];
        return;
    }
    _menuTitle = model.DEVICE_NAME;
    if (![model.isCommon isKindOfClass:[NSNull class]]&&[[model.isCommon stringValue] isEqualToString:@"1"]) {
        _isSwitch = YES;
    }else{
        _isSwitch = NO;
    }
    
    [menuView reloadMenu];
    
    // 复原之前选中图片效果
    if(_selectImageView != nil){
        [PointSelectView recoverSelImgView:_selectImageView];
    }
    
    UIImageView *imageView = [indoorView.mapView viewWithTag:[identity integerValue]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    _selectImageView = imageView;
    
    [PointSelectView pointImageSelect:_selectImageView];
}

#pragma mark 弹窗代理
-(void)closeMenu
{
    // 复原之前选中图片效果
    if(_selectImageView != nil){
        [PointSelectView recoverSelImgView:_selectImageView];
    }
}

-(BOOL)isSwitch:(int)index{
    return _isSwitch;
}

-(NSString *)titleForMenu:(int)index
{
    return _menuTitle;
}

-(void)openDoorWithIndex:(int)index withView:(UIImageView *)view withType:(NSString *)type
{
    [self _unLockTheDoor:index withView:view withType:type];
}

#pragma mark 远程开门
-(void)_unLockTheDoor:(int)index withView:(UIImageView *)view withType:(NSString *)type
{
    [self annimation:view];
    
    [self openDoor:index withType:type];
    
    [menuView disMissView];
}

-(void)annimation:(UIImageView *)view{
    NSArray *magesArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"lock.png"],
                           [UIImage imageNamed:@"unlock.png"],
                           [UIImage imageNamed:@"lock.png"],nil];
    
    //将序列帧数组赋给UIImageView的animationImages属性
    view.animationImages = magesArray;
    //设置动画时间
    view.animationDuration = 1.5;
    //设置动画次数 0 表示无限
    view.animationRepeatCount = 1;
    //开始播放动画
    [view startAnimating];
}

-(void)openDoor:(int)index withType:(NSString *)type
{
    OpenDoorModel *model = _doorDataArr[index];
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
}

-(void)deleteAction:(int)index
{
    NSString *certIds = [kUserDefaults objectForKey:KUserCertId];
    
    OpenDoorModel *model = _doorDataArr[index];

    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/deleteCommonDoorLog?certId=%@&tagId=%@",MainUrl,certIds,model.TAGID];
    
    [self showHudInView:kAppWindow hint:nil];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
            [self showHint:responseObject[@"message"]];
        }
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
//            _isSwitch = NO;
        }else{
            _isSwitch = YES;
            [menuView reloadMenu];
        }
        
        [kNotificationCenter postNotificationName:@"AddCommonlyDoor" object:nil];
        
        [self loadData];
        
    } failure:^(NSError *error) {
        [self hideHud];
        _isSwitch = YES;
        [menuView reloadMenu];
        [self showHint:@"删除失败!"];
    }];
    
}

#pragma mark 添加常用门禁
-(void)switchState:(int)index withSwitch:(BOOL)isOn
{
    if (isOn) {
        [self addAction:index withType:@"1"];
    }else{
        [self deleteAction:index];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self begainFullScreen];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endFullScreen];
}

//进入全屏
-(void)begainFullScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
}

// 退出全屏
-(void)endFullScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;

    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (size.width > size.height) { // 横屏
        // 横屏布局
        indoorView.frame = CGRectMake(0, 0, KScreenHeight, KScreenWidth- 32);
        menuView.frame = CGRectMake(0, 0, KScreenHeight, KScreenWidth - 32);
        _isPortrait = NO;
    } else {
        // 竖屏布局
        indoorView.frame = CGRectMake(0, 0, KScreenHeight, self.view.frame.size.width);
        menuView.frame = CGRectMake(0, 0, KScreenHeight, KScreenWidth - kTopHeight -20);
        _isPortrait = YES;
    }
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
            
            [self openDoorWithModel:model withType:nil];
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
    
    [self openDoorWithModel:model withType:type];
}

-(void)openDoorWithModel:(OpenDoorModel *)model withType:(NSString *)type
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
