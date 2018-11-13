//
//  ParkCarNumTabCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/31.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ParkCarNumTabCell.h"
#import "CarListModel.h"
#import "YQDropDownView1.h"
#import "YQDropDownView2.h"
#import "HGBTitleCell.h"
#import "CarParkModel.h"
#import "ParkAreaStatusCollectionViewCell.h"
#import "ParkAreaStatus2CollectionViewCell.h"
#import "ParkAreaStatusModel.h"
#import "Utils.h"

#define identify_period1 @"cell1"
#define identify_period2 @"cell2"

@interface ParkCarNumTabCell()<YQDropDownDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    __weak IBOutlet UILabel *parkNameLab;
    __weak IBOutlet UILabel *parkCarNumLab;
    __weak IBOutlet UIView *bgView;
    __weak IBOutlet UIView *parkAreaBgView;
    __weak IBOutlet UILabel *parkAreaNameLab;
    
    UICollectionView *collectionView;
    NSMutableArray *parkAreasDataArr;
    UIPageControl *pageControl;
    UICollectionViewFlowLayout *layout;
    NSMutableArray *placeholderDataArr;
    NSInteger currentIndex;
}

/**
 选定时间范围
 */
@property (strong, nonatomic) CarListModel *carModel;
@property (strong, nonatomic) CarParkModel *carParkModel;
@property (nonatomic, strong) YQDropDownView1 *dropDown;
@property (nonatomic, strong) YQDropDownView2 *parkAreaDropDown;
@property (nonatomic, strong) UICollectionView *collectionView;
//  单页宽度
@property (assign, nonatomic) CGFloat pageWidth;

@end

@implementation ParkCarNumTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    bgView.layer.borderColor = [UIColor colorWithHexString:@"#A3A3A3"].CGColor;
    bgView.layer.borderWidth = 0.5;
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = YES;
    
    parkAreaBgView.layer.borderColor = [UIColor colorWithHexString:@"#A3A3A3"].CGColor;
    parkAreaBgView.layer.borderWidth = 0.5;
    parkAreaBgView.layer.cornerRadius = 5;
    parkAreaBgView.clipsToBounds = YES;
    
    [kNotificationCenter addObserver:self selector:@selector(hidePiker:) name:@"hidePickerNotification" object:nil];
    
    parkAreasDataArr = @[].mutableCopy;
    placeholderDataArr = @[].mutableCopy;
    currentIndex = 0;
    
    [kNotificationCenter addObserver:self selector:@selector(refreshParkAreaStatus) name:@"refreshParkAreaStatusNotification" object:nil];
}

-(void)refreshParkAreaStatus
{
    [self _loadParkAreasData:_parkAreaArr[currentIndex] withType:@"0"];
}

-(void)hidePiker:(NSNotification *)notification
{
    [self.dropDown resignDropDownResponder];
    [self.parkAreaDropDown resignDropDownResponder];
}

-(void)setParkAreaArr:(NSMutableArray *)parkAreaArr
{
    _parkAreaArr = parkAreaArr;

    self.parkAreaDropDown = [[YQDropDownView2 alloc] initWithFrame:CGRectMake(parkAreaBgView.left,parkAreaBgView.top,KScreenWidth-parkAreaBgView.left-20,parkAreaBgView.height) pattern:kDropDownPatternCustom];
    self.parkAreaDropDown.delegate = self;
    self.parkAreaDropDown.borderStyle = kDropDownTopicBorderStyleRect;
    self.parkAreaDropDown.tableViewBackgroundColor = [UIColor clearColor];
    self.parkAreaDropDown.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.parkAreaDropDown.cornerRadius = 5*hScale;
    self.parkAreaDropDown.borderColor = [UIColor clearColor];
    self.parkAreaDropDown.shadowOpacity = 0.0;
    [self.contentView addSubview:self.parkAreaDropDown];
    
    CarParkModel *model;
    if (_parkAreaArr.count != 0) {
        model = _parkAreaArr[0];
        [self _loadParkAreasData:model withType:@"0"];
    }
    
    parkAreaNameLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
    parkAreaNameLab.text = [NSString stringWithFormat:@"%@",model.parkingAreaName];
    
    [self initCollectionView];
}

-(void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    CarListModel *model;
    if (_dataArr.count != 0) {
        model = _dataArr[0];
    }
    
    parkCarNumLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
    parkCarNumLab.text = [NSString stringWithFormat:@"%@",model.carNo];
    
    self.dropDown = [[YQDropDownView1 alloc] initWithFrame:CGRectMake(bgView.left,bgView.top,KScreenWidth - bgView.left - 20,bgView.height) pattern:kDropDownPatternCustom];
    self.dropDown.delegate = self;
    self.dropDown.borderStyle = kDropDownTopicBorderStyleRect;
    self.dropDown.tableViewBackgroundColor = [UIColor clearColor];
    self.dropDown.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dropDown.cornerRadius = 5*hScale;
    self.dropDown.borderColor = [UIColor clearColor];
    self.dropDown.shadowOpacity = 0.0;
    [self.contentView addSubview:self.dropDown];
}

