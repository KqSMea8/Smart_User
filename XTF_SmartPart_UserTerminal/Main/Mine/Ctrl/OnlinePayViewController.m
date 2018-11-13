//
//  OnlinePayViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/25.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "OnlinePayViewController.h"
#import "NetPayTableViewCell.h"
#import "Utils.h"
#import "WSDatePickerView.h"
#import "BillDetailsViewController.h"
#import "NetPayModel.h"
#import "AESUtil.h"
#import "YQEmptyView.h"

@interface OnlinePayViewController()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_billData;
    
    NSMutableArray *_monthBillData;
    NSMutableArray *_monthTitleData;
    
    int _page;
    UIButton *_searchBtn;
    CGFloat _topHeight;
    
    NSString *currentDateStr;
    NSDate *currentDate;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation OnlinePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _billData = @[].mutableCopy;
    _monthBillData = @[].mutableCopy;
    _monthTitleData = @[].mutableCopy;
    
    _page = 1;
    
    [self _initView];
    
    [self _loadBalanceDetailData];
    
    [self.tableView.mj_header beginRefreshing];
    
    YYReachability *rech = [YYReachability reachability];
    if (!rech.reachable) {
        self.tableView.ly_emptyView = self.noNetworkView;
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    }
}

- (void)_initView {
    
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
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight - 60);
    [self.tableView registerNib:[UINib nibWithNibName:@"NetPayTableViewCell" bundle:nil] forCellReuseIdentifier:@"NetPayTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    //    self.tableView.mj_header.hidden = YES;
    //    self.tableView.mj_footer.hidden = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self _loadBalanceDetailData];
    }];
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self _loadBalanceDetailData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self.view addSubview:self.tableView];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    _searchBtn.frame = CGRectMake(KScreenWidth - 30, 55/2, 20, 20);
    [self.view bringSubviewToFront:_searchBtn];
    [_searchBtn addTarget:self action:@selector(selectDateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _topHeight = 55/2;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectDateAction:(UIButton *)btn
{
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:currentDate CompleteBlock:^(NSDate *selectDate) {
        //        NSString *date = [selectDate stringWithFormat:@"yyyy年MM"];
        NSString *date1 = [selectDate stringWithFormat:@"yyyy-MM"];
        currentDateStr = date1;
        currentDate = selectDate;
        _page = 1;
        [self _loadBalanceDetailData];
        [self.tableView.mj_header beginRefreshing];
        _searchBtn.enabled = NO;
        
    }];
    datepicker.dateLabelColor = [UIColor colorWithHexString:@"#1B82D1"];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor colorWithHexString:@"#1B82D1"];//确定按钮的颜色
    datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
    [datepicker show];
}

