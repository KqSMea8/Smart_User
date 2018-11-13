//
//  AccessControlViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/21.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "AccessControlViewController.h"
#import "AControlTableViewCell.h"
#import "OpenDoorModel.h"
#import "YQEmptyView.h"
#import "EntranceGuardViewController.h"

@interface AccessControlViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArr;
    BOOL isExit;
    
    UIButton *rightBtn;
}

@property (nonatomic,strong) NSMutableDictionary *dict;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation AccessControlViewController

//只支持竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initNavItems];
    
    [self _initView];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self _loadData];
    
    [kNotificationCenter addObserver:self selector:@selector(refreshDoorList) name:@"AddCommonlyDoor" object:nil];
}

-(void)refreshDoorList
{
    [self _loadData];
}

-(void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
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
}

-(void)_loadData
{
    NSString *certIds = [kUserDefaults objectForKey:KUserCertId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/getOpenOwnDoorAuth?certIds=%@",MainUrl,certIds];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        [_dataArr removeAllObjects];
        [self.tableView.mj_header endRefreshing];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *arr = dic[@"AuthList"];
            if (arr.count == 0||[arr isKindOfClass:[NSNull class]]) {
                self.tableView.ly_emptyView = self.noDataView;
                [self.tableView reloadData];
                [self.tableView ly_endLoading];
                return;
            }
            
            NSMutableArray *layerIDarr = @[].mutableCopy;
            NSMutableArray *tempDataArr = @[].mutableCopy;
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OpenDoorModel *model = [[OpenDoorModel alloc] initWithDataDic:obj];
                if(![model.LAYER_ID isKindOfClass:[NSNull class]]&&model.LAYER_ID != nil){
                    [layerIDarr addObject:model.LAYER_ID];
                    [tempDataArr addObject:model];
                }
            }];
            
            // 直接调用集合类初始化方法。
            NSSet *set = [NSSet setWithArray:layerIDarr];
            NSArray *layerIdArr = [set allObjects];
            
            NSArray *result = [layerIdArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2]; //升序
            }];
            
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSNumber *layerId = (NSNumber *)obj;
                NSMutableArray *layerArr = @[].mutableCopy;
                NSMutableArray *gateTempArr = @[].mutableCopy;
                NSMutableArray *doorTempArr = @[].mutableCopy;
                [tempDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    OpenDoorModel *model = (OpenDoorModel *)obj;
                    if ([[layerId stringValue] isEqualToString:[NSString stringWithFormat:@"%@",model.LAYER_ID]]) {
                        if ([model.DEVICE_TYPE isEqualToString:@"4-1"]) {
                            [gateTempArr addObject:model];
                        }else{
                            [doorTempArr addObject:model];
                        }
                    }
                }];
                [layerArr addObjectsFromArray:gateTempArr];
                [layerArr addObjectsFromArray:doorTempArr];
                
                [_dataArr addObject:layerArr];
            }];
            
            NSMutableArray *gateTempArr = @[].mutableCopy;
            NSMutableArray *doorTempArr = @[].mutableCopy;
            NSArray *commentArr = dic[@"CommonDoorList"];
            if (![commentArr isKindOfClass:[NSNull class]]&&commentArr.count != 0) {
                isExit = YES;
                
                [commentArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, cell.width-30, 60)];
            lable.font = [UIFont systemFontOfSize:17];
            lable.text = @"·将下面区域的门禁左滑,可加入常用";
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
        OpenDoorModel *model = arr[0];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
        }else{
            UITableViewRowAction *addRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"添加常用"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                
                [self addAction:indexPath];
                
            }];
            
            addRowAction.backgroundColor = [UIColor colorWithHexString:@"#7bbcf9"];
            [arr addObject:addRowAction];
        }
        
    }else{
        if (indexPath.section != 0) {
            // 添加一个按钮
            UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"添加常用"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                
                [self addAction:indexPath];
                
            }];
            deleteRowAction.backgroundColor = [UIColor colorWithHexString:@"#7bbcf9"];
            
            [arr addObject:deleteRowAction];
        }
    }
    // 将设置好的按钮放到数组中返回
    return arr;
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
        entranceVC.dataArr = [arr mutableCopy];
        [self.navigationController pushViewController:entranceVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)addAction:(NSIndexPath *)indexPath
{
    NSString *certIds = [kUserDefaults objectForKey:KUserCertId];
    
    NSArray *arr = _dataArr[indexPath.section];
    
    OpenDoorModel *model = arr[indexPath.row];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/saveCommonDoorLog?doorDeviceId=%@&tagId=%@&deviceAttr=%@&deviceName=%@&deviceType=%@&layerA=%@&layerB=%@&layerC=%@&layerId=%@&certId=%@",MainUrl,model.DEVICE_ID,model.TAGID,model.DEVICE_ADDR,model.DEVICE_NAME,model.DEVICE_TYPE,model.LAYER_A,model.LAYER_B,model.LAYER_C,model.LAYER_ID,certIds];

    NSString *utfStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[NetworkClient sharedInstance] GET:utfStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
    
            if (isExit) {
                
            }else{
                [self.dict setObject:@(0) forKey:@"0"];
            }
            [self _loadData];
        }
        [self showHint:responseObject[@"message"]];
        
    } failure:^(NSError *error) {
        [self showHint:@"添加失败!"];
    }];
}

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"AddCommonlyDoor" object:nil];
}

@end
