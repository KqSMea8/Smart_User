//
//  ParkReservationAreaCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/11.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ParkReservationAreaCell.h"
#import "CarParkModel.h"
#import "ParkAreaStatusCollectionViewCell.h"
#import "ParkAreaStatus2CollectionViewCell.h"
#import "ParkAreaStatusModel.h"
#import "Utils.h"

@interface ParkReservationAreaCell()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    __weak IBOutlet UILabel *bookAreaLab;
    UICollectionView *collectionView;
    NSMutableArray *parkAreasDataArr;
    UIPageControl *pageControl;
    UICollectionViewFlowLayout *layout;
    NSMutableArray *placeholderDataArr;
    NSInteger currentIndex;
}

@property (nonatomic,retain) NSMutableArray *selectBts;
@property (nonatomic,retain) NSMutableArray *parkNameBtns;
@property (nonatomic,strong) UICollectionView *collectionView;
//  单页宽度
@property (assign, nonatomic) CGFloat pageWidth;
//  手势开始时的起始页数
@property (assign, nonatomic) NSInteger pageOnBeginDragging;
//  手势开始时scrollView的contentOffset.X
@property (assign, nonatomic) CGFloat offsetXOnBeginDragging;

@end

@implementation ParkReservationAreaCell

-(NSMutableArray *)selectBts
{
    if (_selectBts == nil) {
        _selectBts = [NSMutableArray array];
    }
    return _selectBts;
}

-(NSMutableArray *)parkNameBtns
{
    if (_parkNameBtns == nil) {
        _parkNameBtns = [NSMutableArray array];
    }
    return _parkNameBtns;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    parkAreasDataArr = @[].mutableCopy;
    placeholderDataArr = @[].mutableCopy;
    currentIndex = 0;
    [kNotificationCenter addObserver:self selector:@selector(refreshParkAreaStatus) name:@"refreshParkAreaStatusNotification" object:nil];
}

-(void)refreshParkAreaStatus
{
    [self _loadParkAreasData:_dataArr[currentIndex] withType:@"0"];
}

-(void)initCollectionView{
    _collectionView = ({
        
        layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(KScreenWidth/4, 90*wScale);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UIButton *btn = self.parkNameBtns.lastObject;
        
        collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, btn.bottom + 25, KScreenWidth,90*wScale) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        collectionView.dataSource = self;
        collectionView.scrollsToTop = NO;
        collectionView.pagingEnabled = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerNib:[UINib nibWithNibName:@"ParkAreaStatusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ParkAreaStatusCollectionViewCell"];
        [collectionView registerNib:[UINib nibWithNibName:@"ParkAreaStatus2CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ParkAreaStatus2CollectionViewCell"];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellNormal"];
        [self.contentView addSubview:collectionView];
        collectionView;
    });
    
    self.pageWidth = self.contentView.frame.size.width/2;
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _collectionView.bottom + 5, 60, 20)];
    pageControl.centerX = self.contentView.frame.size.width/2;
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#efefef"];
    pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:pageControl];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return placeholderDataArr.count;
}

//每个单元格的大小size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(KScreenWidth/4, 90*wScale);
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if (indexPath.row > parkAreasDataArr.count-1) {
        UICollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellNormal" forIndexPath:indexPath];
        cell = cell1;
    }else{
        ParkAreaStatusModel *model = parkAreasDataArr[indexPath.row];
        if ([model.parkingStatus isEqualToString:@"0"]) {
            ParkAreaStatus2CollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParkAreaStatusCollectionViewCell" forIndexPath:indexPath];
            cell1.model = model;
            cell = cell1;
        }else if ([model.parkingStatus isEqualToString:@"1"]){
            ParkAreaStatusCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParkAreaStatusCollectionViewCell" forIndexPath:indexPath];
            cell1.model = model;
            cell = cell1;
        }else if ([model.parkingStatus isEqualToString:@"2"]){
            ParkAreaStatusCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParkAreaStatusCollectionViewCell" forIndexPath:indexPath];
            cell1.model = model;
            cell = cell1;
        }else if ([model.parkingStatus isEqualToString:@"3"]){
            ParkAreaStatus2CollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParkAreaStatus2CollectionViewCell" forIndexPath:indexPath];
            cell1.model = model;
            cell = cell1;
        }else if ([model.parkingStatus isEqualToString:@"4"]){
            ParkAreaStatus2CollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParkAreaStatus2CollectionViewCell" forIndexPath:indexPath];
            cell1.model = model;
            cell = cell1;
        }else{
            ParkAreaStatusCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParkAreaStatusCollectionViewCell" forIndexPath:indexPath];
            cell1.model = model;
            cell = cell1;
        }
    }
    return cell;
}

//-(void)setDataArr:(NSMutableArray *)dataArr
//{
//    _dataArr = dataArr;
//    if ([_dataArr isKindOfClass:[NSNull class]]||_dataArr == nil||_dataArr.count == 0) {
//        return;
//    }
//    
//    [self initSubviews:dataArr];
//}

