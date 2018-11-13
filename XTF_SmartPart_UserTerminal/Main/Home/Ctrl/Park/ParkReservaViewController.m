//
//  ParkReservaViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ParkReservaViewController.h"
#import "NoDataView.h"

#import "ParkReservaCollectionViewCell.h"

#import "AptDetailViewController.h"

@interface ParkReservaViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,reloadDelegate>
{
    NoDataView *nodataView;
}

@property (weak, nonatomic) IBOutlet UILabel *parkNameLab;

@property (weak, nonatomic) IBOutlet UILabel *orderParkSpaceLab;

@property (weak, nonatomic) IBOutlet UIView *indroduceLab;

@end

@implementation ParkReservaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initView];
    
    [self _initNavItems];
}

-(void)_initView
{
    [self _initCollectionView];
}

-(void)_initCollectionView
{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    //该方法也可以设置itemSize
    
    layout.itemSize = CGSizeMake(110, 60);
    
    //2.初始化collectionView
    //    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView setCollectionViewLayout:layout];
    if (kDevice_Is_iPhoneX) {
        self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(_orderParkSpaceLab.frame), KScreenWidth, KScreenHeight - 83-44-CGRectGetMaxY(_orderParkSpaceLab.frame)-60-87);
    }else
    {
        self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(_orderParkSpaceLab.frame), KScreenWidth, KScreenHeight -49-20-CGRectGetMaxY(_orderParkSpaceLab.frame)-60-87);
    }
    
    //4.设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = NO;
    self.collectionView.mj_header.hidden = YES;
    self.collectionView.mj_footer.hidden = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.enablePlaceHolderView = YES;
    nodataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49)];
    nodataView.delegate = self;
    
    self.collectionView.yh_PlaceHolderView = nodataView;
    self.collectionView.yh_PlaceHolderView.hidden = YES;
    nodataView.hidden = YES;
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerNib:[UINib nibWithNibName:@"ParkReservaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ParkReservaCollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    
    
}

-(void)_initNavItems
{
    self.title = @"车位预约";
    
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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ParkReservaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParkReservaCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((KScreenWidth-92*wScale)/4, 90*wScale);
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
    
    size = CGSizeMake(10, 0.0);
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0, 10.0*wScale, 25.0, 10.0*wScale);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 24.0*wScale;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 30.0*wScale;
}

- (IBAction)commit:(id)sender {
    AptDetailViewController *aptVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"AptDetailViewController"];
    [self.navigationController pushViewController:aptVC animated:YES];
}

-(void)reload
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
