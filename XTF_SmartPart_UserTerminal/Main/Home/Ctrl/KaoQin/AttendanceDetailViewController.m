//
//  AttendanceDetailViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/26.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "AttendanceDetailViewController.h"
#import "YQEmptyView.h"
#import "Utils.h"
#import "AttDetailTableViewCell.h"
#import "AttDetailOtherTableViewCell.h"
#import "WSDatePickerView.h"
#import "KQDetailModel.h"
#import "KQDetailMonthModel.h"
#import "PopView.h"

@interface AttendanceDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
    int _length;
    UIButton *_searchBtn;
    CGFloat _topHeight;
    NSString *currentDateStr;
    NSDate *currentDate;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@property (nonatomic,strong) NSMutableArray *titleDataArr;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *detailDataArr;
@property (nonatomic,strong) NSMutableArray *monthData;

@end

@implementation AttendanceDetailViewController

-(NSMutableArray *)monthData
{
    if (_monthData == nil) {
        _monthData = [NSMutableArray array];
    }
    return _monthData;
}

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(NSMutableArray *)detailDataArr
{
    if (_detailDataArr == nil) {
        _detailDataArr = [NSMutableArray array];
    }
    return _detailDataArr;
}

-(NSMutableArray *)titleDataArr
{
    if (_titleDataArr == nil) {
        _titleDataArr = [NSMutableArray array];
    }
    return _titleDataArr;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [kNotificationCenter postNotificationName:@"tabbarDidSelectItemNotification" object:nil];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _length = 10;
    
    [self _initView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)_initView {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
    [minDateFormater setDateFormat:@"yyyy-MM"];
    currentDate = [minDateFormater dateFromString:[Utils getCurrentMouth]];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight-33-49);
    }else{
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight-49);
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"AttDetailOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"AttDetailOtherTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AttDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"AttDetailTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadData];
    }];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self loadData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self.view addSubview:self.tableView];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    _searchBtn.frame = CGRectMake(KScreenWidth - 30, 55/2, 20, 20);
    [self.view bringSubviewToFront:_searchBtn];
    [_searchBtn addTarget:self action:@selector(selectDateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchBtn];
    
    _topHeight = 55/2;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadData{
    
    [self loadKqDetailData];
    
}

-(void)loadKqDetailData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/attendanceDetail",MainUrl];
    NSString *certIds = [kUserDefaults objectForKey:KUserCertId];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:certIds forKey:@"certIds"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNumber"];
    [params setObject:[NSString stringWithFormat:@"%d",_length] forKey:@"pageSize"];
    if (![currentDateStr isKindOfClass:[NSNull class]]&&currentDateStr != nil&&currentDateStr.length != 0) {
        NSArray *arr = [currentDateStr componentsSeparatedByString:@","];
        [params setObject:arr[0] forKey:@"startDate"];
        [params setObject:arr[1] forKey:@"endDate"];
    }else{
        
    }
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        
        _searchBtn.enabled = YES;
        
        if(_page == 1){
            [_titleDataArr removeAllObjects];
            [_dataArr removeAllObjects];
            [_detailDataArr removeAllObjects];
            [_monthData removeAllObjects];
        }else{
            NSMutableArray *arr = responseObject[@"responseData"];
            if([responseObject isKindOfClass:[NSNull class]]||arr.count == 0){
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                return;
            }
        }
        
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            NSMutableArray *arr = responseObject[@"responseData"];
            
            if (arr.count == 0||[arr isKindOfClass:[NSNull class]]) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                self.tableView.ly_emptyView = self.noDataView;
                [self.tableView reloadData];
                [self.tableView ly_endLoading];
                return;
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                KQDetailModel *model = [[KQDetailModel alloc] initWithDataDic:obj];
                [self.dataArr addObject:model];
            }];
            
            [self dealData:_dataArr];
        }else{
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            return;
        }
    } failure:^(NSError *error) {
        
        _searchBtn.enabled = YES;
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

-(void)dealData:(NSMutableArray *)data
{
    [_titleDataArr removeAllObjects];
    [_detailDataArr removeAllObjects];
    
    NSMutableArray *monthData = @[].mutableCopy;
    
    KQDetailModel *friModel = data.firstObject;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [friModel.signTime substringWithRange:NSMakeRange(0, friModel.signTime.length-2)];
    __block NSDate *friDate = [dateFormat dateFromString:timeStr];
    
    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    [newFormat setDateFormat:@"yyyy年MM月dd日"];
    __block NSString *friDateStr = [newFormat stringFromDate:friDate];
    
    [data enumerateObjectsUsingBlock:^(KQDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *timeStr1 = [model.signTime substringWithRange:NSMakeRange(0, model.signTime.length-2)];
        NSDate *billDate = [dateFormat dateFromString:timeStr1];
        NSString *billDateStr = [newFormat stringFromDate:billDate];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents *friComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:friDate];
        NSDateComponents *billComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:billDate];
        
        if(friComponents.year == billComponents.year){
            if(friComponents.month == billComponents.month){
                // 同月
                [monthData addObject:model];
            }else {
                [self.titleDataArr addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
                [self.detailDataArr addObject:monthData.copy];
                [monthData removeAllObjects];
                friDate = billDate;
                friDateStr = billDateStr;
                
                [monthData addObject:model];
            }
        }else {
            [self.titleDataArr addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
            [self.detailDataArr addObject:monthData.copy];
            [monthData removeAllObjects];
            friDate = billDate;
            friDateStr = billDateStr;
            
            [monthData addObject:model];
        }
    }];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *friComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:friDate];
    NSDateComponents *newComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate new]];
    
    if(friComponents.year == newComponents.year){
        [self.titleDataArr addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
        [self.detailDataArr addObject:monthData.copy];
    }else {
        [self.titleDataArr addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
        [self.detailDataArr addObject:monthData.copy];
    }
    
    [self loadMonthData];
}

#pragma mark 获取月统计数据
-(void)loadMonthData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/attendanceDetailStatus",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:KUserCertId] forKey:@"certIds"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *arr = [dic allKeys];
            arr = (NSMutableArray *)[arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM"];
                if (obj1 == [NSNull null]) {
                    obj1 = @"0000-00";
                }
                if (obj2 == [NSNull null]) {
                    obj2 = @"0000-00";
                }
                NSDate *date1 = [formatter dateFromString:obj1];
                NSDate *date2 = [formatter dateFromString:obj2];
                NSComparisonResult result = [date1 compare:date2];
                return result == NSOrderedAscending;
            }];
            for (int i = 0; i < [arr count]; i++) {
                NSString *dateStr = [arr objectAtIndex:i];
                NSDictionary *dic1 = dic[dateStr];
                KQDetailMonthModel *monthModel = [[KQDetailMonthModel alloc] initWithDataDic:dic1];
                [self.monthData addObject:monthModel];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.view addSubview:_searchBtn];
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        _searchBtn.enabled = YES;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSArray *arr = _detailDataArr[indexPath.section];
    KQDetailModel *model = arr[indexPath.row];
    if (![model.isFirst isKindOfClass:[NSNull class]]&&model.isFirst != nil&&[model.isFirst isEqualToString:@"1"]) {
        AttDetailTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AttDetailTableViewCell" forIndexPath:indexPath];
        cell1.model = model;
        cell = cell1;
    }else{
        AttDetailOtherTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"AttDetailOtherTableViewCell" forIndexPath:indexPath];
        cell2.model = model;
        cell = cell2;
    }
    return cell;
}

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