-(void)initSubviews:(NSMutableArray *)arr
{
    
    for (int i = 0; i < arr.count; i++) {
        CarParkModel *model = arr[i];
        UIButton *btn = [self viewWithTag:100+i];
        if (btn != nil) {
            [btn removeFromSuperview];
        }
        UIButton *selectBtn = [[UIButton alloc] init];
        selectBtn.tag = 100 + i;
        [selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.frame = CGRectMake(bookAreaLab.right, 27 + 51*i, 20, 20);
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"round_select"] forState:UIControlStateSelected];
        if (i == currentIndex) {
            selectBtn.selected = YES;
            selectBtn.layer.borderWidth = 0.5;
            selectBtn.layer.borderColor = [UIColor clearColor].CGColor;
        }else{
            selectBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
            selectBtn.layer.borderWidth = 0.5;
            selectBtn.selected = NO;
        }
        selectBtn.layer.cornerRadius = 10;
        [self addSubview:selectBtn];
        [self.selectBts addObject:selectBtn];
        
        UIButton *btn1 = [self viewWithTag:200+i];
        if (btn1 != nil) {
            [btn1 removeFromSuperview];
        }
        UIButton *parkNameBtn = [[UIButton alloc] init];
        parkNameBtn.tag = 200 + i;
        [parkNameBtn addTarget:self action:@selector(parkNameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [model.parkingAreaName sizeForFont:[UIFont systemFontOfSize:17] size:CGSizeMake(200, 40) mode:NSLineBreakByCharWrapping];
        parkNameBtn.frame = CGRectMake(selectBtn.right + 10, 0, size.width+10, 40);
        parkNameBtn.centerY = selectBtn.centerY;
        [parkNameBtn setTitle:model.parkingAreaName forState:UIControlStateNormal];
        [parkNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [parkNameBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        if (i == currentIndex) {
            parkNameBtn.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
        }else{
            parkNameBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        }
        parkNameBtn.layer.cornerRadius = 5;
        parkNameBtn.layer.borderWidth = 0.5;
        [self addSubview:parkNameBtn];
        [self.parkNameBtns addObject:parkNameBtn];
    }
    
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
        [self.delegate selectParkArea:_dataArr[currentIndex]];
        [self _loadParkAreasData:_dataArr[currentIndex] withType:@"0"];
    }
    
    [self initCollectionView];
}

-(void)parkNameBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 200;
    [self _loadParkAreasData:_dataArr[index] withType:@"1"];
    currentIndex = index;
    switch (index) {
        case 0:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
                [self.delegate selectParkArea:_dataArr[index]];
            }
            [self changeBtState:btn];
            
            break;
        case 1:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
                [self.delegate selectParkArea:_dataArr[index]];
            }
            [self changeBtState:btn];
            break;
        case 2:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
                [self.delegate selectParkArea:_dataArr[index]];
            }
            [self changeBtState:btn];
            break;
        case 3:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
                [self.delegate selectParkArea:_dataArr[index]];
            }
            [self changeBtState:btn];
            break;
        case 4:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
                [self.delegate selectParkArea:_dataArr[index]];
            }
            [self changeBtState:btn];
            break;
            
        default:
            break;
    }
}

- (void)changeBtState:(UIButton *)selBt {
    
    [_parkNameBtns enumerateObjectsUsingBlock:^(UIButton *numBt, NSUInteger idx, BOOL * _Nonnull stop) {
        numBt.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    }];
    
    selBt.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
    
    [_selectBts enumerateObjectsUsingBlock:^(UIButton *selectBt, NSUInteger idx, BOOL * _Nonnull stop) {
        selectBt.selected = NO;
        selectBt.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    }];
    
    UIButton *selectBtn = [self viewWithTag:(selBt.tag - 100)];
    selectBtn.selected = YES;
    selectBtn.layer.borderColor = [UIColor clearColor].CGColor;
}

-(void)selectBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 100;
    currentIndex = index;
    [self _loadParkAreasData:_dataArr[index] withType:@"1"];
    switch (index) {
        case 0:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
                [self.delegate selectParkArea:_dataArr[index]];
            }
            [self changeSelectBtState:btn];
            
            break;
        case 1:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
                [self.delegate selectParkArea:_dataArr[index]];
            }
            [self changeSelectBtState:btn];
            break;
        case 2:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
                [self.delegate selectParkArea:_dataArr[index]];
            }
            [self changeSelectBtState:btn];
            break;
        case 3:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
                [self.delegate selectParkArea:_dataArr[index]];
            }
            [self changeSelectBtState:btn];
            break;
        case 4:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
                [self.delegate selectParkArea:_dataArr[index]];
            }
            [self changeSelectBtState:btn];
            break;
            
        default:
            break;
    }
}