#pragma mark dropDownDelegate
- (NSArray *)itemArrayInDropDown:(YQDropDownView *)dropDown{
    if ([dropDown isKindOfClass:[YQDropDownView1 class]]) {
        return _dataArr;
    }else{
        return _parkAreaArr;
    }
}

- (UIView *)viewForTopicInDropDown:(YQDropDownView *)dropDown{
    UIView *backView;
    if ([dropDown isKindOfClass:[YQDropDownView1 class]]) {
        backView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.dropDown.frame.size.width, self.dropDown.frame.size.height)];
        
        CarListModel *model;
        if (_dataArr.count != 0) {
            model = _dataArr[0];
        }
        
        parkCarNumLab.text= model.carNo;
        if(self.carModel){
            NSString *name = self.carModel.carNo;
            if(name&&name.length!=0){
                parkCarNumLab.text=[NSString stringWithFormat:@"%@",name];
            }
        }
    }else{
        backView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.parkAreaDropDown.frame.size.width, self.parkAreaDropDown.frame.size.height)];
        
        CarParkModel *model;
        if (_dataArr.count != 0) {
            model = _parkAreaArr[0];
        }
        
        parkAreaNameLab.text= model.parkingAreaName;
        if(self.carModel){
            NSString *name = self.carParkModel.parkingAreaName;
            if(name&&name.length!=0){
                parkAreaNameLab.text=[NSString stringWithFormat:@"%@",name];
            }
        }
    }
    
    
    return backView;
}

- (UITableViewCell *)dropDown:(YQDropDownView *)dropDown tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIndentifier;
    HGBTitleCell * cell;
    if ([dropDown isKindOfClass:[YQDropDownView1 class]]) {
        cellIndentifier = identify_period1;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[HGBTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.titleLab.frame=CGRectMake(8,0, self.dropDown.frame.size.width-16, self.dropDown.frame.size.height);
            cell.titleLab.font=[UIFont systemFontOfSize:17];
            cell.titleLab.textAlignment=NSTextAlignmentLeft;
            cell.titleLab.textColor=[UIColor blackColor];
        }
        CarListModel * model = _dataArr[indexPath.row];
        cell.titleLab.text= model.carNo;
    }else{
        cellIndentifier = identify_period2;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[HGBTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.titleLab.frame=CGRectMake(8,0, self.parkAreaDropDown.frame.size.width-16, self.parkAreaDropDown.frame.size.height);
            cell.titleLab.font=[UIFont systemFontOfSize:17];
            cell.titleLab.textAlignment=NSTextAlignmentLeft;
            cell.titleLab.textColor=[UIColor blackColor];
        }
        CarParkModel * model = _parkAreaArr[indexPath.row];
        cell.titleLab.text= model.parkingAreaName;
    }
    return cell;
}

- (CGFloat)dropDown:(YQDropDownView *)dropDown heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)dropDown:(YQDropDownView *)dropDown didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([dropDown isKindOfClass:[YQDropDownView1 class]]) {
        if (_dataArr.count != 0) {
            self.carModel = _dataArr[indexPath.row];
            NSString *name = self.carModel.carNo;
            parkCarNumLab.text=[NSString stringWithFormat:@"%@",name];
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
                [self.delegate selectCarNum:self.carModel.carNo withIndex:indexPath.row];
            }
        }
    }else{
        currentIndex = indexPath.row;
        if (_parkAreaArr.count != 0) {
            self.carParkModel = _parkAreaArr[indexPath.row];
            NSString *name = self.carParkModel.parkingAreaName;
            parkAreaNameLab.text=[NSString stringWithFormat:@"%@",name];
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectParkArea:)]) {
                [self.delegate selectParkArea:self.carParkModel];
            }
            [self _loadParkAreasData:self.carParkModel withType:@"1"];
        }
    }
}

-(void)initCollectionView{
    _collectionView = ({
        
        layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(KScreenWidth/4, 120*wScale);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, parkAreaBgView.bottom + 30, KScreenWidth,120*wScale) collectionViewLayout:layout];
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
    return CGSizeMake(KScreenWidth/4, 120*wScale);
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.parkAreaDropDown.frame = CGRectMake(parkAreaBgView.left,parkAreaBgView.top,KScreenWidth-parkAreaBgView.left-20,parkAreaBgView.height);
//    self.dropDown.frame = CGRectMake(bgView.left,bgView.top,KScreenWidth - bgView.left - 20,bgView.height);
//}

@end