#pragma mark UITableView 协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *monthData = _detailDataArr[section];
    return monthData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 75)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
    label.text = [NSString stringWithFormat:@"%@",_titleDataArr[section]];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:label];
    
    UILabel *explainLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+12, KScreenWidth-50, 20)];
    explainLab.font = [UIFont systemFontOfSize:16];
    explainLab.textColor = [UIColor colorWithHexString:@"#888787"];
    
    KQDetailMonthModel *model;
    if (section < _monthData.count) {
        model = _monthData[section];
    }
    NSString *normalDay = [NSString stringWithFormat:@"%@",model.okCount];
    NSString *normalDayStr = [NSString stringWithFormat:@"正常%@天",normalDay];
    
    NSString *reMoney = [NSString stringWithFormat:@"%@",model.errorCount];
    NSString *rechageStr = [NSString stringWithFormat:@"异常%@天",reMoney];
    
    NSString *str = [NSString stringWithFormat:@"%@,%@,%@",normalDayStr,rechageStr,@"蓝色数据为考勤依据"];
    
    NSMutableAttributedString *attriNormalDayStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attriNormalDayStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1B82D1"] range:NSMakeRange(2, normalDay.length)];
    [attriNormalDayStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF4359"] range:NSMakeRange(6+normalDay.length, reMoney.length)];
    explainLab.attributedText = attriNormalDayStr;
    [headView addSubview:explainLab];
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.detailDataArr[indexPath.section];
    KQDetailModel *model = arr[indexPath.row];
    
    NSString *yearAndMonthStr = [model.signTime substringWithRange:NSMakeRange(0, 10)];
    NSString *hourAndMinStr = [model.signTime substringWithRange:NSMakeRange(11, 8)];
    
    NSString *isOutSide;
    if (![model.isOutside isKindOfClass:[NSNull class]]&&model.isOutside != nil&&[model.isOutside isEqualToString:@"1"]) {
        isOutSide = @"1";
    }else{
        isOutSide = @"0";
    }
    
    NSString *dkType;
    if ([model.channel isEqualToString:@"1"]) {
        dkType = @"phone_Dk";
    }else{
        dkType = @"faceRecognition";
    }
    
    PopView *pView = [[PopView alloc] initWithTitle:yearAndMonthStr message:hourAndMinStr delegate:self leftButtonTitle:dkType rightButtonTitle:isOutSide type:kqDetailPopView];
    pView.signImageUrl = model.signImageUrl;
    pView.addressStr = model.signAddr;
    [pView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSetY = scrollView.contentOffset.y;
    
    if (offSetY <= 0) {
        _searchBtn.frame = CGRectMake(_searchBtn.frame.origin.x, _topHeight - offSetY, _searchBtn.frame.size.width, _searchBtn.frame.size.height);
    }
}

#pragma mark 时间选择器
-(void)selectDateAction:(UIButton *)btn
{
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:currentDate CompleteBlock:^(NSDate *selectDate) {
//        NSString *date = [selectDate stringWithFormat:@"yyyy年MM"];
        NSString *date1 = [selectDate stringWithFormat:@"yyyy-MM"];
        
        NSString *selectStr = [Utils getMonthBeginAndEndWith:date1];
        currentDateStr = selectStr;
        currentDate = selectDate;
        _page = 1;
        [self loadData];
        [self.tableView.mj_header beginRefreshing];
        _searchBtn.enabled = NO;
    }];
    datepicker.dateLabelColor = [UIColor colorWithHexString:@"#1B82D1"];
    datepicker.datePickerColor = [UIColor blackColor];
    datepicker.doneButtonColor = [UIColor colorWithHexString:@"#1B82D1"];
    datepicker.yearLabelColor = [UIColor clearColor];
    [datepicker show];
}

@end