#pragma mark 加载余额明细数据
-(void)_loadBalanceDetailData
{
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/consumeOrder/getConsumeSourceForAlipay",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNo"];
    [params setObject:@"10" forKey:@"pageSize"];
    if (currentDateStr != nil&&![currentDateStr isKindOfClass:[NSNull class]]) {
        [params setObject:currentDateStr forKey:@"selectByMonth"];
    }else{
        [params setObject:@"" forKey:@"selectByMonth"];
    }
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        _searchBtn.enabled = YES;
        if(_page == 1){
            [_billData removeAllObjects];
            [_monthBillData removeAllObjects];
            [_monthTitleData removeAllObjects];
        }
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSArray *arr = responseObject[@"responseData"];
            
            if ([arr isKindOfClass:[NSNull class]]) {
//                _searchBtn.hidden = YES;
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                
                self.tableView.ly_emptyView = self.noDataView;
                [self.tableView reloadData];
                [self.tableView ly_endLoading];
                return;
            }else{
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NetPayModel *model = [[NetPayModel alloc] initWithDataDic:obj];
                [_billData addObject:model];
            }];
            [self dealData:_billData];
        }else{
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
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

- (void)dealData:(NSMutableArray *)billData {
    [_monthTitleData removeAllObjects];
    [_monthBillData removeAllObjects];
    
    NSMutableArray *monthData = @[].mutableCopy;
    
    NetPayModel *friModel = billData.firstObject;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    __block NSDate *friDate = [dateFormat dateFromString:friModel.orderPayDate];
    
    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    [newFormat setDateFormat:@"yyyy年MM月dd日"];
    __block NSString *friDateStr = [newFormat stringFromDate:friDate];
    
    [billData enumerateObjectsUsingBlock:^(NetPayModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *billDate = [dateFormat dateFromString:model.orderPayDate];
        NSString *billDateStr = [newFormat stringFromDate:billDate];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents *friComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:friDate];
        NSDateComponents *billComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:billDate];
        
        if(friComponents.year == billComponents.year){
            if(friComponents.month == billComponents.month){
                // 同月
                [monthData addObject:model];
            }else {
                //                [_dateDic setObject:monthData.copy forKey:[friDateStr substringWithRange:NSMakeRange(5, 3)]];
                [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
                [_monthBillData addObject:monthData.copy];
                [monthData removeAllObjects];
                friDate = billDate;
                friDateStr = billDateStr;
                
                [monthData addObject:model];
            }
            
        }else {
            //            [_dateDic setObject:monthData forKey:[friDateStr substringWithRange:NSMakeRange(5, 3)]];
            [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
            [_monthBillData addObject:monthData.copy];
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
        //        [_dateDic setObject:monthData.copy forKey:[friDateStr substringWithRange:NSMakeRange(5, 3)]];
        [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
        [_monthBillData addObject:monthData.copy];
    }else {
        //        [_dateDic setObject:monthData.copy forKey:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
        [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
        [_monthBillData addObject:monthData.copy];
    }
    
    [self.view addSubview:_searchBtn];
    [self.tableView reloadData];
    [self.tableView ly_endLoading];
}

- (YQEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [YQEmptyView diyEmptyView];
    }
    return _noDataView;
}

- (YQEmptyView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [YQEmptyView diyEmptyActionViewWithTarget:self action:@selector(_loadBalanceDetailData)];
    }
    return _noNetworkView;
}

#pragma mark UITableView 协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _monthTitleData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *monthData = _monthBillData[section];
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
    label.text = _monthTitleData[section];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:label];
    
    NSArray *monthData = _monthBillData[section];
    NetPayModel *model = monthData[0];
    
    UILabel *conLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+12, 100, 20)];
    conLabel.textColor = [UIColor colorWithHexString:@"#888787"];
//    NSString *conMoney = [AESUtil decryptAES:model.consumeSum key:AESKey];
    NSString *conMoney = model.consumeSum;
    NSString *conMoneyStr = [NSString stringWithFormat:@"%.1f",[conMoney floatValue]/100.00];
    NSString *MoneyStr = [NSString stringWithFormat:@"消费%@元",conMoneyStr];
    NSMutableAttributedString *attriMoneyStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [attriMoneyStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF4359"] range:NSMakeRange(2, conMoneyStr.length)];
    
    CGSize size = [MoneyStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    conLabel.size = size;
    
    conLabel.attributedText = attriMoneyStr;
    conLabel.font = [UIFont systemFontOfSize:16];
    conLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:conLabel];
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NetPayTableViewCell *netPayCell = [tableView dequeueReusableCellWithIdentifier:@"NetPayTableViewCell" forIndexPath:indexPath];
    NSArray *monthBill = _monthBillData[indexPath.section];
    NetPayModel *model = monthBill[indexPath.row];
    netPayCell.model = model;
    return netPayCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *monthBill = _monthBillData[indexPath.section];
    NetPayModel *netPayModel = monthBill[indexPath.row];
    
    BillDetailsViewController *billDetVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BillDetailsViewController"];
    billDetVC.orderId = netPayModel.orderId;
    billDetVC.isNetworkPay = YES;
    [self.navigationController pushViewController:billDetVC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY <= 0) {
        _searchBtn.frame = CGRectMake(_searchBtn.frame.origin.x, _topHeight - offSetY, _searchBtn.frame.size.width, _searchBtn.frame.size.height);
    }
}


@end

