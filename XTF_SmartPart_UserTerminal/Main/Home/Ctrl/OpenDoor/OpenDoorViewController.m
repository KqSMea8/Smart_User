//
//  OpenDoorViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/1.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "OpenDoorViewController.h"

#import "NoDataView.h"
#import "OpenDoorCollectionViewCell.h"
#import "OpenDoorModel.h"
#import "OpenDoorCollectionReusableView.h"

@interface OpenDoorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,reloadDelegate>
{
    NoDataView *nodataView;
    
    OpenDoorModel *_selModel;
}

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation OpenDoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = @[].mutableCopy;
    
    [self _initCollectionView];
    
    [self _initNavItems];
    
    [self _loadData];
}

-(void)_initCollectionView
{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 25);
    //该方法也可以设置itemSize
    
    layout.itemSize = CGSizeMake(110, 60);
    
    //2.初始化collectionView
    //    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView setCollectionViewLayout:layout];
    if (kDevice_Is_iPhoneX) {
        self.collectionView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 83);
    }else
    {
        self.collectionView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight -49);
    }
    
    //4.设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = CViewBgColor;
    self.collectionView.bounces = NO;
    self.collectionView.mj_header.hidden = YES;
    self.collectionView.mj_footer.hidden = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.enablePlaceHolderView = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
    nodataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49)];
    nodataView.delegate = self;
    
    self.collectionView.yh_PlaceHolderView = nodataView;
    self.collectionView.yh_PlaceHolderView.hidden = YES;
    nodataView.hidden = YES;
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerClass:[OpenDoorCollectionViewCell class] forCellWithReuseIdentifier:@"OpenDoorCollectionViewCell"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [self.collectionView registerClass:[OpenDoorCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OpenDoorCollectionReusableView"];
    
    [self.view addSubview:self.collectionView];
}

-(void)_initNavItems
{
    self.title = @"智能开门";
    
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

-(void)_loadData
{
    [self showHudInView:self.view hint:@"加载中~"];
    
    NSString *certIds = [kUserDefaults objectForKey:KUserCertId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/getOpenOwnDoorAuth",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:certIds forKey:@"certIds"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [_dataArr removeAllObjects];
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *arr = dic[@"AuthList"];
            
            NSMutableArray *layerIDarr = @[].mutableCopy;
            NSMutableArray *tempDataArr = @[].mutableCopy;
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OpenDoorModel *model = [[OpenDoorModel alloc] initWithDataDic:obj];
                [layerIDarr addObject:model.LAYER_ID];
                [tempDataArr addObject:model];
            }];
            
            // 直接调用集合是类初始化方法。
            NSSet *set = [NSSet setWithArray:layerIDarr];
            NSArray *layerIdArr = [set allObjects];
            
            NSArray *result = [layerIdArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2]; //升序
            }];
            
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSNumber *layerId = (NSNumber *)obj;
                NSMutableArray *layerArr = @[].mutableCopy;
                [tempDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    OpenDoorModel *model = (OpenDoorModel *)obj;
                    if ([[layerId stringValue] isEqualToString:[NSString stringWithFormat:@"%@",model.LAYER_ID]]) {
                        [layerArr addObject:model];
                    }
                }];
                
                [_dataArr addObject:layerArr];
            }];
            
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
//        DLog(@"%@",error);
        [self hideHud];
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = _dataArr[section];
    return arr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OpenDoorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OpenDoorCollectionViewCell" forIndexPath:indexPath];;
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSArray *arr = _dataArr[indexPath.section];
    
    cell.model = arr[indexPath.row];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 115*wScale;
    if (width < 115) {
        width = 105;
    }
    return CGSizeMake((KScreenWidth-44*wScale)/3, width);
}

//footer的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

//header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    
    size = CGSizeMake(10, 30.0);
    
    return size;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12.0*wScale, 10.0*wScale, 12.0*wScale, 10.0*wScale);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.0*wScale;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0*wScale;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        OpenDoorCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OpenDoorCollectionReusableView" forIndexPath:indexPath];
        
        NSArray *arr = _dataArr[indexPath.section];
        
        OpenDoorModel *model = arr[0];
        
        headerView.titleLab.text = model.LAYER_NAME;
        
        reusableview = headerView;
    }
    
    
    return reusableview;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr = self.dataArr[indexPath.section];
    
    OpenDoorModel *model = arr[indexPath.row];
    _selModel = model;
    
    UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"开门确认" message:[NSString stringWithFormat:@"确认开启%@门禁", model.DEVICE_NAME] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self _unLockTheDoor];
    }];
    [alertControll addAction:cancel];
    [alertControll addAction:ok];
    
    [self presentViewController:alertControll animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 远程开门
-(void)_unLockTheDoor
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/openDoor",MainUrl];
    NSMutableDictionary *param =@{}.mutableCopy;
    if(![_selModel.LAYER_C isKindOfClass:[NSNull class]]&&_selModel.LAYER_C != nil){
        [param setObject:_selModel.LAYER_C forKey:@"doorDeviceId"];
    }
    if(![_selModel.TAGID isKindOfClass:[NSNull class]]&&_selModel.TAGID != nil){
        [param setObject:_selModel.TAGID forKey:@"tagId"];
    }
    if(![_selModel.LAYER_A isKindOfClass:[NSNull class]]&&_selModel.LAYER_A != nil){
        [param setObject:_selModel.LAYER_A forKey:@"param1"];
    }
    [param setObject:@"5768" forKey:@"param2"];
    if(![_selModel.LAYER_B isKindOfClass:[NSNull class]]&&_selModel.LAYER_B != nil){
        [param setObject:_selModel.LAYER_B forKey:@"param3"];
    }
    [param setObject:@"user" forKey:@"appType"];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kCustId] forKey:@"osUser"];
    [param setObject:[kUserDefaults objectForKey:KUserCertId] forKey:@"number"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
//        DLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [self showHint:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