- (void)changeSelectBtState:(UIButton *)selBt {
    
    [_selectBts enumerateObjectsUsingBlock:^(UIButton *selectBt, NSUInteger idx, BOOL * _Nonnull stop) {
        selectBt.selected = NO;
        selectBt.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    }];
    
    selBt.selected = YES;
    selBt.layer.borderColor = [UIColor clearColor].CGColor;
    
    [_parkNameBtns enumerateObjectsUsingBlock:^(UIButton *numBt, NSUInteger idx, BOOL * _Nonnull stop) {
        numBt.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    }];
    
    UIButton *selectBtn = [self viewWithTag:(selBt.tag + 100)];
    selectBtn.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
}

-(void)_loadParkAreasData:(CarParkModel *)model withType:(NSString *)type
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/getParkingSpaces",MainUrl];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:@"1001" forKey:@"parkingId"];
    [param setObject:model.parkingAreaId forKey:@"parkingAreaId"];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    NSString *jsonStr = [Utils convertToJsonData:param];
    [params setObject:jsonStr forKey:@"param"];
    
    if ([type isEqualToString:@"1"]) {
        [self.viewController showHudInView:kAppWindow hint:nil];
    }
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if ([type isEqualToString:@"1"]) {
            [self.viewController hideHud];
        }
        [parkAreasDataArr removeAllObjects];
        [placeholderDataArr removeAllObjects];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *parkAreaDic = responseObject[@"responseData"];
            if (![parkAreaDic isKindOfClass:[NSNull class]]) {
                NSString *parkAreaNum = model.parkingAreaId;
                NSDictionary *dataDic = parkAreaDic[parkAreaNum];
                NSArray *dataArr = dataDic[@"items"];
                if (dataArr.count/4<1) {
                    pageControl.numberOfPages = 1;
                }else{
                    pageControl.numberOfPages = (dataArr.count/4)+1;
                }
                
                [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ParkAreaStatusModel *model = [[ParkAreaStatusModel alloc] initWithDataDic:obj];
                    [parkAreasDataArr addObject:model];
                    [placeholderDataArr addObject:model];
                }];
                
                if (dataArr.count%4 == 1){
                    ParkAreaStatusModel *model = [[ParkAreaStatusModel alloc] init];
                    [placeholderDataArr addObject:model];
                    [placeholderDataArr addObject:model];
                    [placeholderDataArr addObject:model];
                }else if (dataArr.count%4 == 2){
                    ParkAreaStatusModel *model = [[ParkAreaStatusModel alloc] init];
                    [placeholderDataArr addObject:model];
                    [placeholderDataArr addObject:model];
                }else if (dataArr.count%4 == 3){
                    ParkAreaStatusModel *model = [[ParkAreaStatusModel alloc] init];
                    [placeholderDataArr addObject:model];
                }
            }
            NSString *avalibleNum = [parkAreaDic[@"avalibleNum"] stringValue];
            if ([avalibleNum isEqualToString:@"0"]) {
                [kNotificationCenter postNotificationName:@"reservationNoAvalibleNotification" object:nil];
            }else{
                [kNotificationCenter postNotificationName:@"reservationAvalibleNotification" object:nil];
            }
        }
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        if ([type isEqualToString:@"1"]) {
            [self.viewController hideHud];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    int i = (offsetX + self.pageWidth*0.5)/self.pageWidth;
    pageControl.currentPage = i;
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.pageOnBeginDragging = pageControl.currentPage;
//    self.offsetXOnBeginDragging = scrollView.contentOffset.x;
//}
///*
// 这个代理方法在用户拖拽即将结束时被调用，velocity代表结束时scrollView滚动的速度
// velocity > 0代表正在往contentOffset值增加的方向滚动，
// velocity < 0滚动方向相反
//
// targetContentOffset参数有inout修饰，可以通过修改改值决定最终scrollView滚动到的位置，一看就是用来判断/实现翻页的完美方法 :D
// */
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    CGFloat targetX = (*targetContentOffset).x;
//    NSInteger targetPage = self.pageOnBeginDragging;
//    //  综合考虑velocity和targetContentOffset这两方面因素决定targetpage
//    if (velocity.x == 0) {
//        targetPage = (targetX + self.pageWidth*0.5)/self.pageWidth;
//    } else {
//        NSInteger vote = 0;
//        vote = velocity.x>0 ? vote+1:vote-1;
//        vote = (scrollView.contentOffset.x-self.offsetXOnBeginDragging >0)? vote+1:vote-1;
//        if (vote>0 && (targetPage+1<pageControl.numberOfPages)) {
//            targetPage++;
//        }
//        if (vote<0 && targetPage-1>=0) {
//            targetPage--;
//        }
//    }
//    //  根据民主投票决定的targetPage计算最终的targetContentOffset，设置targetContentOffset
//    CGPoint offset = CGPointMake(self.pageWidth*targetPage, 0);
//    *targetContentOffset = offset;
//}
//

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"refreshParkAreaStatusNotification" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
